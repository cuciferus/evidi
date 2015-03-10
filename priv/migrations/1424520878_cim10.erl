%% Migration: cim10
UpSQL = "CREATE TABLE cimcapitole(
    id serial unique,
    cod text,
    capitol text);
    
    CREATE TABLE cim_subcapitole(
        id serial unique,
        cod text,
        nume text,
        cim10capitol_id integer);

    CREATE TABLE cim_entry(
        id serial unique,
        cod text,
        nume text,
        cim10subcapitol_id integer);".

DownSQL = "DROP TABLE cim_capitole;
            DROP TABLE cim_subcapitole;
            DROP TABLE cim_entry;".

{cim10,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> bodd_db:execute(DownSQL)
  end}.
