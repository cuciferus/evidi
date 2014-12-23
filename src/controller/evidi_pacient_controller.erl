-module(evidi_pacient_controller, [Req]).
-compile(export_all).

lista('GET', []) ->
    Pacienti = boss_db:find(pacient, [], [{limit, 5}]), % aici de lucru
    {ok, [{pacienti, Pacienti}]}.

cauta('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {json, [{pacient, Pacient}]}.

cautaCnp('GET', [Cnp]) ->
  Pacienti = boss_db:find(pacient, [{cnp,'matches', Cnp}]),
  {json, [{pacienti, Pacienti}]}.


adauga('GET',[]) ->
    ok;
adauga('POST',[]) ->
    Nume = Req:post_param("nume"),
    Prenume = Req:post_param("prenume"),
    CNP = Req:post_param("cnp"),
    Adresa = Req:post_param("adresa"),
    Telefon = Req:post_param("telefon"),
    PacientNou = pacient:new(id, Nume, Prenume, CNP, Adresa, Telefon),
    {ok, SavedPacient} = PacientNou:save(),
    {redirect, [{action, "lista"}]}.

editeazaPersonale('GET', [Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
editeazaPersonale('POST',[Id]) ->
    Pacient = boss_db:find(Id),
    Nume = Req:post_param("nume"),
    Prenume = Req:post_param("prenume"),
    CNP = Req:post_param("cnp"),
    Adresa = Req:post_param("adresa"),
    Telefon = Req:post_param("telefon"),
    PacientNou = pacient:new(Id, Nume, Prenume, CNP, Adresa, Telefon),
    {ok, SavedPacient} = PacientNou:save(),
    {redirect, [{action, "lista"}]}.



adaugaheredocolaterala('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
adaugaheredocolaterala('POST', [Id]) ->
    Ruda = Req:post_param("ruda"),
    Boala = Req:post_param("boala"),
    HeredoNou = heredocolaterale:new(id, Ruda, Boala, Id),
    {ok, HeredoSalvat} = HeredoNou:save(),
    {redirect,[{action, "lista"}]}.

adaugapersonala('GET', [Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
adaugapersonala('POST', [Id]) ->
    Boala = Req:post_param("boala"),
    DataDiagnostic = Req:post_param("data_diagnostic"),
    Tratament = Req:post_param("tratament"),
    PersonalaNoua = personale:new(id, Boala, DataDiagnostic, Tratament, Id),
    {ok, SavedPersonale} = PersonalaNoua:save(),
    {redirect, [{action, "lista"}]}.


adaugaProgramare('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
adaugaProgramare('POST',[Id]) ->
    [Data, Ora]  = string:tokens(Req:post_param("data"), " "),
    %Ora = Req:post_param("ora"),
    Durata = Req:post_param("durata"),
    ProgramareNoua = programare:new(id, Data, Ora, Durata, Id),
    {ok, SavedProrgamare} = ProgramareNoua:save(),
    {redirect, [{action, "listaProgramari"}]}.

listaProgramari('GET',[]) ->
    Programari = boss_db:find(programare,[]),
    Pacienti = boss_db:find(pacient, []),
    {ok, [{pacienti, Pacienti},{programari, Programari}]}.
