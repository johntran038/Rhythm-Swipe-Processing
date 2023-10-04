//ROTATION VARIABLES
#define encoder0PinA  2
#define encoder0PinB  4
#define Switch 5 // Switch connection if available

volatile int encoder0Pos = 0;
volatile String direction = "0";
int target = encoder0Pos;
int prev = encoder0Pos;
int itest = 0;

//LIGHT VARIABLES
int lightSensor;
int sensorLow = 1023;
int sensorHigh = 0;
bool move = false;
int brightBright = 0;
int getBack = 1;
bool calibrate = true;


void setup() { 

  pinMode(encoder0PinA, INPUT); 
  digitalWrite(encoder0PinA, HIGH);       // turn on pullup resistor
  pinMode(encoder0PinB, INPUT); 
  digitalWrite(encoder0PinB, HIGH);       // turn on pullup resistor
  pinMode(Switch, INPUT); 
  digitalWrite(Switch, HIGH);       // turn on pullup resistor
  attachInterrupt(0, doEncoder, RISING); // encoder pin on interrupt 0 - pin2
  Serial.begin (9600);
  Serial.println("\nNew run...");                // a personal quirk

  // calibrate for the first five seconds after program runs
  while (millis() < 3000) {
    // record the maximum sensor value
    lightSensor = analogRead(A0);
    if (lightSensor > sensorHigh) {
      sensorHigh = lightSensor;
    }
    // record the minimum sensor value
    if (lightSensor < sensorLow) {
      sensorLow = lightSensor;
    }
    if(lightSensor > brightBright){
      brightBright = lightSensor;
    }
  }
}

void loop(){
  
  if(calibrate){
    calibrate = false;
    
    brightBright = 0;
    for (int i=0; i<300; i++) {
      // record the maximum sensor value
      lightSensor = analogRead(A0);
      if (lightSensor > sensorHigh) {
        sensorHigh = lightSensor;
      }
      // record the minimum sensor value
      if (lightSensor < sensorLow) {
        sensorLow = lightSensor;
      }
      if(lightSensor > brightBright){
        brightBright = lightSensor;
      }
    }
    brightBright = brightBright+100;
    Serial.println(brightBright);
    // Serial.println("Calibrated");
  }


  lightSensor = analogRead(A0);
  if(!move && lightSensor >= brightBright){
    move = true;
    Serial.println("move");
  }
  if(move && lightSensor < brightBright){
    move = false;
  }


  if(encoder0Pos != target){
  
    target = encoder0Pos;
  }
  else{
    if(encoder0Pos>prev){
      Serial.println("ccw");
      prev = encoder0Pos;
    }
    else if(encoder0Pos<prev){
      Serial.println("cw");
      prev = encoder0Pos;
    }

    
  }

  if(digitalRead(Switch)!=HIGH){
    calibrate = true;
    Serial.println("cal");


  }
  delay(100);
}

void doEncoder() {
  if (digitalRead(encoder0PinB)==HIGH) {
    encoder0Pos++;
  }else {
      encoder0Pos--;
  }
}