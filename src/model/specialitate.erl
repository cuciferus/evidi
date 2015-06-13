-module(specialitate, [Id, Cod, Nume]).
-compile(export_all).
-has({doctors, many}).
-table("specialitate").
%has_many doctori
