-module(evidi_adresa_controller, [Req]).
-compile(export_all).

getCountries('GET',[]) ->
    Tari = boss_db:find(tari,[]),
    {json, [{tari, Tari}]}.


