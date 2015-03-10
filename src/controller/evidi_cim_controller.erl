-module(evidi_cim_controller, [Req]).
-compile(export_all).

cauta('GET', [Diagnostic]) ->
    Diagnostice = boss_db:find(cim10entry, [{nume, 'matches', Diagnostic}], [{limit, 10}]),
    {json, [{diagnostice, Diagnostice}]}.

capitole('GET', []) ->
    Capitole = boss_db:find(cim10capitol, []),
    {json, [{capitole, Capitole}]}.

subcapitole('GET', [CapitolId]) ->
    Subcapitole = boss_db:find(cim10subcapitol, [{cim10capitol_id,'equals', "cim10capitol-"++CapitolId}]),
    {json, [{subcapitole, Subcapitole}]}.

entry('GET', [SubcapitolId]) ->
    Coduri = boss_db:find(cim10entry, [{cim10subcapitol_id, 'equals',"cim10subcapitol-"++SubcapitolId}]),
    {json, [{coduri, Coduri}]}.
