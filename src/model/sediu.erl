-module(sediu, [Id, Judet, Oras, Strada, Numar, Etaj,Telefon, ClinicaId]).
%un sediu trebuie sa aibe si un nume si alte chestii financiare la care
%sincer nu ma pricep si care nu au importanta acum
-compile(export_all).

-belongs_to(clinica).
-table("sediu").
