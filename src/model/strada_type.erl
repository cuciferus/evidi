-module(strada_type, [Id, Cod, Nume]).
-compile(export_all).
-table("streettype").
-has({stradas, many}).
