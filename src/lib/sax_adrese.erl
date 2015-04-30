-module(sax_adrese).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").
-include_lib("stdlib/include/qlc.hrl").

-include_lib("cim.hrl").


-define(XML, "./src/lib/nomenclator.xml").


init_adrese() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(judete, [{attributes, record_info(fields, judete)}]),
    mnesia:create_table(oras, [{type, bag},
            {attributes, record_info(fields, oras)}]),
    mnesia:create_table(strada, [{type, bag},
            {attributes, record_info(fields, strada)}]).

insert_judet(Cod, Nume, Tara) ->
    Fun = fun() ->
            mnesia:write(
              #judete{nume= Nume,
                     cod = Cod,
                      tara_id = Tara})
          end,
    mnesia:transaction(Fun).


insereaza_strada(Cod, Nume, CodOras, TipStrada) ->
    Fun = fun() ->
                  mnesia:write(
                    #strada{nume = Nume,
                            cod = Cod,
                            oras_id = CodOras,
                            stradatype_id = TipStrada})
          end,
    mnesia:transaction(Fun).

                            
insert_oras(Cod, Nume, JudetId, TipOrasId) ->
    Fun = fun() ->
        mnesia:write(
          #oras{cod = Cod,
                nume = Nume,
                tiporas_id = TipOrasId,
                judet_id = JudetId})
          end,
    mnesia:transaction(Fun).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.



lista_tari() ->
    Tari = [ {Cod, Id} || { tari, Id,Cod,_} <- boss_db:find(tari,[])],
    cauta_judete(Tari).

cauta_judete(Tari) -> cauta_judete(Tari, []).

cauta_judete([], Acc) -> Acc;
cauta_judete([Tara|T], Acc) ->
    {Cod, Id} = Tara,
    %Judete= do(qlc:q([{X#judete.nume, X#judete.cod} || X<-mnesia:table(judete), X#judete.cod == Cod])),
    ToateJudetele= do(qlc:q([{X#judete.nume, X#judete.cod} || X<- mnesia:table(judete) ])), %%WTF de ce merge asta?
    salveaza_judete(Id, ToateJudetele).
    %cauta_judete(T, [Judete,Acc]).

salveaza_judete(_, []) ->ok; 
salveaza_judete(Id, [Judet|Restu]) ->
    {Nume, Cod} = Judet,
    JudetNou = judete:new(id, Nume, Cod,Id),
    {ok, JudetSalvat} = JudetNou:save(),
    cauta_orase(JudetSalvat),
    salveaza_judete(Id, Restu).

cauta_orase(Judet) -> 
    Orase = do(qlc:q([{X#oras.nume, X#oras.cod, X#oras.tiporas_id} || X<-mnesia:table(oras)])),
    salveaza_oras(Judet:id(), Orase).

salveaza_oras(_,[]) ->ok;
salveaza_oras(NrJudet, [Oras|Restu]) ->
    {Nume, Cod, CodTipJudet} = Oras, 
    io:fwrite("ajunge sa salveze un oras"),
    CityType= cauta_city_type(CodTipJudet),
    OrasNou = city:new(id, Cod, Nume, CityType:id(), NrJudet), 
    {ok, _OrasSalvat} = OrasNou:save(),
    cauta_strazi_din_oras(Cod),
    salveaza_oras(NrJudet, Restu).

cauta_strazi_din_oras(OrasCod) ->
    Strazi = do(qlc:q([{ X#strada.nume, X#strada.cod,X#strada.oras_id, X#strada.stradatype_id} || X<-mnesia:table(strada), X#strada.oras_id == OrasCod])),
    salveaza_strada(Strazi).

salveaza_strada([]) ->ok;
salveaza_strada([Ostrada|Restu]) ->
    {Nume,Cod, _StreetTypeCode, CityId} = Ostrada,
    CodStrada = boss_db:find_first(strada_type, [{cod,'matches', Cod}]),
    StradaNoua = street:new(id, Nume, Cod, CodStrada:id(), CityId),
    {ok, _StradaSalvata} = StradaNoua:save(),
    salveaza_strada(Restu).

     

cauta_city_type(CodTypeJudet) -> %am uitat sa salvez city type????
    boss_db:find_first(city_type, [{cod, 'matches',CodTypeJudet}]).


%aici mai e nevoie si de strada pampam




parse_adresa() ->
    init_adrese(),
    xmerl_sax_parser:file(?XML,[
            {event_fun,
             fun
             ({startElement, _,"Country",_Ceva, [{_,_,"code", Codu}, {_,_,"name", Numele}]}, _Location, _State) ->
                    %% <Country  code="RE61" name="REPUBLICA CEHA"/>
                     Tara = tari:new(id, Codu,Numele),
                     {ok, _} = Tara:save();
             ({startElement, _, "District", _Ceva, [{_,_, "code", Codu}, {_,_,"name", Nume}, {_,_,"country", Tara}]}, _Location, _State) ->
                     insert_judet(Nume, Codu, Tara);
                     %% <District  code="CT" name="CONSTANTA" country="ROM"/>
             ({startElement, _, "CityType", _Ceva, [{_,_, "code", Cod}, {_,_,"name", Nume}, {_,_,"urbanFlag",_Numitrebuie}]},_Location, _State) ->
                     TipJudet = city_type:new(id, Cod, Nume),
                     {ok, _} = TipJudet:save();
             %({startElement, _, "CityType", _Ceva, [{_,_, "code", Cod}, {_,_,"name", Nume},{_,_,"urbanFlag",_Numitrebuie}]}, _Location, _State) ->
                     %CityTypeNou = 
             ({startElement, _, "City", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, {_,_,"district",JudetId}, {_,_,"cityType", TipOrasId}]}, _Location, _State) ->
                     insert_oras(Cod, Nume, JudetId, TipOrasId);
             ({startElement, _,"Street_Type", _Ceva, [{_,_, "code", Cod}, {_,_,"name", Nume}]},_Location, _State) ->
                     TipStrada = strada_type:new(id, Cod, Nume),
                     {ok, _} = TipStrada:save();
             ({startElement, _, "Street", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, {_,_, "cityCode", CodOras}, {_,_, "stradaType", TipStrada}]}, _Location, _State) ->
                     insereaza_strada(Cod, Nume, CodOras, TipStrada);
             (_,_,State) ->
                     State
             end}
              ]),
    lista_tari().



