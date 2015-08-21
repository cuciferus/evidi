%% Migration: doctori_si_clinici

{doctori_si_clinici,
  fun(up) -> 
          boss_db:execute("create table specialitati (
          id serial unique,
          cod text,
          nume text)"),
         boss_db:execute("create table grade_medicale (
         id serial unique,
         cod text,
         nume text, 
         puncte_extra integer)"),
         boss_db:execute("create table doctor (
            id serial unique,
            nume varchar,
            prenume varchar,
            codparafa varchar,
            clinica_id text,
            specialitate_id text)"),
         
        boss_db:execute("create table clinica (
            id serial unique,
            nume varchar,
            judet_id text,
            oras_id text,
            strada_id text)"),

     boss_db:execute("create table sediu (
            id serial unique,
            judet varchar,
            oras varchar,
            strada varchar,
            numar varchar,
            etaj integer,
            clinica_id)");
     (down) -> 
          boss_db:execute("drop table grade_medicale"),
          boss_db:execute("drop table specialitati"),
          boss_db:execute("drop table doctor"),
          boss_db:execute("drop table clinica"),
          boss_db:execute("drop table sediu")
  end}.
