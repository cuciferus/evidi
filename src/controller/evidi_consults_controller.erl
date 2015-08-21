-module(evidi_consults_controller, [Req]).
-compile(export_all).

adauga('GET', [PacientId, ProgramareId]) ->
    Pacient = boss_db:find(PacientId),
    Programare=boss_db:find(ProgramareId), 
    Consult = consult:new(id,erlang:date(), "","",PacientId ),
    {ok, [{pacient, Pacient}, {programare, Programare}, {consult, Consult}]};
adauga('GET', [PacientId]) ->
    Pacient = boss_db:find(PacientId),
    Consult = consult:new(id, erlang:date(), "","",PacientId),
    {ok, [{pacient, Pacient},{consult, Consult}]}.
