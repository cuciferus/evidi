-module(evidi_pacient_controller, [Req]). 
-compile(export_all).

lista('GET', []) ->
    Pacienti = boss_db:find(pacient, [], [{limit, 5}]), % aici de lucru
    Timestamp = boss_mq:now("pacient-editat"),
    {ok, [{pacienti, Pacienti}, {timestamp, Timestamp}]}.

pull('GET', [LastTimestamp]) ->
    {ok, TimeStamp, Pacienti} = boss_mq:pull("pacient-editat", list_to_integer(LastTimestamp)),
    {json, [{timestamp, TimeStamp }, {pacienti, Pacienti}]}.
listaToti('GET', []) ->
    Pacienti = boss_db:find(pacient, [], [{limit, 5}]),
    {json, [{pacienti, Pacienti}]}.

cauta('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {json, [{pacient, Pacient}]}.

cautaCnp('GET', [Cnp]) ->
  Pacienti = boss_db:find(pacient, [{cnp,'matches', Cnp}]),
  {json, [{pacienti, Pacienti}]}.

cautaNume('GET', [Nume]) ->
  Pacienti = boss_db:find(pacient, [{nume,'matches', Nume}]),
  {json, [{pacienti, Pacienti}]}.


adauga('GET',[]) ->
    ok;
adauga('POST',[]) ->
    Nume = unicode:characters_to_binary(Req:post_param("nume")),
    Prenume = unicode:characters_to_binary(Req:post_param("prenume")),
    CNP = Req:post_param("cnp"),
    Telefon = Req:post_param("telefon"),
    PacientNou = pacient:new(id, Nume, Prenume, CNP, Telefon),
    {ok, SavedPacient} = PacientNou:save(), %adresa ar trebui sa fie optionala
    Tara = Req:post_param("tara"),
    Judet = Req:post_param("judete"),
    Oras = Req:post_param("oras"),
    Strada = Req:post_param("strada"),
    Adresa = adresa:new(id, Tara, Judet, Oras, Strada, SavedPacient:id()),
    {redirect, [{action, "lista"}]}.

editeazaPersonale('GET', [Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
editeazaPersonale('POST',[Id]) -> %asta merge dar da eroare :
    % [error] POST /pacient/editeazaPersonale/pacient-1 [evidi] 404 0ms]
    Nume = Req:post_param("nume"),
    Prenume = Req:post_param("prenume"),
    CNP = Req:post_param("cnp"),
    Adresa = Req:post_param("adresa"),
    Telefon = Req:post_param("telefon"),
    PacientNou = pacient:new(Id, Nume, Prenume, CNP, Adresa, Telefon),
    {ok, SavedPacient} = PacientNou:save().



adaugaHeredocolaterala('GET',[Id]) ->
    Pacient = boss_db:find(Id),
    {ok, [{pacient, Pacient}]};
adaugaHeredocolaterala('POST', [Id]) ->
    Ruda = Req:post_param("ruda"),
    RudaId = boss_db:find_first(ruda, [{nume,'equals',Ruda}]),
    Boala = Req:post_param("boala"),
    BoalaId = boss_db:find_first(icd10,[{diagnostic, 'equals',Boala}]), %am mai multe icd pam pam
    HeredoNou = heredocolaterale:new(id, RudaId:id(), BoalaId:id(), Id),
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
adaugaProgramare('POST',[Id]) -> %crapa daca nu are durata...prvent in view
    [Data, Ora]  = string:tokens(Req:post_param("data"), " "),
    {Durata,_} = string:to_integer(Req:post_param("durata")),
    ProgramareNoua = programare:new(id, utile:transforma_data(Data), utile:transforma_timp(Ora), Durata, Id),
    {ok, SavedProrgamare} = ProgramareNoua:save().
    %{redirect, [{action, "listaProgramari"}]}.

listaProgramari('GET',[]) ->
    Programari = boss_db:find(programare,[]),
    Pacienti = boss_db:find(pacient, []),
    {ok, [{pacienti, Pacienti},{programari, Programari}]}.



