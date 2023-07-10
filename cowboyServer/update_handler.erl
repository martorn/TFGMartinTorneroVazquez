-module(update_handler).

-export([
    init/2,
    allowed_methods/2,
    content/2
]).

init(Req0, State) ->
    Req = cowboy_req:reply(200,
        #{<<"content-type">> => <<"application/json">>},
        content(cowboy_req:path(Req0), cowboy_req:qs(Req0)),
        Req0),
    {ok, Req, State}.

allowed_methods(Req, State) ->
    Methods = [<<"GET">>, <<"POST">>, <<"DELETE">>],
    {Methods, Req, State}.
    
    
content(Path, _) when Path == <<"/sensores">> ->
    {ok, Data} = file:read_file("/home/martorn/Desktop/hello_erlang/src/text/sensores.json"),
        Data;

content(Path, _) when Path == <<"/sensores/magnetometro">> ->
     {ok, Data} = file:read_file("/home/martorn/Desktop/hello_erlang/src/text/magnetometro.json"),
        Data;

content(Path, _) when Path == <<"/sensores/ultrasonido">> ->
    {ok, Data} = file:read_file("/home/martorn/Desktop/hello_erlang/src/text/ultrasonido.json"),
        Data;
                
content(_, _) ->
    <<"Not Found">>.
    
    
    
