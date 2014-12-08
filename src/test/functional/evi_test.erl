-module(evi_test).
-compile(export_all).

start() ->
    boss_web_test:get_request("/salut/salut", [],
                              [ fun boss_assert:http_ok/1,
                               fun(Res) -> boss_assert:tag_with_text("strong",
                                                                    "<strong> Salut</strong> baiete", Res) 
            end ], []
                             ).
