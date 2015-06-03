-module(sax_geografie).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").

-define(XML, "./src/lib/nomenclator.xml").


verifica_fisieru_xml() ->
    case file:read_file_info(?XML) of
        {ok, _} -> ok;
        {error, _Reason} -> throw(nu_exista_fisierul_dorit) %eventual fac si o schema verification
    end.

parse_geografia() ->
    %sa pornesc gen_serveru zic
    verifica_fisieru_xml(),
    xmerl_sax_parser:file(?XML, [ 
        {event_fun,
         fun
         (startDocument, _Location,_State) ->
                 {[],[],[],[],[]};
         ({startElement, _, "Country",_Ceva, [{_,_,"code",Cod}, {_,_,"name", Nume}]}, _Location, {Tari, Judete,Orase, TipOras, TipStrada}) ->
                 Tara = tari:new(id, Cod, unicode:characters_to_binary(Nume)),
                 {ok, TaraSalvata} = Tara:save(),
                 {[TaraSalvata|Tari],Judete, Orase, TipOras, TipStrada};
         ({startElement, _, "District", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, {_,_,"country",CodTara}]}, _Location, {Tari, Judete,Orase, TipOras, TipStrada}) ->
                 Tara = lists:keyfind(CodTara,3,Tari),
                 Judet = judete:new(id, unicode:characters_to_binary(Nume), Cod, Tara:id()),
                 {ok, JudetSalvat} = Judet:save(),
                 {Tari, [JudetSalvat|Judete], Orase, TipOras, TipStrada};
         ({startElement, _, "CityType", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume},
                                                {_,_,"urbanFlag", _NuImiTrebuie}]},
          _Location, {Tari, Judete,Orase, TipuriOras, TipStrada}) ->
                 TipOrasNou = city_type:new(id, Cod, unicode:characters_to_binary(Nume)),
                 {ok, TipOrasSalvat} = TipOrasNou:save(),
                 {Tari, Judete, Orase, [TipOrasSalvat|TipuriOras], TipStrada};
        ({startElement, _, "City", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, 
                                            {_,_,"district", CodJudet}, {_,_,"cityType", CodTipOras}]}, _Location, {Tari, Judete,Orase, TipuriOras, TipStrada}) ->
                 Judet = lists:keyfind(CodJudet,4, Judete),
                 TipOras = lists:keyfind(CodTipOras,3, TipuriOras),
                 Oras = city:new(id, Cod, unicode:characters_to_binary(Nume), Judet:id(), TipOras:id()),
                 {ok, OrasSalvat} = Oras:save(),
                 {Tari, Judete, [OrasSalvat|Orase],TipuriOras, TipStrada};
                  ({startElement, _, "Street_Type",_Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}]},
          _Location, {Tari, Judete,Orase, TipOras, TipStrada}) ->
                 TipStradaNou = strada_type:new(id, Cod, unicode:characters_to_binary(Nume)),
                 {ok, TipStradaSalvata} = TipStradaNou:save(),
                 {Tari, Judete, Orase, TipOras,[TipStradaSalvata|TipStrada]};
         ({startElement, _, "Street", _Ceva, [{_,_,"code", Cod}, {_,_,"name",Nume},
                                              {_,_,"city_code",CodOras}, {_,_,"streetType", CodTipStrada}]}, _Location, {Tari, Judete,Orase, TipOras, TipStrada}) ->
                 %io:fwrite("caut orasu ~p în lista ~p~n", [CodOras, Orase]),
                 %io:fwrite("caut tipu de strada ~p in lista ~p~n", [CodTipStrada, TipStrada]),
                 Oras = lists:keyfind(CodOras, 3, Orase),
                 TipStradaNou = lists:keyfind(CodTipStrada, 3, TipStrada),
                 %io:fwrite("incerc sa inserez strada cu numele ~p, codu ~p, tipu de strada ~p si idu orasului ~p~n",[unicode:characters_to_binary(Nume), Cod, TipStrada:id(), Oras:id()]),
                 StradaNoua = strada:new(id, unicode:characters_to_binary(Nume), Cod, TipStradaNou:id(), Oras:id()),
                 {ok,_} = StradaNoua:save(),
                 {Tari, Judete,Orase, TipOras,TipStrada};
         %(endDocument, _Location, {Tari, Judete,Orase, TipOras, TipStrada}) ->
                 %ok;
                 %%spredb:terminate();
         (_,_,State) ->
                 State
         end}
                                ]).

