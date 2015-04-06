%% Migration: rude
%%
UpSQL = "create table rude(
        id serial unique,
        nume text,
        grad text);
insert into rude values (1,'frate','1');
insert into rude values (2,'sora','1');
insert into rude values (3,'tata','1');
insert into rude values (4,'mama','1');
insert into rude values (5,'bunica din partea mamei','2');
insert into rude values (6,'bunicul din partea mamei','2');
insert into rude values (7,'bunicul din partea tatei','2');
insert into rude values (8,'bunica din partea tatei','2');
insert into rude values (9,'matusa din partea tatei','2');
insert into rude values (10,'matusa din partea mamei','2');
insert into rude values (11,'unchi din partea mamei','2');
insert into rude values (12,'unchi din partea tatei','2');
".
DownSQL = "drop table rude;".

{rude,
  fun(up) -> boss_db:execute(UpSQL);
     (down) -> boss_db:execute(DownSQL)
  end}.
