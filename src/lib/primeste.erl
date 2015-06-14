-module(primeste).
-compile(export_all).


primeste_judete(Judete) ->
    receive
        {Cod, Nume, Tara} ->
            primeste_judete([{Cod, Nume, Tara} | Judete]);
        {salveaza_orase, [Judet|RestuJudetelor]} ->
            {ok}
    end.


primeste_orase(Orase) ->
    receive
        {Nume, Cod, TipOrasId, JudetId} ->
            primeste_orase([{Nume, Cod, TipOrasId, JudetId} | Orase]);
        {cauta_orase, JudetCod} ->
                Orase_din_judet = [{Nume, Cod, TipOrasId, JudetCod} || {Nume, Cod, TipOrasId, JudetCod} <- Orase],
                spre_db:baga_orase(Orase_din_judet, JudetCod),
                primeste_orase(Orase -- Orase_din_judet);
        {gata} ->
            {ok}
    end.

primeste_strazi(Strazi) ->
    receive
        {Cod, Nume, CodOras, TipStrada} ->
            primeste_strazi([{Cod, Nume, CodOras, TipStrada} | Strazi]);
        {cauta_strazi,Oras} ->
            Strazi_din_oras = [{Cod, Nume, Oras, TipStrada} || {Cod, Nume, Oras, TipStrada} <- Strazi],
            spre_db:baga_strazi(Strazi_din_oras, Oras),
            primeste_strazi(Strazi -- Strazi_din_oras);
        {gata} ->
            {ok}
    end.

