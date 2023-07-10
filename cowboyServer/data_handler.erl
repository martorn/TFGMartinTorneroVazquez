-module(data_handler).

-export([
    init/2,
    allowed_methods/2,
    content/2
]).

init(Req0, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"text/plain">>},
        content(cowboy_req:path(Req0), cowboy_req:qs(Req0)),
        Req0),
    {ok, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>, <<"POST">>, <<"DELETE">>],
    {Methods, Req, State}.


content(Path, _) when Path == <<"/sensores/ultrasonido/data">> -> 
     {ok, Data} = file:read_file("/home/martorn/Desktop/hello_erlang/src/sensorData/distancias.txt"),
        Data;
        
        
content(Path, _) when Path == <<"/sensores/magnetometro/data">> ->
     {ok, Data} = file:read_file("/home/martorn/Desktop/hello_erlang/src/sensorData/angulosCabeceo.txt"),
        Data;

content(_, _) ->
    <<"Not Found">>.
