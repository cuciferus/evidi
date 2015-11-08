-module(utile).
-compile(export_all).

transforma_timp(Timp) ->
	[Ora, Minut] = string:tokens(Timp, ":"),
	{OraNumar, _} = string:to_integer(Ora),
	{MinutNumar, _} = string:to_integer(Minut),
	{OraNumar, MinutNumar, 0}.

transforma_data(Data) ->
	[Zi, Luna, An] = string:tokens(Data, "/"),
	{ZiNumar, _} = string:to_integer(Zi),
	{LunaNumar, _} = string:to_integer(Luna),
	{AnNumar, _} = string:to_integer(An),
	{AnNumar, LunaNumar, ZiNumar}.

jsonifica(Rezultat) ->
    {ok, Coloane, Valori} = Rezultat,
    NumeColoane = [X || {_, X, _,_,_,_} <- Coloane],
    jsonifica_doi(NumeColoane, Valori).

jsonifica_doi(Coloane,Valori) ->
    jsonifica_doi(Coloane, Valori, []).

jsonifica_doi(Coloane, [H|T], Jsonificate) ->
    Noi = lists:zip(Coloane, tuple_to_list(H)),
    jsonifica_doi(Coloane, T, lists:append(Jsonificate, Noi));
jsonifica_doi(_Coloane, [], Jsonificate) -> 
    [Jsonificate].

ora_urmatoarei_programari({Ora, Minut,Secunda}, Durata) when (Minut+Durata)<60 ->
    {Ora, Minut+Durata, Secunda};
ora_urmatoarei_programari({Ora, Minut, Secunda}, Durata) ->
    MinutFinal = Minut + Durata,
    {Ora+(MinutFinal div 60), (Minut+Durata) rem 60, Secunda}.



genereaza_programari(_Data, _Cand, _Durata, 0) -> ok;%formatul datei e an, luna, zi
genereaza_programari(Data , Cand , Durata, Numar) -> % na că acum nu creste ora
    Programare = programare:new(id, Data, Cand, Durata, "pacient-1"),
    Programare:save(),
    genereaza_programari(Data, ora_urmatoarei_programari(Cand, Durata), Durata, Numar-1).



programZi([Zi, Luna, An], DurataConsultului) ->
    Programari = boss_db:find(programare, [{data, 'equals', string:join([An, Luna, Zi], "-")}], [{order_by, ora}]), 
    Pacienti = [ boss_db:find(PacientId) || {programare, _,_,_,_,PacientId} <-Programari],
    OreInterval = [{Ora, Minut, DurataConsultului} || Ora<-lists:seq(1,12), Minut<-lists:seq(1,60,DurataConsultului)],
    ProgramariCuPacienti = combinaProgramariCuPacienti(Programari, Pacienti, []),
    ProgramulZileiCuProgramari = combinaOreleCuProgramarile2(OreInterval, ProgramariCuPacienti),
    ProgramulZileiCuProgramari.

%combinaProgramariCuPacienti(Programari, Pacienti) -> combinaProgramariCuPacienti(Programari, Pacienti, []).
combinaProgramariCuPacienti([],[], Combinati) ->Combinati;
combinaProgramariCuPacienti([Programare|RestulProgramarilor], [Pacient|RestulPacientilor], Combinati) ->
    combinaProgramariCuPacienti(RestulProgramarilor, RestulPacientilor, [{Programare, Pacient}|Combinati]).




combinaOreleCuProgramarile2(Ore, Programari) -> combinaOreleCuProgramarile2(Ore, Programari,[]).


combinaOreleCuProgramarile2([Ora|Ore], [], ProgramFinal) -> combinaOreleCuProgramarile2(Ore, [], [Ora|ProgramFinal]); %daca ultima din lista e programare si nu e pauza?
combinaOreleCuProgramarile2([Ora = {OraMomentului, MinutulMomentului, DurataConsultului}|Ore], 
                            [Programare= {{programare, _Id, _Data, {OraProgramarii, MinutulProgramarii, _SecundaProgramarii}, Durata, _PacientId}, _Pacient}|Restul], ProgramFinal) when OraMomentului == OraProgramarii ->
    io:fwrite("mai sunt ~p programari~n", [length(Restul)]),
    if (MinutulMomentului+DurataConsultului < MinutulProgramarii)  -> 
           if (MinutulMomentului+Durata >60) ->
                  OraNoua = OraMomentului+((MinutulMomentului+Durata) div DurataConsultului),
                  MinutulMomentului = MinutulProgramarii+(Durata rem DurataConsultului),
                   combinaOreleCuProgramarile2(lists:nthtail((Durata rem DurataConsultului), Ora), Restul, [Programare|ProgramFinal]);
              true ->
                  io:fwrite("acum trebuie sa vad cate Consultuli dureaza"),
                  combinaOreleCuProgramarile2(lists:nthtail((Durata div DurataConsultului), Ore), Restul, [Programare|ProgramFinal])
           end;
       true -> io:fwrite("dar nu am nimerit intervalu~n"), combinaOreleCuProgramarile2(Ore, [Programare|Restul], [Ora|ProgramFinal])
    end;
combinaOreleCuProgramarile2([Ora|Ore], ProgramariTotal= [Programare|Programari], ProgramFinal) ->
    combinaOreleCuProgramarile2(Ore, ProgramariTotal, [Ora|ProgramFinal]);

combinaOreleCuProgramarile2([],[], ProgramFinal) -> ProgramFinal;
combinaOreleCuProgramarile2([], Programari, ProgramFinal) -> ProgramFinal.%??
jsonifica_unu(Coloane,Valori) -> 
    jsonifica_unu(Coloane, Valori,[]).

jsonifica_unu(Coloane, [H|T], [Jsonificate]) ->
    %io:fwrite("lungimea numelor e ~p iar a valorilor e ~p~n", [length(Coloane), length(tuple_to_list(H))]),
    %io:fwrite("valorea de jsonificat e ~p~n", [H]),
    Jsony = lists:zip(Coloane, tuple_to_list(H)),
    jsonifica_unu(Coloane, T, [Jsonificate|Jsony]);%am o singura lista??
jsonifica_unu(_Coloane, [], Jsonificate) -> 
    Jsonificate.


