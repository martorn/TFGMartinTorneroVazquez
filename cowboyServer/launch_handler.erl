-module(launch_handler).

-export([
    init/2,
    execute_ultrasonido/2,
    execute_magnetometro/2,
    execute_c_program/0,
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
    
execute_c_program() ->
    Port = open_port({spawn, "/home/martorn/Desktop/distanceSensor/prueba"}, [stream]),
    receive
        {Port, {data, Data}} ->
            Data
    end.

execute_ultrasonido(Time, Frec) ->
  
    Command = "/home/martorn/Desktop/distanceSensor/ultrasonido " ++ Time ++ " " ++ Frec,
    Port = open_port({spawn, Command}, [stream]),
    receive_data(Port).

execute_magnetometro(Time, Frec) ->
  
    Command = "sudo /home/martorn/Desktop/hmc5983_i2c/CabeceoArchivo/cabeceoArchivo " ++ Time ++ " " ++ Frec,
    Port = open_port({spawn, Command}, [stream]),
    receive_data(Port).

receive_data(Port) ->
    receive
     
        {Port, {data, Data}} when Data == "UltOK" -> % Utiliza "Finalizado" como indicador de fin de ejecución
            
          "Recogida de datos finalizada correctamente!, 
accede al archivo a traves de http://localhost:8080/sensores/ultrasonido/data";
        
        {Port, {data, Data}} when Data == "MagOK" -> % Utiliza "Finalizado" como indicador de fin de ejecución
        
        "Recogida de datos finalizada correctamente!, 
accede al archivo a traves de http://localhost:8080/sensores/magnetometro/data";
        
        {Port, {data, Data}} ->
			
			io:format("~p~n", [Data]),
            receive_data(Port);
        {Port, {error, Reason}} ->
			Reason,
            io:format("Error al recibir datos del programa C: ~p~n", [Reason])
    end.
    
    
content(Path, _) when Path == <<"/sensores/ultrasonido/prueba">> ->
    execute_c_program();
    

content(Path, QueryString) when Path == <<"/sensores/ultrasonido/launch">> ->
	
	Params = cow_qs:parse_qs(QueryString), %Divide la parte del query en cada uno de sus argumentos
	io:format("Params: ~p~n", [Params]),
	TimeBin = proplists:get_value(<<"time">>, Params, <<"5">>), %Obtiene el valor de time en binario, formato <<"x">>
	FrecBin = proplists:get_value(<<"frec">>, Params, <<"0.5">>), %Obtiene el valor de frec en binario, formato <<"x">>
	Time = binary_to_list(TimeBin), %Pasa el argumento a list para que la funcion que ejecuta el codido pueda leerlo
	Frec = binary_to_list(FrecBin),
	io:format("Time: ~p~n", [Time]),
	io:format("Frec: ~p~n", [Frec]),
    execute_ultrasonido(Time, Frec); %Se lanza la funcion con los argumentos
	
	
	
content(Path, QueryString) when Path == <<"/sensores/magnetometro/launch">> ->
	
	Params = cow_qs:parse_qs(QueryString), %Divide la parte del query en cada uno de sus argumentos
	io:format("Params: ~p~n", [Params]),
	TimeBin = proplists:get_value(<<"time">>, Params, <<"5">>), %Obtiene el valor de time en binario, formato <<"x">>
	FrecBin = proplists:get_value(<<"frec">>, Params, <<"0.5">>), %Obtiene el valor de frec en binario, formato <<"x">>
	Time = binary_to_list(TimeBin), %Pasa el argumento a list para que la funcion que ejecuta el codido pueda leerlo
	Frec = binary_to_list(FrecBin),
	io:format("Time: ~p~n", [Time]),
	io:format("Frec: ~p~n", [Frec]),
    execute_magnetometro(Time, Frec); %Se lanza la funcion con los argumentos
  

content(_, _) ->
    <<"Not Found">>.





    
