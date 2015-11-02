-module(evidi_diabet_controller, [Req]). 
-compile(export_all).

evidenta('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]}.

listaGlicemiilor('GET', [Id]) ->
    Pacient = boss_db:find(Id),
    Glicemii = boss_db:find(glicemie, [{pacient_id, 'equals', Id}]),
    {json, [{glicemii, Glicemii}]}.

adaugaGlicemie('POST', [Id]) -> %imi da 404 la sfârșit
    Pacient = boss_db:find(Id),
    ValoareGlicemie = Req:post_param("glicemie"),
    Glicemiepostprandiala = Req:post_param("tipglicemie"), 
    Data_completa = Req:post_param("data-glicemie"),
    [Zi, Luna, An] = string:tokens(Req:post_param("data-glicemie"), "/"), %plm data trebe integer
    {GlicemieInteger, _} = string:to_integer(ValoareGlicemie),
    Glicemie = glicemie:new(id, GlicemieInteger, Glicemiepostprandiala, utile:transforma_data(Data_completa),  Pacient:id()),
    {ok, _GlicemieSalvata} = Glicemie:save().% Glicemie = glicemie:new(id, 123, "true", {2015,08,09}, "pacient-1")

