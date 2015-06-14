-module(sax_medici).
-compile(export_all).

-include_lib("xmerl/include/xmerl.hrl").

-define(XML, "./src/lib/nomenclator.xml").


verifica_fisieru_xml() ->
    case file:read_file_info(?XML) of
        {ok, _} -> ok;
        {error, _Reason} -> throw(nu_exista_fisierul_dorit) %eventual fac si o schema verification
    end.

parse_medici() ->
    verifica_fisieru_xml(),
    xmerl_sax_parser:file(?XML, [ 
        {event_fun,
         fun
         (startDocument, _Location,_State) ->
                 {[],[],[],[],[]};
         ({startElement, _, "Speciality",_Ceva, [{_,_,"code",Cod}, {_,_,"name", Nume}, {_,_,"validFrom", _NuImiTrebuie}]}, _Location,_State)->
                 % <Speciality  code="NEONATOLOGIE" name="NEONATOLOGIE" validFrom="1900-01-01"/>
                 Specialitate = specialitate:new(id, Cod, Nume),
                 {ok, _} = Specialitate:save();
         (_,_,State) ->
                 State
         end}
                                ]).

