%% Migration: medicamente

{medicamente,
  fun(up) -> boss_db:execute("create table dci(
            id serial unique,
            cod text)"),

             boss_db:execute("create table pharmaceutical_forms(
             id serial unique,
             cod text
             )"),

             boss_db:execute("create table atc1(
             cod text,
             descriere text
             )"),

             boss_db:execute("create table atc2(
             cod text,
             descriere text,
             cod_parinte text)"),

             boss_db:execute("create table atc3(
             cod text,
             descriere text,
             cod_parinte text)"),

             boss_db:execute("create table atc4(
             cod text,
             descriere text,
             cod_parinte text)"),

             boss_db:execute("create table atc5(
             id serial unique,
             cod text,
             descriere text,
             cod_parinte text)"),


             boss_db:execute("create table atc_aiureas(
             id serial unique,
             cod text,
             descriere text)"),

             boss_db:execute("create table concentrations(
             id serial unique,
             concentration text
             )"),

             boss_db:execute("create table substanta_activa(
             id serial unique,
             descriere text)"),

             boss_db:execute("create table drugs(
             id serial unique,
             cod text,
             nume text,
             narcotic text,
             fractional boolean,
             special boolean,
             are_bio_equiv boolean,
             substanta_activa_id text,
             concentratie_id text,
             forma_farmaceutica_id text,
             companie text,
             tara_id text,
             atc5_id text)");


     (down) -> 
          boss_db:execute("drop table dci"),
          boss_db:execute("drop table pharmaceutical_forms"),
          boss_db:execute("drop table atc1"),
          boss_db:execute("drop table atc2"),
          boss_db:execute("drop table atc3"),
          boss_db:execute("drop table atc4"),
          boss_db:execute("drop table atc5"),
          boss_db:execute("drop table atc_aiureas"),
          boss_db:execute("drop table concentrations"),
          boss_db:execute("drop table substanta_activa"),
          boss_db:execute("drop table drugs")
  end}.
