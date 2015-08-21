%% Migration: cim10
{cim10,
  fun(up) -> 
          boss_db:execute("create table cim_capitole(
          cod text,
          nume text)"),
          boss_db:execute("create table cim_subcapitole(
          cod text,
          nume text,
          cod_capitol text)"),
          boss_db:execute("create table cim_entry(
          cod text,
          nume text,
          cod_subcapitol text)");

     (down) -> 
          boss_db:execute("drop table cim_capitole"),
          boss_db:execute("drop table cim_subcapitole"),
          boss_db:execute("drop table cim_entry")

  end}.
