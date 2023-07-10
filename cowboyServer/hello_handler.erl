-module(hello_handler).
-behavior(cowboy_handler).

-export([init/2]).

init(Req0, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        <<"Bienvenido al servidor Erlang, 
desde aqui podras ver la descripcion de los sensores y lanzarlos 
para obtener sus datos.
        
Utilizacion:
/sensores --> Muestra los sesores disponibles">>,
        Req0),
    {ok, Req, State}.
    

