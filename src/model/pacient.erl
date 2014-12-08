-module(pacient, [Id, Nume, Prenume, Cnp, Adresa, Telefon]).
-compile(export_all).
-has({heredocolaterales, many}).
-has({personales, many}).
-has({programares, many}).

