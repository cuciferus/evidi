-module(glicemie, [Id, Glicemie, Glicemiepostprandiala, Data, PacientId]).
-compile(export_all).

-belongs_to(pacient).

-table("glicemie").

