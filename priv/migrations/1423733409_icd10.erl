%% Migration: icd10
UpSQL = "CREATE TABLE icd10s (
    id serial unique,
    diagnostic text,
    cod text);".
DownSQL = "DROP TABLE icd10s;".
    

{create_icd10,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
