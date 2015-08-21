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

jsonifica_unu(Coloane,Valori) -> 
    jsonifica_unu(Coloane, Valori,[]).

jsonifica_unu(Coloane, [H|T], [Jsonificate]) ->
    %io:fwrite("lungimea numelor e ~p iar a valorilor e ~p~n", [length(Coloane), length(tuple_to_list(H))]),
    %io:fwrite("valorea de jsonificat e ~p~n", [H]),
    Jsony = lists:zip(Coloane, tuple_to_list(H)),
    jsonifica_unu(Coloane, T, [Jsonificate|Jsony]);%am o singura lista??
jsonifica_unu(_Coloane, [], Jsonificate) -> 
    Jsonificate.

jsonifica_doi(Coloane,Valori) ->
    jsonifica_doi(Coloane, Valori, []).

jsonifica_doi(Coloane, [H|T], Jsonificate) ->
    Noi = lists:zip(Coloane, tuple_to_list(H)),
    jsonifica_doi(Coloane, T, lists:append(Jsonificate, Noi));
jsonifica_doi(_Coloane, [], Jsonificate) -> 
    [Jsonificate].

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
                            [Programare= {{programare, _Id, _Data, {OraProgramarii, MinutulProgramarii, _SecundaProgramarii}}, _Pacient}|Restul], ProgramFinal) when OraMomentului == OraProgramarii ->
    io:fwrite("sa zicem ca am programare la ora asta"),
    if (MinutulMomentului+DurataConsultului < MinutulProgramarii) and (MinutulMomentului > MinutulProgramarii) -> 
           combinaOreleCuProgramarile2([Ora|Ore], Restul, [Programare|ProgramFinal]);
       true -> io:fwrite("dar nu am nimerit intervalu"), combinaOreleCuProgramarile2(Ore, [Programare|Restul], [Ora|ProgramFinal])
    end;
combinaOreleCuProgramarile2([Ora|Ore], ProgramariTotal= [Programare|Programari], ProgramFinal) ->
    io:fwrite("programarea e ~p~n", [Programare]),
    combinaOreleCuProgramarile2(Ore, ProgramariTotal, [Ora|ProgramFinal]);
combinaOreleCuProgramarile2([],[], ProgramFinal) -> ProgramFinal.

    



