-module(evidi_adresa_controller, [Req]).
-compile(export_all).

lista_tari('GET',[]) ->
    Tari = boss_db:find(tari,[], [{order_by, nume}]),
    {json, [{tari, Tari}]}.

populeaza_judete('GET',[_TaraCod]) ->
    Judete = boss_db:find(judete, [], [{order_by, nume}]),
    {json, [{judete, Judete}]}.

populeaza_orase('GET',[JudetId]) ->
    Orase = boss_db:find(city, [{judet_id,'equals',JudetId}], [{order_by, citytype_id}]),
    {json, [{orase, Orase}]}.

cauta_strada('GET',[Oras, Strada]) ->
    Orasu= boss_db:find_first(city, [{cod,'equals', Oras}]),
    Strazi = boss_db:find(strada, [{city_id,'equals',Orasu:id()}, {nume,'matches', Strada}]),
    {json, [{strazi, Strazi}]}.




