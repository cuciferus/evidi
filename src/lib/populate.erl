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
    {ok, SavedPacient} = Pacient:save().
