-module(evidi_icd_controller, [Req]).
-compile(export_all).

lista('GET',[]) ->
    Coduri = boss_db:find(icd10, [], [{limit, 5}]),
    {ok, [{coduri, Coduri}]}.

cauta('GET', [Diagnostic]) ->
    Diagnostice = boss_db:find(icd10, [{diagnostic, 'matches', Diagnostic}]),
    {json, [{diagnostice, Diagnostice}]}.

genereazaCnp('GET',[]) -> %din pacate genereaza un singur cnp pa sesiune....
    Cnp = genereazacnp:genereaza_data_valida(),
    {json, [{cnp, Cnp}]}.

