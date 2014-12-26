-module(evidi_consults_controller, [Req]).
-compile(export_all).

adauga('GET', [Id, ProgramareId]) ->
    Pacient = boss_db:find(Id),
    Programare=boss_db:find(ProgramareId), %care plm e problema cu linia asta?
    {ok, [{pacient, Pacient}, {programare, Programare}]}.
