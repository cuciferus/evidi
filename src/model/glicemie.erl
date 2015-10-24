-module(glicemie, [Id, Glicemie, TipGlicemie, Data, PacientId]).
-compile(export_all).

-belongs_to(pacient).

-table("glicemie").

