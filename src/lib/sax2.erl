-module(sax2). %dintrun motiv necunoscut chicagoboss refuza sa mearga daca asta ramane in src/lib
-include_lib("xmerl/include/xmerl.hrl").
-include_lib("stdlib/include/qlc.hrl").

-include_lib("cim.hrl").


-define(XML, "./src/lib/nomenclator.xml").
-compile(export_all).

init() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(cim10capitol, [{attributes, record_info(fields, cim10capitol)}]),
    mnesia:create_table(cim10subcapitol, [{type, bag},
            {attributes, record_info(fields, cim10subcapitol)}]),
    mnesia:create_table(cim10entry, [{type, bag},
            {attributes, record_info(fields, cim10entry)}]).

insert_cim_capitol(Cod, Capitol) ->%inutil, doar de distractie
    Fun = fun() ->
            mnesia:write(
                #cim10capitol{cod = Cod,
                              capitol = Capitol})
    end,
    mnesia:transaction(Fun).

insert_cim_subcapitol(Cod, Nume, Capitol) ->
    Fun = fun() ->
            mnesia:write(
                #cim10subcapitol{cod = Cod,
                                 nume = Nume,
                                 cim10capitol_id = Capitol})
    end,
    mnesia:transaction(Fun).

insert_cim_entry(Cod, Nume, Subcapitol) ->
    Fun = fun() ->
            mnesia:write(
                #cim10entry{cod = Cod,
                            nume = Nume,
                            cim10subcapitol_id = Subcapitol})
    end,
    mnesia:transaction(Fun).


cauta_cim_subcapitol_altfel(Capitol) -> cauta_cim_subcapitol_altfel(Capitol,[]). 
cauta_cim_subcapitol_altfel([], Acc) -> Acc;
cauta_cim_subcapitol_altfel([H|T], Acc) ->
    {Cod, Id} = H,
    Capitole = do(qlc:q([{X#cim10subcapitol.nume, X#cim10subcapitol.cod} || X<- mnesia:table(cim10subcapitol), X#cim10subcapitol.cim10capitol_id ==Cod])),
    salveaza_subcapitole(Id, Capitole),
    cauta_cim_subcapitol_altfel(T, [Capitole, Acc]). 

cauta_entry(Subcapitol) -> 
    %asta e un boss_db obiect...unu doar   
    Entriuri = do(qlc:q([{X#cim10entry.nume, X#cim10entry.cod} || X<-mnesia:table(cim10entry), X#cim10entry.cim10subcapitol_id == Subcapitol:cod()])),
    salveaza_entriuri(Subcapitol:id(), Entriuri).

salveaza_entriuri(_NrSubcapitol,[]) ->ok;
salveaza_entriuri(NrSubcapitol, [Entry|Restu]) ->
    {Nume, Cod} = Entry,
    EntryNou = cim10entry:new(id, Cod, unicode:characters_to_binary(Nume), NrSubcapitol),
    {ok, _EntrySalvata} = EntryNou:save(),
    salveaza_entriuri(NrSubcapitol, Restu).


salveaza_subcapitole(_NrCapitol, []) ->ok;
salveaza_subcapitole(NrCapitol, [Subcapitol|Restu]) -> 
    {Nume, Cod} = Subcapitol,
    Subcapitolnou = cim10subcapitol:new(id, Cod, Nume, NrCapitol),
    {ok, SubcapitolSalvat} = Subcapitolnou:save(),
    cauta_entry(SubcapitolSalvat),
    salveaza_subcapitole(NrCapitol, Restu).


citeste_capitolele() -> 
    Capitole = [{binary_to_list(Cod), Id} || {cim10capitol, Id, Cod,_} <- boss_db:find(cim10capitol, [])],
    cauta_cim_subcapitol_altfel(Capitole).


parse_icds_mnesia() -> %todo poate si medicamentele?
    xmerl_sax_parser:file(?XML, [
            {event_fun,
             fun
                    ({startElement, _, "Cim10", _Ceva, [{_,_,"code", Codu}, {_,_,"name", Numele}, {_,_, "entityLevel", "0"}]}, _Location, _State) ->
                        CimiCapitol = cim10capitol:new(id, Codu, Numele),
                        {ok, _} = CimiCapitol:save();
                    ({startElement, _, "Cim10", _Ceva, [{_,_,"code", Cod_aiurea}, {_,_, "name", Numele}, {_,_, "entityLevel", "1"}, _ParentCode]}, _Location, _State) -> %parentcode e de cacat
                        [Parintele, Codu] = string:tokens(Cod_aiurea, "_"),
                        insert_cim_subcapitol(Codu, Numele, Parintele);

                    ({startElement, _, "Cim10", _Ceva, [{_, _, "code", Cod_aiurea}, {_, _, "name", Numele}, {_, _, "entityLevel", "2"}, _ParentCode]}, _Location, _State) ->
                        [_, Nivel1, Nivel2] = string:tokens(Cod_aiurea, "_"),
                        insert_cim_entry(Nivel2, Numele, Nivel1);
                    (_, _, State) ->
                        State
                end}
            ]).

do(Q) ->
    F = fun() -> qlc:e(Q) end,
    {atomic, Val} = mnesia:transaction(F),
    Val.


main() ->
    init(),
    parse_icds_mnesia().% braaaaavo acum trebuie sa le bagam in evidi
    %bagat_in_evidi().



