import processing.serial.*;           // imports library for serial communication
import java.awt.event.KeyEvent;       // imports library for reading the data from the serial port
import java.io.IOException;

Serial myPort;                        // defines Object Serial

// defubes variables
  PFont fontA;
  color backColor;
  String angle="";
  String distance="";
  String data="";
  String noObject;
  float pixsDistance;
  int iAngle, iDistance, iAngle180, iDistance180;
  int index0=0;
  int index1=0;
  int index2=0;
  PFont orcFont;
  int COMPort;
  int [] keyIn = new int[3];
  int i, keyIndex=0;
  boolean portChosen = false;
  
void setup() {    
  size (850, 650); // ***CHANGE THIS TO YOUR SCREEN RESOLUTION***
  smooth();
  textAlign(CENTER);

  color baseColor = color(0,0,0);
  backColor = baseColor;
    
  background(backColor);
  stroke(255);
  text("Por favor, pulse cualquier tecla para iniciar el radar", width/2, height*0.15);
  textAlign(LEFT);
  for(i=0 ; i<Serial.list().length ; i++){
    text("[" + i + "] " + Serial.list()[i], width*0.46, (height*0.19)+13*i);
  }
 }
/*
  Almacena la tecla presionada por el usuario.
  Se usa para elegir el Arduino dependiendo del puerto
  serial mostrado al inicio
  --------------------------------------------
  ejemplo:
  PORT 3 [0]
  PORT 9 [1]
  si se presiona 1 en el teclado se seleccionara
  el PORT 9 para recibir
  ---------------------------------------------
  Returns: NULL;
 */
void keyPressed() { 
  if(portChosen == false){
      COMPort = 0;
   try{
      for (i = 0; i < keyIndex; i++)
        COMPort = COMPort * 10 + keyIn[i];      
      println(COMPort);
      myPort = new Serial(this, Serial.list()[COMPort], 9600);
      myPort.bufferUntil('.');
      portChosen = true;
      textAlign(CENTER);
   }
 catch (ArrayIndexOutOfBoundsException e){}
  }// if (portChosen == false)
}//keyPressed()
 
void draw() {  
  if(portChosen == true){         
    noStroke(); 
    fill(0,0,0,5);
    rect(0, 0, width, height-height*0.065);     
    drawRadar(); 
    drawLine();
    drawLine180();
    drawObject();
    drawObject180();
    drawText();
  }
}
/*
   void drawRadar()
   -----------------------------------
   Esta clase dibuja las lineas y posiciona el radar.
   width y height son tomado de los valores ingresados
   en la funcion size(x,y) al inicio del programa.
   -------------------------------------
   returns: NULL 
*/
void drawRadar() {  
  pushMatrix();
  translate(width/2,height/2); // Mueves las coordenadas a la mitad de la pantalla
  noFill();
  strokeWeight(1);
  stroke(64);
  //dibuja los arcos
  arc(0,0,(width-width*0.0625),(width-width*0.0625),PI,TWO_PI+TWO_PI);//dibyja =
  arc(0,0,(width-width*0.27),(width-width*0.27),PI,TWO_PI+TWO_PI);
  arc(0,0,(width-width*0.479),(width-width*0.479),PI,TWO_PI+TWO_PI);
  arc(0,0,(width-width*0.687),(width-width*0.687),PI,TWO_PI+TWO_PI);
  //dibuja las lineas 
  line(-width/2,0,width/2,0);
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(30)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(60)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(90)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(120)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(150)));
  line(0,0,(-width/2)*cos(radians(30)),(-width/2)*sin(radians(210)));
  line(0,0,(-width/2)*cos(radians(60)),(-width/2)*sin(radians(240)));
  line(0,0,(-width/2)*cos(radians(90)),(-width/2)*sin(radians(270)));
  line(0,0,(-width/2)*cos(radians(120)),(-width/2)*sin(radians(300)));
  line(0,0,(-width/2)*cos(radians(150)),(-width/2)*sin(radians(330)));
  line((-width/2)*cos(radians(30)),0,width/2,0);
  popMatrix();
}//drawRadar()

// LINEAS VERDES
void drawLine(){
  pushMatrix();
  strokeWeight(4);
  stroke(0,255,0);
  translate(width/2,height/2); // moves the starting coordinats to new location
  line(0,0,(height-height*0.12)*cos(radians(iAngle)),-(height-height*0.12)*sin(radians(iAngle))); // draws the line according to the angle
  popMatrix();
}

void drawLine180(){
  pushMatrix();
  strokeWeight(4);
  stroke(0,255,180);
  translate(width/2,height/2); // moves the starting coordinats to new location
  line(0,0,(height-height*0.12)*cos(radians(iAngle180)),-(height-height*0.12)*sin(radians(iAngle180))); // draws the line according to the angle
  popMatrix();
}

// LINEAS ROJAS
void drawObject(){
  pushMatrix();
  translate(width/2,height/2); // moves the starting coordinats to new location
  strokeWeight(4);
  stroke(255,0,0);
  pixsDistance = iDistance*((height-height*0.1666)*0.025); // convierte la distancia del sensor de cm a pixeles
  //limitandolo a 40cm 
  if(iDistance<40){
    // draws the object according to the angle and the distance
    line(pixsDistance*cos(radians(iAngle)),-pixsDistance*sin(radians(iAngle)),(width-width*0.505)*cos(radians(iAngle)),-(width-width*0.505)*sin(radians(iAngle)));
  }
  popMatrix();
}

void drawObject180(){
  pushMatrix();
  translate(width/2,height/2); // moves the starting coordinats to new location
  strokeWeight(4);
  stroke(255,0,0);
  pixsDistance = iDistance180*((height-height*0.1666)*0.025); // convierte la distancia del sensor de cm a pixeles
  //limitandolo a 40cm 
  if(iDistance180<40){
    // draws the object according to the angle and the distance
    line(pixsDistance*cos(radians(iAngle180)),-pixsDistance*sin(radians(iAngle180)),(width-width*0.505)*cos(radians(iAngle180)),-(width-width*0.505)*sin(radians(iAngle180)));
  }
  popMatrix();
}
void drawText() { // draws the texts on the screen  
  pushMatrix();
  if(iDistance>40) {
    noObject = "Out of Range";
  }
  else {
    noObject = "In Range";
  }
  
  fill(0,0,0);
  noStroke();
  rect(0, height-height*0.0648, width, height);
  
  fill(150);
  textSize(16);  
  text("10cm",width-width*0.3854,height-height*0.5);
  text("20cm",width-width*0.281,height-height*0.5);
  text("30cm",width-width*0.177,height-height*0.5);
  text("40cm",width-width*0.0729,height-height*0.5);
  
  textSize(20);
  text("CIDETIU", width-width*0.875, height-height*0.0277);
  text(iAngle +"°"+"|", width*0.48, height-height*0.0277);
  text(iAngle180+"°",width*0.54, height-height*0.0277);
  text(iDistance +" cm", width*0.76, height-height*0.0277);
  text(iDistance180 +" cm", width*0.85, height-height*0.0277);

  textSize(20);
  fill(150);
  translate((width*0.98),(height*0.5));
  rotate(radians(0));
  text("0°",0,0);
  resetMatrix();
  translate((width*0.76),(height*0.31));
  rotate(-radians(-60));
  text("30°",0,0);
  resetMatrix();
  translate(width*0.66,height*0.15);
  rotate(-radians(-30));
  text("60°",0,0);
  resetMatrix();
  translate((width*0.5)+width/2*cos(radians(90)),height*0.07);
  rotate(radians(0));
  text("90°",0,0);
  resetMatrix();
  translate(width*0.34,(height*0.14));
  rotate(radians(-30));
  text("120°",0,0);
  resetMatrix();
  translate((width*0.23),(height*0.28));
  rotate(radians(-60));
  text("150°",0,0);
  resetMatrix();
  translate((width*0.10),(height*0.5));
  rotate(radians(0));
  text("180°",0,0);
  resetMatrix();
  translate((width*0.23),(height*0.72));
  rotate(radians(60));
  text("210°",0,0);
  resetMatrix();
  translate(width*0.34,(height*0.88));
  rotate(radians(30));
  text("240°",0,0);
  resetMatrix();
  translate(width*0.5,height*0.90);
  rotate(radians(0));
  text("270°",0,0);
  resetMatrix();
  translate(width*0.66,height*0.85);
  rotate(radians(-30));
  text("300°",0,0);
  resetMatrix();
  translate((width*0.77),(height*0.70));
  rotate(radians(-60));
  text("330°",0,0);
  resetMatrix();
  popMatrix(); 
}


void serialEvent (Serial myPort) { // starts reading data from the Serial Port
  // reads the data from the Serial Port up to the character '.' and puts it into the String variable "data".
  String SensorNum;//obtiene el string que contiene SENSOR1 o SENSOR2
  int SensorIndex;//Lee la variable data hasta encontrar el caracter ","
  data = myPort.readStringUntil('.');
  System.out.println(data);
  data = data.substring(0,data.length()-1);
  SensorIndex = data.indexOf(",");
  SensorNum = data.substring(0,SensorIndex);//
  index0 = data.indexOf("|"); // find the character ',' and puts it into the variable "index1"
  data = data.substring(index0+2,data.length());
  
  index1 = data.indexOf(","); // find the character ',' and puts it into the variable "index1"
  angle= data.substring(0, index1); // read the data from position "0" to position of the variable index1 or thats the value of the angle the Arduino Board sent into the Serial Port
  distance= data.substring(index1+1, data.length()); // read the data from position "index1" to the end of the data pr thats the value of the distance
  
  SensorNum = SensorNum.replaceAll("\\s","");
  
  // converts the String variables into Integer
  if(SensorNum.equals("SENSOR1")==true){
      iAngle = int(angle);
      iDistance = int(distance);
  }//if 
  
  if(SensorNum.equals("SENSOR2")==true){
      iAngle180 = int(angle);
      iDistance180 = int(distance);
  }//if 
}
