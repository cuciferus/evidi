-module(universal_parser).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").

-define(XML, "./src/lib/nomenclator.xml").


verifica_fisieru_xml() ->
    case file:read_file_info(?XML) of
        {ok, _} -> ok;
        {error, _Reason} -> throw(nu_exista_fisierul_dorit) %eventual fac si o schema verification
    end.

truncheaza_tabele() ->
    boss_db:execute("truncate table cimcapitole"),
    boss_db:execute("truncate table cim_subcapitole"),
    boss_db:execute("truncate table cim_entry").


parse() ->
    verifica_fisieru_xml(),
    truncheaza_tabele(),
    xmerl_sax_parser:file(?XML, [ 
        {event_fun,
         fun
         (startDocument, _Location,_State) ->
                 {{[],[]}, {[],[],[],[],[]}};

        ({startElement, _, "Cim10", _Ceva, [{_,_,"code", Codu}, {_,_,"name", Numele}, {_,_, "entityLevel", "0"}]}, _Location, {Coduri,  Adrese}) ->
             %<Cim10  code="1" name="Anumite boli infectioase si parazitare" entityLevel="0"/>
             %codurile sunt puse aiurea in xml: prima data entry apoi subcapitol apoi capitol yeeey
            CimiCapitol = cim10capitol:new(id, Codu, Numele),
            {ok,_} = CimiCapitol:save(),
            {Coduri, Adrese};
        ({startElement, _, "Cim10", _Ceva, [{_,_,"code", Cod_aiurea}, {_,_, "name", Numele}, 
                                            {_,_, "entityLevel", "1"}, _ParentCode]}, _Location, {{Cim10SubCapitole, Cim10Entry}, Adrese}) -> 
            [Parintele, Codu] = string:tokens(Cod_aiurea, "_"),
            %Capitol = lists:keyfind(Parintele, 2, Cim10Capitole),
            %Subcapitol = cim10subcapitol:new(id, Codu, Numele, Capitol:id()),
            %{ok, SubcapitolSalvat} = Subcapitol:save(),
            {{[{Codu, Numele, Parintele}|Cim10SubCapitole], Cim10Entry}, Adrese};
        ({startElement, _, "Cim10", _Ceva, [{_, _, "code", Cod_aiurea}, {_, _, "name", Numele}, 
                                            {_, _, "entityLevel", "2"}, _ParentCode]}, _Location, {{Cim10SubCapitole, Cim10Entry}, Adrese}) ->
          %<Cim10  code="5_172_F32.91" name="Episod depresiv, nespecificat, producandu-se in perioada postnatala&quot;,-1,0,0,0,0," entityLevel="2" parentCode="5_172"/>
            [_, Nivel1, Nivel2] = string:tokens(Cod_aiurea, "_"),
            %Subcapitol = lists:keyfind(Nivel1, 2, Cim10Subcapitole),
            %{ok, _} = cim10entry:new(id, Nivel2, Numele, Subcapitol:id()),
            {{Cim10SubCapitole, [{Nivel2, Numele, Nivel1}|Cim10Entry]}, Adrese};
         ({startElement,_, "ICD10", _Ceva, [{_,_,"code", Cod}, {_,_, "name", Nume}, _validFrom]}, _Location, State) ->
           %<ICD10  code="636" name="Deformatii dobandite ale degetelor mainilor si picioarelor" validFrom="2014-06-01"/>
                 IcdNou = icd10:new(id, Cod, Nume),
                 {ok, _} = IcdNou:save(),
                 {State};
            
 

         %({startElement, _, "Country",_Ceva, [{_,_,"code",Cod}, {_,_,"name", Nume}]}, _Location, {Coduri, {Tari, Judete,Orase, TipOras, TipStrada}}) ->
                 %Tara = tari:new(id, Cod, unicode:characters_to_binary(Nume)),
                 %{ok, TaraSalvata} = Tara:save(),
                 %{Coduri, {[TaraSalvata|Tari],Judete, Orase, TipOras, TipStrada}};
         %({startElement, _, "District", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, {_,_,"country",CodTara}]}, _Location, {Coduri, {Tari, Judete,Orase, TipOras, TipStrada}}) ->
                 %Tara = lists:keyfind(CodTara,3,Tari),
                 %Judet = judete:new(id, unicode:characters_to_binary(Nume), Cod, Tara:id()),
                 %{ok, JudetSalvat} = Judet:save(),
                 %{Coduri, {Tari, [JudetSalvat|Judete], Orase, TipOras, TipStrada}};
         %({startElement, _, "CityType", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume},
                                                %{_,_,"urbanFlag", _NuImiTrebuie}]},
          %_Location, {Coduri, {Tari, Judete,Orase, TipuriOras, TipStrada}}) ->
                 %TipOrasNou = city_type:new(id, Cod, unicode:characters_to_binary(Nume)),
                 %{ok, TipOrasSalvat} = TipOrasNou:save(),
                 %{Coduri, {Tari, Judete, Orase, [TipOrasSalvat|TipuriOras], TipStrada}};
        %({startElement, _, "City", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, 
                                            %{_,_,"district", CodJudet}, {_,_,"cityType", CodTipOras}]}, _Location, {Coduri, {Tari, Judete,Orase, TipuriOras, TipStrada}}) ->
                 %Judet = lists:keyfind(CodJudet,4, Judete),
                 %TipOras = lists:keyfind(CodTipOras,3, TipuriOras),
                 %Oras = city:new(id, Cod, unicode:characters_to_binary(Nume), Judet:id(), TipOras:id()),
                 %{ok, OrasSalvat} = Oras:save(),
                 %{Coduri, {Tari, Judete, [OrasSalvat|Orase],TipuriOras, TipStrada}};
                  %({startElement, _, "Street_Type",_Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}]},
          %_Location, {Coduri, {Tari, Judete,Orase, TipOras, TipStrada}}) ->
                 %TipStradaNou = strada_type:new(id, Cod, unicode:characters_to_binary(Nume)),
                 %{ok, TipStradaSalvata} = TipStradaNou:save(),
                 %{Coduri, {Tari, Judete, Orase, TipOras,[TipStradaSalvata|TipStrada]}};
         %({startElement, _, "Street", _Ceva, [{_,_,"code", Cod}, {_,_,"name",Nume},
                                              %{_,_,"city_code",CodOras}, {_,_,"streetType", CodTipStrada}]}, _Location, {Coduri, {Tari, Judete,Orase, TipOras, TipStrada}}) ->
                 %io:fwrite("caut orasu ~p în lista ~p~n", [CodOras, Orase]),
                 %io:fwrite("caut tipu de strada ~p in lista ~p~n", [CodTipStrada, TipStrada]),
                 %Oras = lists:keyfind(CodOras, 3, Orase),
                 %TipStradaNou = lists:keyfind(CodTipStrada, 3, TipStrada),
                 %io:fwrite("incerc sa inserez strada cu numele ~p, codu ~p, tipu de strada ~p si idu orasului ~p~n",[unicode:characters_to_binary(Nume), Cod, TipStrada:id(), Oras:id()]),
                 %StradaNoua = strada:new(id, unicode:characters_to_binary(Nume), Cod, TipStradaNou:id(), Oras:id()),
                 %{ok,_} = StradaNoua:save(),
                 %{Coduri, {Tari, Judete,Orase, TipOras,TipStrada}};
         (endDocument, _Location, {{Cim10SubCapitole, Cim10Entry}, _Adrese}) ->

                 salveazaSubCapitole(Cim10SubCapitole),
                 salveazaEntry(Cim10Entry);

         (_,_,State) ->
                 State
         end}
                                ]).

salveazaSubCapitole([{Codu, Numele, Parintele}|Restu]) ->
    Capitol = boss_db:find_first(cim10capitol, [{cod, 'equals', Parintele}]),
    Subcapitol = cim10subcapitol:new(id, Codu, unicode:characters_to_binary(Numele), Capitol:id()),
    {ok, _} = Subcapitol:save(),
    salveazaSubCapitole(Restu);
salveazaSubCapitole([]) -> ok.


salveazaEntry([{Nivel2, Numele, Nivel1}|Restu]) ->
    Subcapitol = boss_db:find_first(cim10subcapitol, [{cod, 'equals', Nivel1}]),
    Entry = cim10entry:new(id, Nivel2, unicode:characters_to_binary(Numele), Subcapitol:id()),
    {ok, _} = Entry:save(),
    salveazaEntry(Restu);
salveazaEntry([]) -> ok.



