-record(cim10capitol, {cod, capitol}).%asta nu cred ca-mi trebuie
-record(cim10subcapitol, {cod, nume, cim10capitol_id}).
-record(cim10entry, {cod, nume, cim10subcapitol_id}).


-record(judete, {nume, cod, tara_id}).
-record(oras, {nume, cod, tiporas_id, judet_id}).
-record(strada, {nume, cod, oras_id, stradatype_id}).

