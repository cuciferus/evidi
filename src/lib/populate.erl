-module(populate).
-compile(export_all).
% pentru popularea bazei de date cu 2-3 date cu care sa poti lucra/testa

get_random_string(Length, AllowedChars) ->
    lists:foldl(fun(_, Acc) ->
                [lists:nth(random:uniform(length(AllowedChars)),
                           AllowedChars)]
                ++ Acc
        end, [], lists:seq(1,Length)).


get_random_pacient() ->
    Nume = get_random_string(random:uniform(9)+4, lists:seq($a, $z)),
    Prenume = get_random_string(random:uniform(8)+5, lists:seq($a, $z)),
    Cnp = lists:concat(get_random_string(13, lists:seq(0,9))),
    Telefon = lists:concat(get_random_string(10, lists:seq(0,9))),
    Adresa = get_random_string(16, lists:seq($a, $z)),
    Pacient = pacient:new(id, Nume, Prenume, Cnp, Telefon, Adresa),
    {ok, _} = Pacient:save().

get_random_programare() ->
    get_random_pacient(),
    get_programare_pacient("pacient-1").

get_programare_pacient(Id) ->
    Data= erlang:date(),
    Ora = erlang:time(),
    Durata = lists:nth(1,get_random_string(2, lists:seq(5,15))),
    Programare = programare:new(id, Data, Ora, Durata, Id),
    {ok, _} = Programare:save().



fel_analize() ->
    Hemoglobina = felanalize:new(id, 'hemoglobina', 'mg/dL', 11, 16, 'mmol/L', '*2' ),
    {ok, _} = Hemoglobina:save(),
    Creatinina = felanalize:new(id, 'creatinina', 'mg/dL', 0.5, 1, 'mmol/L', '/4'),
    {ok, _} = Creatinina:save().

