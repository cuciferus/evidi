-module(evidi_adresa_controller, [Req]).
-compile(export_all).

lista_tari('GET',[]) ->
    Tari = boss_db:find(tari,[], [{order_by, nume}]),
    {json, [{tari, Tari}]}.

populeaza_judete('GET',[_TaraCod]) ->
    %Judete = boss_db:find(judete, [], [{order_by, nume}]),
    Judete = boss_db:execute("select * from judete"),
    {json, [{judete, Judete}]};
populeaza_judete('GET', []) ->
    Judete = boss_db:find(judete, [], [{order_by, nume}]),
    {json, [{judete, Judete}]}.


populeaza_orase('GET',[JudetId]) ->
    %Orase = boss_db:find(city, [{judet_id,'equals',JudetId}], [{order_by, citytype_id}]),
    Rezultate =  boss_db:execute("select * from city where judet_id=$1", [JudetId]),
    Orase = utile:jsonifica(Rezultate),
    {output, [{orase, Orase}]}.

cauta_strada('GET',[Oras, Strada]) ->
    Strazi = boss_db:find(strada, [{city_id,'equals',Oras}, {nume,'matches', Strada}]),
    {json, [{strazi, Strazi}]}.




