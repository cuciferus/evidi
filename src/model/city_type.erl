-module(city_type, [Id, Cod, Nume]).
-compile(export_all).
-table("city_type").
-has({cities, many}).

