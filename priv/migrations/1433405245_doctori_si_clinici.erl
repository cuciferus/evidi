%% Migration: doctori_si_clinici

{doctori_si_clinici,
  fun(up) -> 
         boss_db:execute("create table doctor (
            id serial unique,
            nume varchar,
            prenume varchar,
            codparafa varchar,
            clinica_id text,
            specialitate_id text)"),
         boss_db:execute("create table specialitate (
            id serial unique,
            cod varchar,
            nume varchar)"),
        boss_db:execute("create table clinica (
            id serial unique,
            nume varchar,
            judet_id text,
            oras_id text,
            strada_id text)");
     (down) -> 
          boss_db:execute("drop table doctor"),
          boss_db:execute("drop table specialitate"),
          boss_db:execute("drop table clinica")
  end}.
