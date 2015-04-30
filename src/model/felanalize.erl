-module(felanalize, [Id, Nume, UnitateDeMasura1, ValMinNormal, ValMaxNormal, UnitateDeMasura2, FactorConversie]). %aia cu valorinormale poate depinde de diverse
%poate si diverse detalii cum ar fi mod de recoltare(biochimie, imuno...) sau inainte de masa/alte conditii
-compile(export_all).
-has({analizes, many}).
