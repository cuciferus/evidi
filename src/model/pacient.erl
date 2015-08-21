-module(pacient, [Id, Nume, Prenume, Cnp]).
-compile(export_all).
-has({heredocolaterales, many}).
-has({personales, many}).
-has({programares, many}).
-has({consults, many}).
-has({screenings, many}).
-has({adresas, many}).


after_update() ->
    boss_mq:push("pacient-editat", THIS). %todo edit b0rkes
