%% Migration: medicamente

{medicamente,
  fun(up) -> boss_db:execute("create table dci(
            id serial unique,
            cod varchar)")
             boss_db:execute("create table drugs(
             id serial unique,
             cod varchar,
             name varchar,
             mod_prezentare_id text,
             narcotic boolean,
             fractionabil boolean,
             special boolean,
             areBioEchiv boolean,
             qtyPerPackage integer,
             pretPerPachet decimal,
             wholeSalePricePerPackage decimal,
             prescriptionMode varchar,
             validFrom string,
             validTo string,
             dci_id text,
             companie text,
             tari_id,
             atc_id");
     (down) -> undefined
  end}.
