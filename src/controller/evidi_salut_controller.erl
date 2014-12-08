-module(evidi_salut_controller, [Req]).
-compile(export_all).

salut('GET',[]) ->
    {output, "<strong> Salut</strong> baiete"}.
