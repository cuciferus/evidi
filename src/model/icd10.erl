-module(icd10, [Id, Cod, Diagnostic]).
-table("icd10s").
-has({personales, many}).
-has({consults, many}).

