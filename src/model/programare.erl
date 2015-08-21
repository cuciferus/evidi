-module(programare, [Id, Data, Ora,Durata, PacientId]). %și poate și un scop(consult sau procedura)
-compile(export_all).
-belongs_to(pacient).

after_create() ->
    boss_mq:push("programari-noi", THIS).

