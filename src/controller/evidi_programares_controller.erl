-module(evidi_programares_controller, [Req]). %sa nu uit in sql sa folosesc doar '
-compile(export_all).

lista('GET',[]) -> % imi trebuie update doar pentru o zi!
    {An, Luna, Zi} = erlang:date(), 
    Programari = boss_db:find(programare, [{data, 'equals', integer_to_list(An)++ "-"++integer_to_list(Luna)++"-"++integer_to_list(Zi)}]),
    TimeStamp = boss_mq:now("programari-noi"),
    {ok, [{programari, Programari}, {timestamp, TimeStamp}]}.

listaZI('GET', [Zi, Luna, An]) ->
    Programari = boss_db:find(programare, [{data, 'equals', string:join([An, Luna, Zi], "-")}]),
    Pacienti = [ boss_db:find(PacientId) || {programare, _,_,_,_,PacientId} <-Programari],
    OraProgramarii = [ binary_to_list(Ora) || { programare, _,_, {Ora}, _, _} <- Programari], %asta nu cred ca imi trebuie avand in vedere ca il prelucrez in js
    {json, [{"programari", Programari}, {"pacienti", Pacienti}, {"ore",OraProgramarii }]}.

send_test_message('GET',[]) ->
    TestMessage ="liber in sfarsit",
    boss_mq:push("test-channel", TestMessage),
    {output, TestMessage}.

pull('GET', [LastTimestamp]) ->
    {ok, Timestamp, Programari} = boss_mq:pull("programari-noi", list_to_integer(LastTimestamp)),
    {json, [{timestamp, Timestamp}, {programari, Programari}]}.

live('GET', []) ->
    Programari = boss_db:find(programare, []),
    TimeStamp = boss_mq:now("programari-noi"),
    {ok, [{programari, Programari}, {timestamp, TimeStamp}]}.


