-module(evidi_diabet_controller, [Req]). 
-compile(export_all).

evidenta('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]}.


adaugaGlicemie('POST', [Id]) ->
    Pacient = boss_db:find(Id),
    Glicemie = Req:post_param("glicemie"),
    TipGlicemie = Req:post_param("glicemie_postprandiala"), %meh de vazut cum vine ăsta
    Data = Req:post_param("data"),
    Glicemie = glicemie:new(id, Glicemie, TipGlicemie, Data, Pacient:id()),
    {ok, GlicemieSalvata} = Glicemie:save().

