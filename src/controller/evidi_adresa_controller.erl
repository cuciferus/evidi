-module(evidi_adresa_controller, [Req]).
-compile(export_all).


getCountries() ->
    boss_db:find(tari, []),
    {json, [{tari, Tari}]}.


