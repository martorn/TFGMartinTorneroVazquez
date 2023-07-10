#include <stdio.h>
#include <stdlib.h>
#include <wiringPi.h>
#include <unistd.h>
#include <math.h> 
#include <time.h>
#include <pigpio.h>


#define TRIG_PIN 17 //Trig connected to GPIO17
#define ECHO_PIN 27 //Echo connected to GPIO27

void setup() {
    wiringPiSetupGpio();
    pinMode(TRIG_PIN, OUTPUT);
    pinMode(ECHO_PIN, INPUT);
}

void time_sleep(double seconds) {
    struct timespec req;
    req.tv_sec = (time_t)seconds;
    req.tv_nsec = (long)((seconds - (time_t)seconds) * 1e9);

    while (nanosleep(&req, &req) == -1) {
        continue;
    }
}

float getDistance() {
    digitalWrite(TRIG_PIN, LOW);
    delayMicroseconds(2); //2ms delay 

    digitalWrite(TRIG_PIN, HIGH);
    delayMicroseconds(10); //10 ms delay
    digitalWrite(TRIG_PIN, LOW);

    unsigned int timeout = 50000; // 50 ms if not detected
    unsigned int start_time, end_time;
    float distance;

    start_time = micros();

    while (digitalRead(ECHO_PIN) == LOW) {
        if ((micros() - start_time) > timeout) {
            printf("Error: No se detectó el pulso de eco.\n");
            return -1.0;
        }
    }

    start_time = micros();

    while (digitalRead(ECHO_PIN) == HIGH) {
        if ((micros() - start_time) > timeout) {
            printf("Error: Pulso de eco demasiado largo.\n");
            return -1.0;
        }
        end_time = micros();
    }

    float pulse_duration = (float)(end_time - start_time);
    distance = pulse_duration * 0.0343 / 2.0; // Calibration to pass from time to distance

    return distance;
}

int main(int argc, char *argv[]) 
{
    if(argc !=3){
        printf("Uso:sudo %s [tiempo_lectura (segundos)] [ratio_lectura(segundos)]\n", argv[0]);
        return 1;
    }
    
    double tiempo = atof(argv[1]);
    double ratio = atof(argv[2]);
    setup();
    
    // Creación del archivo en el que se escribirán los datos
    FILE *fp;
    fp = fopen("/home/martorn/Desktop/hello_erlang/src/sensorData/distancias.txt", "w"); // Modo escritura
    if (fp == NULL) {
        printf("Error al abrir el archivo para escritura.\n");
        return 1;
    }

    time_t start = time(NULL); // Obtener el tiempo de inicio, utilizado para escribir datos durante el tiempo deseado
    time_t current_time;
    
    printf("Recogida de datos en curso");
    int cont=0;
    while (1) {
        
        float distance = getDistance();

        if (distance >= 0.0) {
            fprintf(fp,"%.2f \n",distance);
        }
        
        // Obtener el tiempo actual y comprobar si ha pasado el periodo de tiempo determinado de lectura de datos
        current_time = time(NULL);
        if (current_time - start >= tiempo) {
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
    printf("UltOK");

    return 0;
}

//gcc -o ultrasonido ultrasonido.c -lwiringPi
