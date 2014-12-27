-module(analize,[Id, Valoare, ConsultId, FelanalizeId]).
-compile(export_all).
-belongs_to(consult).
-belongs_to(felanalize).

