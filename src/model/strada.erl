-module(strada, [Id, Nume, Cod, StradatypeId, CityId]).
-compile(export_all).
-belongs_to(stradatype).
-belongs_to(city).

