%% Migration: tari
UpSQL = 
"
CREATE TABLE  adresa(
    id serial unique,
    telefon text,
    tara_id text,
    judete_id text,
    city_id text,
    strada_id text);
CREATE TABLE  tari(
    id serial unique,
    nume text,
    cod text);
CREATE TABLE judete(
    id serial unique,
    nume text,
    cod text,
    tari_id text);
CREATE TABLE city_type(
    id serial unique,
    cod text,
    nume text);
CREATE TABLE city(
    id serial unique,
    cod text,
    nume text,
    judet_id text,
    citytype_id text);
CREATE TABLE strada_type(
    id serial unique,
    cod text,
    nume text);
CREATE TABLE strada(
    id serial unique,
    nume text,
    cod text,
    city_id text,
    stradatype_id text);".

DownSQL =
"DROP TABLE tari;
DROP TABLE adresa;
DROP TABLE judete;
DROP TABLE strada_type;
DROP TABLE city_type;
DROP TABLE city;
DROP TABLE strada;
".





{tari,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
