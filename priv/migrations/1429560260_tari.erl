%% Migration: tari
UpSQL = 
"
CREATE TABLE  adresa(
    id serial unique,
    tara_id integer,
    judete_id integer,
    city_id integer,
    strada_id integer);
CREATE TABLE  tari(
    id serial unique,
    nume text,
    cod text);
CREATE TABLE judete(
    id serial unique,
    nume text,
    cod text,
    tari_id integer);
CREATE TABLE city_type(
    id serial unique,
    cod text,
    nume text);
CREATE TABLE city(
    id serial unique,
    cod text,
    nume text,
    judet_id integer,
    citytype_id integer);
CREATE TABLE stradatype(
    id serial unique,
    cod text,
    nume text);
CREATE TABLE strada(
    id serial unique,
    nume text,
    cod text,
    city_id integer,
    stradatype_id text);".

DownSQL =
"DROP TABLE tari;
DROP TABLE judete;
DROP TABLE city_type;
DROP TABLE city;
DROP TABLE strada_type;
DROP TABLE strada;
".





{tari,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
