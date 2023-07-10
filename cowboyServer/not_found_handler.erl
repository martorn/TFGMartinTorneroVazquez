 -module(not_found_handler).

-export([init/2, allowed_methods/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(404,
        #{<<"content-type">> => <<"text/plain">>},
        <<"La URL solicitada no se ha encontrado en este servidor
escribe `/` para acceder a la pagina de inicio">>,
        Req0),
    {ok, Req, State}.

allowed_methods(Req, State) ->
    Methods = [],
    {Methods, Req, State}.

