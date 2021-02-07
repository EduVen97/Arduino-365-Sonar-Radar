
/*________________________________________________
  |                                              |
  |         CODIGO DEL RADAR ARDUINO             |
  |   Codigo Original hecho por:                 |
  | -Ing. Eduardo Enique González Moran          |
  | -Ing. Abdel Mohamed El Chama Andrade         |
  |                                              |
  |    Depurado y comentado por:                 |
  |    Br. Eduardo Fermín Toro Beltrán           |
  |    (c) URBE, CIDETIU, GIRA (2019)            |
  |                                              |
  |   Proposito del codigo:                      |
  |   Imprimir los datos recibidos por el        |
  |   sensor HC-SR04 que esta conectado al       |
  |   pin digital 12 del arduino.                |
  |                                              |
  |   Los datos son mandados por serial al       |
  |   programa hecho en processing 3 para        |
  |   ser graficados.                            |
  |                                              |
  |                                              |
  |______________________________________________|*/
#include <Servo.h>//libreria Servo estandar de ARDUINO 
#include <Ultrasonic.h>//Libreria del sensor Ultrasonico en el archivo Ultrasonic-3.0.0.rar

const unsigned int trigPin1 = 10; //Pin Trigger del HC-SR04 1
const unsigned int echoPin1 = 11; //Pin Echo del HC-SR04 1
const unsigned int trigPin2 = 5; //Pin Trigger del HC-SRO4 2
const unsigned int echoPin2 = 6; //Pin echo del HC-SR04 2
const unsigned int ServoPin = 2; //Pin que envia la señal PWM al servo
const unsigned int LED1 = 7;//pin del led 1
const unsigned int LED2 = 8;//pin del led 2
int pos = 0; // Registra la posicion actual del servo
const int delay_time = 10;
int distance, distance2;

Ultrasonic ultrasonic(trigPin1, echoPin1);
Ultrasonic ultrasonic2(trigPin2, echoPin2);
Servo myServo;

void setup() {
  Serial.begin(9600);
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);
  pinMode(LED1, OUTPUT);
  pinMode(LED2, OUTPUT);
  myServo.attach(ServoPin);
  pos = myServo.read();//lee la posicion del servo.
  while (pos > 0) { //si la posicion del sevo es mayor a 0
    myServo.write(0);//devuelve el servo a la posicion 0
    delay(10);//retardo
    pos = myServo.read();
  }//while pos>15
  while (!Serial){};
  myServo.write(0);
  delay(2000);
}// void setup ()

void loop() {
  // ROTACION EN DESDE 15 HASTA 165°
  for (int i = 0 ; i < 180 ; i++) {
    int rotation2 = i + 180;
    myServo.write(i);
    distance = ultrasonic.read(CM);
    distance2 = ultrasonic2.read(CM);
    print_values(i, distance);
    print_values2(rotation2, distance2);
  }// for 15 -165
  // ROTACION EN DESDE 165 HASTA 15°
  for (int i = 180; i > 0 ; i--) {
    int rotation2 = i + 180;
    myServo.write(i);
    distance = ultrasonic.read(CM);
    distance2 = ultrasonic2.read(CM);
    print_values(i, distance);
    print_values2(rotation2, distance2);
  }//for 165 - 15
}//Loop

void print_values(int i, int distance) {
  Serial.print("SENSOR1,|,");
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.println(".");
  if (distance<=35){
       digitalWrite(LED1,HIGH);
      }//if 
    else if (distance>35){
       digitalWrite(LED1, LOW);
      }//else if 
} //print_values()
void print_values2(int i, int distance) {
  Serial.print("SENSOR2,|,");
  Serial.print(i);
  Serial.print(",");
  Serial.print(distance);
  Serial.println(".");
   if (distance<=35){
        digitalWrite(LED2,HIGH);
    }//if distance2
    else if (distance>35){
        digitalWrite(LED2,LOW);
      }//else if 
}//print_values2
