-module(evidi_programares_controller, [Req]).
-compile(export_all).

lista('GET',[]) ->
    {An, Luna, Zi} = erlang:date(),
    DataProgramarilorLista = lists:map(fun(X) -> integer_to_list(X) end, [Zi, Luna, An]),
    DataProgramarilor = string:join(DataProgramarilorLista, "/"),
    Programari = boss_db:find(programare, [{data,'equals', DataProgramarilor}]),
    TimeStamp = boss_mq:now("programari-noi"),
    {ok, [{programari, Programari}, {timestamp, TimeStamp}]}.

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

listaZI('GET', [Zi, Luna, An]) ->
    DataProgramarilor= string:join([Zi, Luna, An], "/"),
    Programari = boss_db:find(programare, [{data,'equals', DataProgramarilor}]),
    {json, [{programari, Programari}]}.
