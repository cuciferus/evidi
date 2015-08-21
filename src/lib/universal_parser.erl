-module(universal_parser).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").

-define(XML, "./src/lib/nomenclator.xml").


verifica_fisieru_xml() ->
    case file:read_file_info(?XML) of
        {ok, _} -> ok;
        {error, _Reason} -> throw(nu_exista_fisierul_dorit) %eventual fac si o schema verification
    end.

%truncheaza_tabele() ->
    %boss_db:execute("truncate table icd10s"),
    %boss_db:execute("truncate table cimcapitole"),
    %boss_db:execute("truncate table cim_subcapitole"),
    %boss_db:execute("truncate table cim_entry"),
    %boss_db:execute("truncate table atc1"),
    %boss_db:execute("truncate table drugs").

truncheaza_ceva_tabele([Tabel|Restu]) ->
    boss_db:execute(io_lib:format("truncate table ~s",[Tabel])),
    truncheaza_ceva_tabele(Restu);
truncheaza_ceva_tabele([]) -> ok.



parse() ->
    verifica_fisieru_xml(),
    %truncheaza_ceva_tabele
    %truncheaza_tabele(),
    truncheaza_ceva_tabele(["cim_capitole","cim_subcapitole","cim_entry", "specialitati", "grade_medicale","tari", "judete",  "city_type", "city", "stradatype", "strada"]),

    {ok, Greseli} = file:open("greseli.log",[append]),
    xmerl_sax_parser:file(?XML, [ 
        {event_fun,
         fun
         %(startDocument, _Location,_State) ->
                 %{ {[],[],[],[],[]}, {[],[],[]}};

        ({startElement, _, "Cim10", _Ceva, Atribute}, Location, State) ->
             %<Cim10  code="1" name="Anumite boli infectioase si parazitare" entityLevel="0"/>
             %codurile sunt puse aiurea in xml: prima data entry apoi subcapitol apoi capitol yeeey
                 {_,_,"code", Cod} = lists:keyfind("code", 3, Atribute),
                 {_,_,"name", Nume} = lists:keyfind("name",3, Atribute),
                 {_,_,"entityLevel", NivelEntitate} = lists:keyfind("entityLevel",3, Atribute),
                 case NivelEntitate of
                     "0" ->
                         boss_db:execute("insert into cim_capitole (cod, nume) values ($1, $2)", [Cod, Nume]);
                     "1" ->
                         [CodCapitol, CodSubcapitol] = string:tokens(Cod, "_"),
                         boss_db:execute("insert into cim_subcapitole (cod, nume, cod_capitol) values ($1, $2, $3)",
                                         [CodSubcapitol, Nume, CodCapitol]);
                     "2" ->
                         [_CodCapitol, CodSubcapitol, CodEntry] = string:tokens(Cod, "_"),
                         boss_db:execute("insert into cim_entry (cod, nume, cod_subcapitol) values ($1, $2, $3)",
                                         [CodEntry, unicode:characters_to_binary(Nume), CodSubcapitol])
                 end;

             %case length(Atribute) of
                 %3 ->
                     %[{__,_,"code", Codu}, {_,_,"name", Numele}, {_,_,"entityLevel","0"}] = Atribute,
                     %boss_db:execute("insert into cim_capitole (cod, nume) values ($1, $2)", [Codu, Numele]);
                 %4 ->
                    %[{_,_,"code", Cod_aiurea}, {_,_, "name", Numele}, 
                                            %{_,_, "entityLevel", NivelEntitate}, _ParentCode] = Atribute,
                    %case NivelEntitate of
                        %"1"->
                            %[CodCapitol, CodSubcapitol] = string:tokens(Cod_aiurea, "_"),
                            %boss_db:execute("insert into cim_subcapitole (cod, nume, cod_capitol) values ($1, $2, $3)",
                                            %[CodSubcapitol, Numele, CodCapitol]);
                        %"2" ->
                            %[_CodCapitol, CodSubcapitol, CodEntry] = string:tokens(Cod_aiurea, "_"),
                            %boss_db:execute("insert into cim_entry (cod, nume, cod_subcapitol) values ($1, $2, $3)",
                                            %[CodEntry, Numele, CodSubcapitol])
                    %end
             %end;
         %({startElement, _, "PharmaceuticalForm", _Ceva, [{_,_,"code", Cod}, {_,_,"validFrom",_ValidFrom}]}, _Location, {Adrese,{Forma, Concentratie, Substanta}}) -> 
                 %{ok, 1,_,[{Id}]} = boss_db:execute("insert into pharmaceutical_forms (cod) values ($1) returning id", [unicode:characters_to_binary(Cod)]),
                 %{Adrese, {[{Id, Cod}|Forma], Concentratie, Substanta}};
         ({startElement, _, "Speciality", _Ceva, [{_,_, "code", Cod}, {_,_,"name", Nume}, {_,_,"validFrom", _ValidFrom}]}, _Location, State) ->
                 %file:write(Greseli, io_lib:format("incerc sa bag specialitatea ~s cu codul ~s ~n",[unicode:characters_to_binary(Nume), unicode:characters_to_binary(Cod)])
                  try 
                      boss_db:execute("insert into specialitati (cod, nume) values ($1, $2)", [unicode:characters_to_binary(Cod), 
                                                                                          unicode:characters_to_binary(Nume)])
                  of
                      _ -> ok
                  catch
                      Throw -> 
                          file:write(Greseli, io_lib:format("aceasta e eroarea: ~p~n", [Throw]))
                  end,
                  State;
         ({startElement, _,"Degree", _Ceva, [{_,_,"code", Cod}, {_,_,"description", Descriere}, {_,_,"extraPointsPercent", PuncteExtra},
                                             {_,_,"validFrom", _ValidFrom}]}, _Location, State) ->
                 {Puncte,_} = string:to_integer(PuncteExtra),
                 boss_db:execute("insert into grade_medicale (cod, nume, puncte_extra) values ($1, $2, $3)",
                                 [Cod, Descriere, Puncte]),
                 State;
         %({startElement, _, "Concentration", _Ceva, [{_,_, "concentration", Cod}, {_,_,"validFrom", _ValidFrom}]}, _Location, State = {Adrese, {Forma, Concentratie, Substanta}}) ->
                 %{ok,1,_,[{Id}]} = boss_db:execute("insert into concentrations (concentration) values ($1) returning id", [unicode:characters_to_binary(Cod)]),
                 %{Adrese, {Forma, [{Id, Cod}|Concentratie], Substanta}};
         %({startElement, _, "ActiveSubstance",_Ceva, [{_,_, "code", Cod}, {_,_, "validFrom", _ValidFrom}]}, _Location, State) -> 
                    %{Adrese, {Forma, Concentratie, Substanta}} = State,
                 %{ok,1,_,[{Id}]} = boss_db:execute("insert into substanta_activa (descriere) values ($1) returning id", [unicode:characters_to_binary(Cod)]),
                 %{Adrese, {Forma, Concentratie, [{Id, Cod}|Substanta]}};
         %({startElement, _, "Drug", _Ceva, Atribute}, _Location, 
            %State) -> 
                 %{Adrese, {Forme, Concentratii, Substante}} = State,
                 %%prima data atributele obligatorii
                 %{_,_,"code",Cod} = lists:keyfind("code",3,Atribute),
                 %{_,_,"name",Nume} = lists:keyfind("name",3, Atribute),
                 %{_,_,"isNarcotic", Narcotic} = lists:keyfind("isNarcotic",3, Atribute),
                 %{_,_,"isFractional", Fractional} = lists:keyfind("isFractional", 3, Atribute),
                 %{_,_,"isSpecial", Special} = lists:keyfind("isSpecial", 3, Atribute),
                 %{_,_,"hasBioEchiv", AreBioEquiv} = lists:keyfind("hasBioEchiv", 3, Atribute),
                 %{_,_,"validFrom", ValidFrom} = lists:keyfind("validFrom", 3, Atribute),
                 %{_,_,"activeSubstance", CodSubstantaActiva} = lists:keyfind("activeSubstance",3, Atribute),
                 %{_,_,"concentration", CodConcentratie} = lists:keyfind("concentration",3, Atribute),
                 %{_,_,"pharmaceuticalForm", CodFormaFarmaceutica} = lists:keyfind("pharmaceuticalForm",3, Atribute),
                 %{_,_,"company", Companie} = lists:keyfind("company", 3, Atribute),
                 %{_,_,"country", CodTara} = lists:keyfind("country",3,Atribute),
                 %{_,_, "atc",CodAtc} = lists:keyfind("atc", 3, Atribute),
                 %%acu cum draqu fac cu cele optionale????
                 %%sa dam deocamdata pass la atributele optionale
                 %%Optionale =  [presentationMode, isBrand, qtyPerPackage, wholeSalePricePerPackage, prescriptionMode, validTo],
                 %A
                 %Atributele = returneaza_atributele_optionale_care_exista(Atribute, Optionale, []),
                 %Tara = boss_db:find_first(tari, [{cod,'equals', CodTara}]),
                 %Atcprim = boss_db:find_first(atc5, [{cod, 'equals',CodAtc}]),
                 %Atc =  case Atcprim of %aici e greseala
                            %undefined ->
                                %boss_db:find_first(atc_aiurea, [{cod, 'equals', CodAtc}]);
                            %_->
                                %Atcprim
                        %end,
                 %{SubstantaActivaId, CodSubstantaActiva} = lists:keyfind(CodSubstantaActiva, 2, Substante),
                 %{ConcentratieId, CodConcentratie} = lists:keyfind(CodConcentratie, 2, Concentratii),
                 %{FormaFarmaceuticaId, CodFormaFarmaceutica} = lists:keyfind(CodFormaFarmaceutica, 2, Forme),

                 %case Atc == undefined of 
                     %true ->
                         %file:write(Greseli, io_lib:format("medicamentul cu numele ~p si codul ~p si substanta activa ~p facut de compania ~p nu are atc",
                                                           %[Nume, Cod, CodSubstantaActiva, Companie]));
                     %false ->
                        %Drug = drug:new(id, Cod, unicode:characters_to_binary(Nume), Narcotic, Fractional, Special, AreBioEquiv, SubstantaActivaId, ConcentratieId,
                                 %FormaFarmaceuticaId, unicode:characters_to_binary(Companie), Tara:id(), Atc:id()),
                         %{ok, _} = Drug:save()
                 %end,
                %{Adrese, {Forme, Concentratii, Substante}};

                 
                                 %[An, Luna, Zi] = string:tokens(ValidFrom, "-"),
                 %ValidFromFinala = integer_to_list(An) ++ "-" ++ integer_to_list(Luna) ++ "-" ++ integer_to_list(Zi),
                 
        
         ({startElement, _, "ICD10", _Ceva, Atribute}, _Location, State) ->
                 case length(Atribute) of
                     3 ->
                         [{_,_,"code",Cod}, {_,_,"name", Nume}, _ValidFrom] = Atribute,
                         IcdNou = icd10:new(id, Cod, Nume),
                         {ok, _} = IcdNou:save(),
                         State;
                     4 ->
                         [{_,_,"code", Cod}, {_,_,"name", Nume}, _ValidFrom,_categoriaBoala_sau_validTo] = Atribute,
                         IcdNou = icd10:new(id, Cod, Nume),
                         {ok, _} = IcdNou:save(),
                         State;
                     5 -> 
                         [{_,_,"code", Cod}, {_,_,"name", Nume}, _categorieBoala, _validFrom, _valiTo] = Atribute,
                         IcdNou = icd10:new(id, Cod, Nume),
                         {ok, _} = IcdNou:save(),
                         State
                 end;
         %({startElement, _,"ATC", _Ceva, Atribute}, _Location, State) ->
                 %case length(Atribute) of %să pare că ATC level 1 nu are
                                          %3 ->
                         %[{_,_,"code", Cod}, {_,_,"description", Descriere}, {_,_,"validFrom",_ValidFrom}] = Atribute,
                         %case length(Cod) of 
                             %1 ->
                                 %boss_db:execute("insert into atc1 values ($1, $2)", [Cod, Descriere]),
                                 %State;
                             %_ ->
                                 %AtcAiurea = atc_aiurea:new(id, unicode:characters_to_binary(Cod), unicode:characters_to_binary(Descriere)),
                                 %{ok, _} = AtcAiurea:save(),
                                 %State
                         %end;
                     %4 ->
                         %[{_,_,"code", Cod}, {_,_,"description", Descriere}, {_,_,"validFrom", _ValidFrom}, {_,_, "parentATC", ParentATC}] = Atribute,
                         %case length(Cod) of%șiiii trebie regândit NUUUUUU!!!!
                             %%atc aiurea are cod = descriere...nici nu cred că îmi trebuie ha!
                             %3 -> %atc2 are un numar din 2 cifre
                                 %boss_db:execute("insert into atc2 values ($1, $2, $3)", [Cod, Descriere, ParentATC]);
                             %4 -> %atc3 adaugă o literă
                                 %boss_db:execute("insert into atc3 values ($1, $2, $3)", [Cod, Descriere, ParentATC]);
                             %5 ->
                                 %boss_db:execute("insert into atc4 values ($1, $2, $3)", [Cod, Descriere, ParentATC]);
                             %7 ->
                                 %Atc = atc5:new(id, Cod, Descriere, ParentATC),
                                 %{ok, _} = Atc:save();
                             %_ ->
                                 %io:fwrite("salut ~p", [Atribute])
                         %end;
                     %_ ->
                         %io:fwrite("salut ~p", [Atribute])
                 %end,
                 %State;







         
         ({startElement, _, "Country",_Ceva, [{_,_,"code",Cod}, {_,_,"name", Nume}]}, _Location, State) ->
                 boss_db:execute("insert into tari (nume, cod) values ($1, $2) " ,[Nume, Cod]),
                 State;
         ({startElement, _, "District", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, {_,_,"country",CodTara}]}, _Location, State) ->
                 boss_db:execute("insert into judete (nume, cod, tari_id) values ($1, $2, $3) ", [Nume, Cod, CodTara]),
                 State;
         ({startElement, _, "CityType", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume},
                                                {_,_,"urbanFlag", _NuImiTrebuie}]},_Location, State) ->
                 boss_db:execute("insert into city_type (cod, nume) values ($1, $2) ", [Cod, unicode:characters_to_binary(Nume)]),
                 State;
        ({startElement, _, "City", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}, 
                                            {_,_,"district", CodJudet}, {_,_,"cityType", CodTipOras}]}, _Location, State) ->
                 boss_db:execute("insert into city (cod, nume, judet_id, citytype_id) values ($1, $2, $3, $4) ", 
                                 [Cod, unicode:characters_to_binary(Nume), CodJudet, CodTipOras]),
                 State;
         ({startElement, _, "Street_Type",_Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}]}, _Location, State) ->
                 boss_db:execute("insert into stradatype (cod, nume) values ($1, $2)", [Cod, Nume]),
                 State;
         ({startElement, _, "Street", _Ceva, [{_,_,"code", Cod}, {_,_,"name",Nume},
                                              {_,_,"city_code",CodOras}, {_,_,"streetType", CodTipStrada}]}, _Location,State)  ->
                 boss_db:execute("insert into strada (nume, cod, city_id, stradatype_id) values ($1, $2, $3, $4)",
                                 [unicode:characters_to_binary(Nume), Cod, CodOras, CodTipStrada]),
                 
                 State;
         %(endDocument, _Location, {{Cim10SubCapitole, Cim10Entry}, _Adrese}) -> %asta e triger de sfarsitul documentului

                 %salveazaSubCapitole(Cim10SubCapitole),
                 %salveazaEntry(Cim10Entry);

         (_,_,State) ->
                 State
         end}
                                ]).

%salveazaSubCapitole([{Codu, Numele, Parintele}|Restu]) ->
    %Capitol = boss_db:find_first(cim10capitol, [{cod, 'equals', Parintele}]),
    %Subcapitol = cim10subcapitol:new(id, Codu, unicode:characters_to_binary(Numele), Capitol:id()),
    %{ok, _} = Subcapitol:save(),
    %salveazaSubCapitole(Restu);
%salveazaSubCapitole([]) -> ok.


%salveazaEntry([{Nivel2, Numele, Nivel1}|Restu]) ->
    %Subcapitol = boss_db:find_first(cim10subcapitol, [{cod, 'equals', Nivel1}]),
    %Entry = cim10entry:new(id, Nivel2, unicode:characters_to_binary(Numele), Subcapitol:id()),
    %{ok, _} = Entry:save(),
    %salveazaEntry(Restu);
%salveazaEntry([]) -> ok.

returneaza_atributele_optionale_care_exista([H|T], AtributeXml, Acumulator) ->
    Optional = lists:keyfind(H, 3, AtributeXml),
    case Optional of
        false ->
            returneaza_atributele_optionale_care_exista(T, AtributeXml, Acumulator);
        AtributExistent ->
            {_,_,_, ValoareAtribut} = AtributExistent,
            returneaza_atributele_optionale_care_exista(T, AtributeXml, [{Optional,ValoareAtribut}|Acumulator])
    end;
returneaza_atributele_optionale_care_exista([], AtributeXml, Acumulator) -> Acumulator.


