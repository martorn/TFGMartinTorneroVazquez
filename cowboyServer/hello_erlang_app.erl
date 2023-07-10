-module(hello_erlang_app).
-behaviour(application).


-export([start/2]).
-export([stop/1]).

start(_Type, _Args) ->
    Dispatch = cowboy_router:compile([
        {'_', [
			{"/", hello_handler, []},
			{"/sensores", update_handler, []},
			{"/sensores/ultrasonido", update_handler, []},
			{"/sensores/ultrasonido/data", data_handler, []},
			{"/sensores/magnetometro", update_handler, []},
			{"/sensores/magnetometro/data", data_handler, []},
			{"/sensor", update_handler, []},
			{"/sensores/magnetometro/launch", 						launch_handler, []},
			{"/sensores/ultrasonido/launch", 						launch_handler, []},
			{'_', not_found_handler, []}  % Ruta por 					defecto (Not Found)
			]}
    ]),
    {ok, _} = cowboy:start_clear(my_http_listener,
        [{port, 8080},{ip, {192, 168, 1, 15}}],
        #{env => #{dispatch => Dispatch}}
    ),
    hello_erlang_sup:start_link().
    

stop(_State) ->
	ok.
