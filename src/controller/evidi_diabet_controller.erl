-module(evidi_diabet_controller, [Req]). 
-compile(export_all).

evidenta('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]}.

