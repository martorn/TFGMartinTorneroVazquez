# Aplicación de Adquisición de Datos de Sensores Mediante Raspberry-Pi en Entorno Erlang OTP
En este repositorio se almacenan los archivos que componen el servidor y los programas de los sensores HMC5983 y HC-SR04 utilizados para la realización del Trabajo de Fin de Grado de Martín Tornero Vázquez.

En las carpetas de los sensores encontramos dos archivos: Programa en C y programa en Python. El utilizado por el servidor es el programa en C.
Para ejecturar los programas en C estos deben compilarse utilizando sus librerías.
-En el caso del sensor de ultrasonido HC-SR04 debe compilarse la librería WiringPi.h de la siguiente manera:  gcc -o ultrasonido ultrasonido.c -lwiringPi
-En el caso del sensor magnetómetro HMC5983 debe compilarse la librería pigpio.h de la siguiente manera: gcc -o cabeceoArchivo cabeceoArchivo.c -lpigpio -lm

Para lanzar el servidor debe disponerse de Erlang instalado y seguir los pasos de la página https://ninenines.eu/docs/en/cowboy/2.6/guide/getting_started/
una vez completada la configuración inicial se pueden descargar los archivos de este repositorio y lanzar el servidor mediante el comando "make run". 

Por defecto el servidor es lanzado en localhost sobre el puerto 8080, en caso de querer modificar esto podemos hacerlo de manera sencilla en hello_erlang_app.erl en su sección correspondiente.

Por otro lado, es posible que surjan errores a la hora de lanzar los códigos de los sensores, es imporante que se hayan compilado con anterioridad e indicar al servidor el lugar de almacenamiento del ejecutable del archivo
y la localización de los archivos creados que almacenan los datos de los sensores. Estas modificaciones deben realizarse sobre el archivo launch_handler.erl en sus funciones correspondientes.
