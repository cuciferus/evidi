-module(da).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").

-define(XML, "nomenclator.xml").


verifica_fisieru_xml() ->
    case file:read_file_info(?XML) of
        {ok, _} ->ok;
        {error, _Reason} -> throw(nu_exista_fisieru_dorit)
    end.


parse() ->
    verifica_fisieru_xml(),
    %Server_tari = spawn(primeste, primeste_tari, [[]]),
    %Server_judete = spawn(primeste, primeste_judete, [[]]),
    Server_orase = spawn(primeste, primeste_orase, [[]]),
    Server_strazi = spawn(primeste, primeste_strazi, [[]]),
    {ok, Final }= spre_db:start_link(),
    xmerl_sax_parser:file(?XML, [ 
        {event_fun,
         fun
         ({startElement, _, "Country",_Ceva, [{_,_, "code", Cod}, {_,_,"name", Nume}]}, _Location, _State) ->
                 spre_db:insereaza_tara(Cod, Nume);
         ({startElement, _, "District", _Ceva, [{_,_,"code", Cod},{_,_,"name", Nume}, {_,_,"country", Tara}]}, _Location, _State) ->
                 spre_db:insereaza_judet(Cod, Nume, Tara);
         ({startElement, _, "City", _Ceva, [{_,_,"code", Cod}, 
                                            {_,_,"nume", Nume},
                                            {_,_,"district", JudetId},
                                            {_,_,"cityType", TipOrasId}]}, _Location, _State) ->
                 Server_orase ! {Cod, Nume, JudetId, TipOrasId};
         ({startElement, _, "CityType", _Ceva, [{_,_, "code", Cod}, {_,_,"nume", Nume}, {_,_,"urbanFlag", _Nuimitrebuie}]}, Location, _State) ->
                 spre_db:insereaza_tip_oras(Cod, Nume);
         ({startElement,_, "Street_Type", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume}]}, _Location, _State) ->
                 spre_db:insereaza_tip_strada(Cod, Nume);
         ({startElement, _, "Street", _Ceva, [{_,_,"code", Cod}, {_,_,"name", Nume},
                                              {_,_,"city_code", CodOras}, {_,_,"streetType", TipStrada}]}, _Location, _State) ->
                 Server_strazi ! {Cod, Nume, CodOras, TipStrada};
         (endDocument, _Location, _State) -> 
                 spre_db:gata( Server_orase, Server_strazi);
         (_,_,State) ->
                 State
         end}
                                ]).



