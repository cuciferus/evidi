-module(evidi_cauta_controller, [Req]).
-compile(export_all).

cauta_specialitate('GET', [Camp]) -> %asta e necesar pentru ca postgres nu vrea parametrized queriez
    Q = io_lib:format("select * from specialitate where nume like '%~s%'", [Camp]),
    Specialitati = boss_db:execute(Q),
    {json, [{specialitati, Specialitati}]}.

cauta('GET',[Nomenclator, Camp, Termen]) -> %Q e pentru ca postgresql nu poate parametrized queriez
    Q = io_lib:format("select * from ~s where ~s like '%~s%'", [Nomenclator, Camp, Termen]), 
    %codul asta poate expune baza de date la chestii nasoale și trebe să fac char escaping și what not
    Rezultat = boss_db:execute(Q),
    {json, [{rezultat, Rezultat}]}.

