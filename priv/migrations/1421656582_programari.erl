%% Migration: programari
UpSQL = "CREATE TABLE programares (
    id serial unique,
    data date,
    ora time,
    durata smallint,
    pacient_id text);".
DownSQL = "DROP TABLE programares;".
    
    

{create_programari,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
