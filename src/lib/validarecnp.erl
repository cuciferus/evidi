-module(validarecnp).
-compile(export_all).

-record(judet, {nume_judet, cod}).

run() ->
        [
            #judet{nume_judet="Alba", cod="01"},
            #judet{nume_judet="Arad", cod="02"},
            #judet{nume_judet="Argeş", cod="03"},
            #judet{nume_judet="Bacău", cod="04"},
            #judet{nume_judet="Bihor", cod="05"},
            #judet{nume_judet="Bistriţa-Năsăud", cod="06"},
            #judet{nume_judet="Botoşani", cod="07"},
            #judet{nume_judet="Braşov", cod="08"},
            #judet{nume_judet="Brăila", cod="09"},
            #judet{nume_judet="Buzău", cod="10"},
            #judet{nume_judet="Caraş-Severin",cod="11"},
            #judet{nume_judet="Cluj", cod="12"},
            #judet{nume_judet="Constanţa", cod="13"},
            #judet{nume_judet="Covasna", cod="14"},
            #judet{nume_judet="Dâmboviţa", cod="15"},
            #judet{nume_judet="Dolj", cod="16"},
            #judet{nume_judet="Galaţi", cod="17"},
            #judet{nume_judet="Gorj", cod="18"},
            #judet{nume_judet="Harghita", cod="19"},
            #judet{nume_judet="Hunedoara", cod="20"},
            #judet{nume_judet="Ialomiţa", cod="21"},
            #judet{nume_judet="Iaşi", cod="22"},
            #judet{nume_judet="Ilfov", cod="23"},
            #judet{nume_judet="Maramureş", cod="24"},
            #judet{nume_judet="Mehedinţi", cod="25"},
            #judet{nume_judet="Mureş", cod="26"},
            #judet{nume_judet="Neamţ", cod="27"},
            #judet{nume_judet="Olt", cod="28"},
            #judet{nume_judet="Prahova", cod="29"},
            #judet{nume_judet="Satu Mare", cod="30"},
            #judet{nume_judet="Sşlaj",cod="31"},
            #judet{nume_judet="Sibiu", cod="32"},
            #judet{nume_judet="Suceava", cod="33"},
            #judet{nume_judet="Teleorman", cod="34"},
            #judet{nume_judet="Timiş", cod="35"},
            #judet{nume_judet="Tulcea", cod="36"},
            #judet{nume_judet="Vaslui",cod="37"},
            #judet{nume_judet="Vâlcea", cod="38"},
            #judet{nume_judet="Vrancea", cod="39"},
            #judet{nume_judet="Bucureşti", cod="40"},
            #judet{nume_judet="Bucureşti S1", cod="41"},
            #judet{nume_judet="Bucureşti S2", cod="42"},
            #judet{nume_judet="Bucureşti S3", cod="43"},
            #judet{nume_judet="Bucureşti S4", cod="44"},
            #judet{nume_judet="Bucureşti S5", cod="45"},
            #judet{nume_judet="Bucureşti S6", cod="46"},
            #judet{nume_judet="Calaraşi", cod="51"},
            #judet{nume_judet="Giurgiu", cod="52"}
        ].

adunaElementeLista(Lista) -> adunaElementeLista(Lista, 0).
adunaElementeLista([], Suma) -> Suma rem 11;
adunaElementeLista([H|T], Suma) -> adunaElementeLista(T, H+Suma).
aflaAnNastere(Cnp, cnp) ->
    case aflaSexu(string:sub_string(Cnp, 1,1))  of
        {ok, "necunoscut", _} ->
            throw({eroare, nu_pot_afla_sexu});
        {ok, CifreAn,_} -> 
            {AnNastere,_} =string:to_integer(string:concat(CifreAn, string:sub_string(Cnp, 2,3))),
            {ok, AnNastere};
        {eroare} ->
            throw({eroare, an_nastere_aiurea})
    end.





citesteCnp() ->
    {ok, [Cnp]} = io:fread("introdu cnp ", "~s"),
    Cnp.

%% http://ro.wikipedia.org/wiki/Cod_numeric_personal
%%

aflaSexu(Sex) ->
    case Sex of
        "1" -> {ok,"19", baiat};
        "2" -> {ok, "19",fata};
        "3" -> {ok,"18", baiat};
        "4" -> {ok, "18",fata};
        "5" -> {ok, "20",baiat};
        "6" -> {ok, "20",fata};
        "7" -> {ok, "necunoscut",baiat};
        "8" -> {ok, "necunoscut",fata};
        "9" -> {ok, "necunoscut",strain};
        _ -> throw({eroare, sex_aiurea})
    end.

aflaJudet(Cnp, ListaJudete) ->
    Cod = string:sub_string(Cnp, 8,9),
    case lists:keysearch(Cod, #judet.cod, ListaJudete) of
        {value, {judet, Judet, _}} -> {ok, Judet};
        false -> throw({eroare, judet_aiurea})
    end.

valideazaNNNnumar(Nnn) when (Nnn > 001) and (Nnn < 999) -> %vezi ca nnn trebe sa fie numar nu string
    {ok};
valideazaNNNnumar(_) ->
    throw({eroare, nnn}).

valideazaNNN(Cnp) ->
    {Nnn, _} = string:to_integer(string:sub_string(Cnp, 10,12)),
    valideazaNNNnumar(Nnn).

aflaC(CnpTruncat) -> %aici nu-mi trebuie C trebuie doar primele 12 cifre din cnp, asa o sa-l folosesc si in genereazacnp
    %ficare ficfra din CNP e inmultita cu cifra de pe aceeasi pozitie din 279146358279 iar rezultatul final e impartit cu rest la 11, daca restul e 10 atunci c e unu altfel restu e C
    NumarFix = "279146358279",
    %PrimeleCifre = string:sub_string(Cnp, 1,12),
    Grupate = lists:zipwith(fun(A,B) -> 
                    {Cifra, _} = string:to_integer([A]),
                    {CifraFixa,_} = string:to_integer([B]),
                    Cifra*CifraFixa 
            end,
                            CnpTruncat, NumarFix),
    SumaImpartita = adunaElementeLista(Grupate),
    case  SumaImpartita of
        10 ->1;
        _ -> SumaImpartita
    end.

valideazaC(Cnp, C) -> %asta nu stiu daca merge ca nu pare sa afleC
    {UltimaCifra,_}  = string:to_integer(string:sub_string(Cnp, 13,13)),
    case UltimaCifra of
        C -> {ok};
        _ -> throw({eroare, invalid_c})
    end.

valideazaLunaNastere(Luna) when (Luna =<12) and (Luna >=01) -> 
    {ok, Luna};
valideazaLunaNastere(Luna) ->
    throw({eroare, luna_aiurea, Luna}).

valideazaZiNastere(Zi) when (Zi>=0) and (Zi =<31) ->
    {ok, Zi};
valideazaZiNastere(Altceva) ->
    throw({eroare, zi_aiurea, Altceva}).

valideazaDataNastere({An, Luna,Zi}) ->
    case calendar:valid_date({An, Luna,Zi}) of
        true -> {ok};
        _ -> throw({eroare, data_aiurea})
    end.

validatorUniversal(Cnp, luna) ->
    {Luna, [] } = string:to_integer(string:sub_string(Cnp,4,5)),
    valideazaLunaNastere(Luna);
validatorUniversal(Cnp, zi) ->
    {ZiNastere, []} = string:to_integer(string:sub_string(Cnp, 6,7)),
    valideazaZiNastere(ZiNastere).



aflaVarsta(Cnp) -> %aici ar fi frumos un try/fail care sa zica unde e greseala
        {ok, AnNastere} = aflaAnNastere(Cnp, cnp), 
        {ok, LunaNastere} = validatorUniversal(Cnp, luna),
        {ok, ZiNastere}  = validatorUniversal(Cnp, zi),
        {ok} = valideazaDataNastere({AnNastere, LunaNastere, ZiNastere}),
        {ZileTraite, _}  = calendar:time_difference(calendar:local_time(), {{AnNastere, LunaNastere, ZiNastere}, {14,4,4}}),
        {ok, trunc(abs(ZileTraite/365)), ani}.


valideazaLungimea(Cnp) ->
    case length(Cnp) of
        13 -> {ok};
        _ -> throw({eroare, lungime_aiurea})
    end.

valideazaCnp(Cnp) ->
        {ok} = valideazaLungimea(Cnp),
        {ok, _PrimeleDouaCifreAn, Sex} = aflaSexu(string:sub_string(Cnp,1,1)),
        {ok, Varsta, ani} = aflaVarsta(Cnp), %aici trebe vazut cum returnez varsta
        {ok, Judet} = aflaJudet(Cnp, run()),
        {ok} = valideazaNNN(Cnp),
        {ok} = valideazaC(Cnp, aflaC(string:sub_string(Cnp, 1,12))),
        {ok, {Sex, Varsta, Judet}}.



