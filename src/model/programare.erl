-module(programare, [Id, Data, Ora,Durata, PacientId]).
-compile(export_all).
-belongs_to(pacient).

after_create() ->
    boss_mq:push("programari-noi", THIS).

