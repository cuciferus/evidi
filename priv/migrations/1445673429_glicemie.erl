%% Migration: glicemie
UpSQL = "create table glicemie(
    id serial unique,
    glicemie integer,
    glicemiepostprandiala boolean,
    data date,
    pacient_id text);".

DownSQL = "DROP TABLE glicemie;".




{glicemie,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
