-module(evidi_clinica_controller, [Req]).
-compile(export_all).

adauga('GET', []) ->
    ok;
adauga('POST',[]) ->
    Nume = unicode:characters_to_binary(Req:post_param("nume")),
    [{_,_FileName, TempLocation, _Size, _Name}|_] = Req:post_files(), %sau poate are mai multe poze??
    {ok, Data} = file:read_file(TempLocation),
    Judet = unicode:characters_to_binary(Req:post_param("judet")),
    Oras = unicode:characters_to_binary(Req:post_param("oras")),
    Strada = unicode:characters_to_binary(Req:post_param("strada")),
    Numar = Req:post_param("numar"),
    Etaj = Req:post_param("etaj"),
    Telefon = Req:posst_param("telefon"),
    Clinica = clinica:new(id, Nume),
    {ok, ClinicaNoua} = Clinica:save(),
    Sediu =  sediu:new(id, Judet, Oras, Strada, Numar, Telefon, ClinicaNoua:id()),
    {redirect, [{action, "spre_mai_bine"}]}.


