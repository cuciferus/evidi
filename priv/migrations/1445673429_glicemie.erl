%% Migration: glicemie
UpSQL = "create table glicemie(
    id serial unique,
    glicemie real,
    glicemiepostprandiala boolean,
    data date,
    pacient_id integer);".

DownSQL = "DROP TABLE glicemie;".




{glicemie,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
