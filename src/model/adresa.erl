-module(adresa, [Id, Telefon, TariId, JudeteId, CityId, StradaId, PacientId]).
-compile(export_all).
-table("adresa").
-belongs_to(tari).
-belongs_to(judete).
-belongs_to(city).
-belongs_to(strada).
-belongs_to(pacient).
