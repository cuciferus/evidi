-module(clinica, [Id, Nume]). %poza??
-compile(export_all).

-has({doctors, many}).
-has({sedii, many}).

-table("clinica").
