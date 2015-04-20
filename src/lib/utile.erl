-module(utile).
-compile(export_all).

transforma_timp(Timp) ->
	[Ora, Minut] = string:tokens(Timp, ":"),
	{OraNumar, _} = string:to_integer(Ora),
	{MinutNumar, _} = string:to_integer(Minut),
	{OraNumar, MinutNumar, 0}.

transforma_data(Data) ->
	[Zi, Luna, An] = string:tokens(Data, "/"),
	{ZiNumar, _} = string:to_integer(Zi),
	{LunaNumar, _} = string:to_integer(Luna),
	{AnNumar, _} = string:to_integer(An),
	{AnNumar, LunaNumar, ZiNumar}.


	
