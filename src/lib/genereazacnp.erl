-module(genereazacnp).
-compile(export_all).


genereaza_sex() ->
   random:uniform(9).

genereaza_an() ->
    An = random:uniform(99),
    case (An<10) of
        true -> 
            AnNumeric = integer_to_list(An), %asta da o lista gen [48|2] sa vedem cum si daca ma musca de fund
            string:concat("0",AnNumeric);
        false ->
            integer_to_list(An)
    end.


genereaza_luna() ->
    Luna = random:uniform(12),
    case (Luna<10) of
        true -> 
            LunaNumeric = integer_to_list(Luna),
            lists:concat(["0", LunaNumeric]);
        false -> integer_to_list(Luna)
    end.

regleaza_zi_mici(Zi) ->
    case (Zi <10) of
        true -> 
            ZiNumeric = integer_to_list(Zi),
            lists:concat(["0", ZiNumeric]);
        false ->
            integer_to_list(Zi)
    end.


genereaza_zi(An, Luna) -> 
    case lists:member(Luna, ["01","03","05","07","08","10","12"]) of 
        true ->
            Zi = random:uniform(31),
            regleaza_zi_mici(Zi);
        false when (Luna /= "02") ->
            Zi = random:uniform(30),
            regleaza_zi_mici(Zi);
        false  when (Luna =="02") ->
            %an trebuie sa fie integer
            {AnNumeric,_}  = string:to_integer(An),
            case calendar:is_leap_year(AnNumeric) of %% solutia din js poate merge implementata si acilea
                true ->
                    Zi = random:uniform(29),
                    regleaza_zi_mici(Zi);
                false ->
                    Zi = random:uniform(28),
                    regleaza_zi_mici(Zi)
            end
    end.

genereaza_ultimele_cifre_an_curent() ->
    {{An,_,_},_} = calendar:local_time(),
    UltimeleCifreAn = An rem 100,
    AnRandom = random:uniform(UltimeleCifreAn),
    AnRandomString = integer_to_list(AnRandom),
    case (length(AnRandomString) <2 ) of
        true ->
            lists:concat(["0", AnRandomString]);
        false ->
            AnRandomString
    end.


genereaza_cifre_judet() ->
    {judet, _NumeJudet, Cod} = lists:nth(random:uniform(48), validarecnp:run()), %numele judetului nu-mi trebuie aici
    Cod.

genereaza_nnn() ->
    %Nnn_naiv = random:uniform(999), %acum trebuie padding cu 0 la numerele de 1 sau 2 cifre
    PrimaCifra = integer_to_list(random:uniform(10) -1),
    ADouaCifra = integer_to_list(random:uniform(10) -1),
    UltimaCifra = integer_to_list(random:uniform(10) -1),
    lists:concat([PrimaCifra, ADouaCifra, UltimaCifra]).



genereaza_data_valida() -> %programu asta genereaza doar romani
    Lista = ["19","18","20"],
    CifreAn = lists:nth(random:uniform(3), Lista),
    case CifreAn  of
        "20" ->  %nu e bine ca mi-a dat ins nascut in 2020
            An = lists:concat([CifreAn, genereaza_ultimele_cifre_an_curent()]), %oare chiar trebuie si sa concat ?
            Sex = lists:nth(random:uniform(2), ["5","6"]), %am uitat sa aleg
            Luna = genereaza_luna(),
            Zi = genereaza_zi(An, Luna),
            JJ = genereaza_cifre_judet(),
            NNN = genereaza_nnn(),
            PrimeleCifre = lists:concat([Sex, CifreAn, Luna, Zi, JJ, NNN]),
            C = validarecnp:aflaC(PrimeleCifre),
            lists:concat([PrimeleCifre, C]);

        "18" ->
            An = lists:concat([CifreAn, genereaza_an()]),%anul trebuie sa fie integer pa genereaza zi altfel is_leap_year fails
            Sex = lists:nth(random:uniform(2), ["3","4"]),
            Luna = genereaza_luna(),
            Zi = genereaza_zi(An, Luna),
            JJ = genereaza_cifre_judet(),
            NNN = genereaza_nnn(),
            PrimeleCifre = lists:concat([Sex, CifreAn, Luna, Zi, JJ, NNN]),
            C = validarecnp:aflaC(PrimeleCifre),
            lists:concat([PrimeleCifre, C]);
        "19" ->
            An = lists:concat([CifreAn, genereaza_an()]),
            Sex = lists:nth(random:uniform(2), ["1","2"]),
            Luna = genereaza_luna(),
            Zi = genereaza_zi(An, Luna),
            JJ = genereaza_cifre_judet(),
            NNN = genereaza_nnn(),
            PrimeleCifre = lists:concat([Sex, CifreAn, Luna, Zi, JJ, NNN]),
            C = validarecnp:aflaC(PrimeleCifre),
            lists:concat([PrimeleCifre, C])
    end.


start() ->
    validarecnp:valideazaCnp(genereaza_data_valida()). %inca mai am luna invalida de ce domle de ce?

