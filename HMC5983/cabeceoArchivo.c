//Importacion de librerias necesarias

#include <stdio.h>
#include <stdlib.h>
#include <pigpio.h>
#include <math.h> 

//Definicion de los registros a utilizar.
//la direccion se ha obtenido ejecutando el comando i2cdetect -y 1 sobre la linea de comandos.
#define HMC5983_ADDR 0x1E 
#define HMC5983_REG_X_MSB 0x03
#define HMC5983_REG_Y_MSB 0x07
#define HMC5983_REG_Z_MSB 0x05
#define PI 3.14159265358979323846

int main(int argc, char *argv[])
{
    if(argc !=3){
        printf("Uso:sudo %s [tiempo_lectura] [ratio_lectura]\n", argv[0]);
        return 1;
    }
    
    double tiempo = atof(argv[1]);
    double ratio = atof(argv[2]);
    
    if (gpioInitialise() < 0) {
        printf("Error al inicializar la biblioteca pigpio\n");
        return 1;
    }

    int handle = i2cOpen(1, HMC5983_ADDR, 0);
    if (handle < 0) {
        printf("Error al configurar el dispositivo I2C.\n");
        return 1;
    }
    i2cWriteByte(handle, 0x00); // Configuración del modo continuo
    
    // Creación del archivo en el que se escribirán los datos
    FILE *fp;
    fp = fopen("/home/martorn/Desktop/hello_erlang/src/sensorData/angulosCabeceo.txt", "w"); // Modo escritura
    if (fp == NULL) {
        printf("Error al abrir el archivo para escritura.\n");
        return 1;
    }

    time_t start_time = time(NULL); // Obtener el tiempo de inicio, utilizado para escribir datos durante el tiempo deseado
    time_t current_time;
    
    printf("Recogida de datos en curso");
    int cont=0;
    while (1) {
        // Lectura de los datos de los ejes x, y y z
        uint16_t x_msb = i2cReadWordData(handle, HMC5983_REG_X_MSB);
        uint16_t x_lsb = i2cReadWordData(handle, HMC5983_REG_X_MSB + 1);
        uint16_t x = (x_msb << 8) | x_lsb;

        uint16_t y_msb = i2cReadWordData(handle, HMC5983_REG_Y_MSB);
        uint16_t y_lsb = i2cReadWordData(handle, HMC5983_REG_Y_MSB + 1);
        uint16_t y = (y_msb << 8) | y_lsb;

        uint16_t z_msb = i2cReadWordData(handle, HMC5983_REG_Z_MSB);
        uint16_t z_lsb = i2cReadWordData(handle, HMC5983_REG_Z_MSB + 1);
        uint16_t z = (z_msb << 8) | z_lsb;

        // Calculo del ángulo de cabeceo
        float pitch = atan2((float)x, sqrt(pow((float)y, 2) + pow((float)z, 2))) * 180 / PI;

        // Escritura de los datos en el archivo
        fprintf(fp,"%.2f \n",pitch);
        
        // Obtener el tiempo actual y comprobar si ha pasado el periodo de tiempo determinado de lectura de datos
        current_time = time(NULL);
        if (current_time - start_time >= tiempo) {
            break; // Salir del bucle después de escribir durante el periodo de tiempo
        }
		// FRECUENCIA DE LECTURA
        for (int i=0; i<cont %4; i++){
            printf(".");
            }
        fflush(stdout);
        cont++;
        time_sleep(ratio); // Velocidad de lectura de los datos, periodo entre lectura y lectura. 
    }
    printf("MagOK");
    i2cClose(handle); //Se cierra la lectura del sensor
    fclose(fp); // Cerrar el archivo
      return 0;
}

// COMPILAR CON gcc -o cabeceoArchivo2 cabeceoArchivo2.c -lpigpio -lm
