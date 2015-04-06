%% Migration: heredocolaterale
UpSQL = "create table heredocolaterales (
        id serial unique,
        boala text,
        ruda_id text,
        pacient_id text);".

DownSQL = "drop table heredocolaterales;".

{heredocolaterale,
  fun(up) -> boss_db:execute(UpSQL) ;
     (down) -> boss_db:execute(DownSQL)
  end}.
