-module(evidi_ruda_controller, [Req]).
-compile(export_all).

cauta('GET',[Nume]) ->
    Rude = boss_db:find(ruda, [{nume, 'matches', Nume}]),
    {json, [{rude, Rude}]}.

