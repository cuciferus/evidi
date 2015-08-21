%% Migration: pacients
UpSQL = " CREATE TABLE pacients(
    id serial unique,
    nume text,
    prenume text,
    cnp text,
    adresa text);
".
DownSQL = "DROP TABLE pacients;".
    
    
{create_pacienti,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
