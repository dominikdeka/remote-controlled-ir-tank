#include <RF24.h>
#include <IRremote.h>

#define CE_PIN   A1
#define CSN_PIN A0

byte veh_no = 0; //set vehicle number before uploading 

uint64_t pipes[] = {
    0xB00B1E5000LL, // 0
    0xE8E8F0F0E1LL, // 1
    0xF0F0F0F0A1LL, // 2
    0xE8E8F0F0E2LL, // 3
    0xE8E8F0F0E3LL // 4
  };

int channels[] = {
    101, // 0
    102, // 1
    103, // 2
    104, // 3
    105 // 4
  };

const uint64_t pipe = pipes[veh_no];
const int wifi_chanel = channels[veh_no];
RF24 radio(CE_PIN, CSN_PIN); 

int recvPin = A2;
IRrecv irrecv(recvPin);
decode_results results;

IRsend irsend;

// 74HC595 (shift register) pins
byte latchPin = 6;
byte clockPin = 5;
byte dataPin = 4;

byte batteryLedPin = 0;
byte buzzerPin = 1;
//7segments pins
byte digitsPins[3] = {2,8,7};

byte motorADigitalPin = A4;
byte motorAPWMPin = 9;
byte motorBDigitalPin = A3;
byte motorBPWMPin = 10;
const byte FORWARD = 0;
const byte BACKWARD = 1;
const byte LEFT = 1;
const byte RIGHT = 0;

int turning_strength = 120;
int sensitivity = 10;

//game conf vars
const int shot_delay = 5000;
const int blink_interval = 500;

//current state vars
int shot_counter = 0;
unsigned long last_shot_time = -5000;
boolean display_on = true;
unsigned long last_blink = -500;

void setup() {
  pinMode(recvPin, INPUT);
  irrecv.enableIRIn(); // Start the receiver

  for (int i = 0; i < 3; i++) {
    pinMode(digitsPins[i], OUTPUT);
  }
  pinMode(latchPin, OUTPUT);
  pinMode(clockPin, OUTPUT);
  pinMode(dataPin, OUTPUT);

  pinMode(batteryLedPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
  digitalWrite(batteryLedPin, LOW);
  digitalWrite(buzzerPin, LOW);

  radio.begin();
  radio.setChannel(wifi_chanel);
  radio.setDataRate(RF24_250KBPS);
  radio.openReadingPipe(1,pipe);
  radio.startListening();

  pinMode(motorADigitalPin, OUTPUT);
  pinMode(motorAPWMPin, OUTPUT);
  pinMode(motorBDigitalPin, OUTPUT);
  pinMode(motorBPWMPin, OUTPUT);
  digitalWrite(motorADigitalPin, 0);
  analogWrite(motorAPWMPin, 0);
  analogWrite(motorBPWMPin, 0);
  digitalWrite(motorBDigitalPin, 0);

}

// the loop routine runs over and over again forever:
void loop() {
  unsigned long current_millis = millis();

  //read voltage and show battery level indicator
  int sensorValue = analogRead(A5);
  float voltage = sensorValue * (5.00 / 1023.00) * 2;
  if(voltage < 7.60){
    digitalWrite(batteryLedPin, HIGH);
  } else {
    digitalWrite(batteryLedPin, LOW);
  }

  //seven segments display
  if(current_millis - last_shot_time > shot_delay){
    printNumber(shot_counter);
  } else {
    //blinking display    

    if (current_millis - last_blink >= blink_interval) {
      last_blink = current_millis;
      display_on = !display_on;
    }
    if(display_on){
      printNumber(shot_counter);
    } else {
      counterOff();
    }
  }

  
  if ( radio.available() )
  {
    int data[5]; 
    radio.read( data, sizeof(data) );
    int joystickX = data[0];
    int joystickY = data[1];
    int button1 = data[2]; 
    int button2 = data[3];  
    int button3 = data[4]; 
    if(shot_counter <=5){

      drive(joystickX, joystickY);
      
      if(button2 && millis() - last_shot_time > shot_delay){
        delay(10);
        irsend.sendJVC(0xF503, 16, 0);
        delay(20);
        
        irrecv.enableIRIn();
        iShot();
        last_shot_time = current_millis;
      }
    }
//    if(button1){
//      shot_counter=0;
//    }
     
  }

  if (irrecv.decode(&results)) {
    if(results.value==0xF503){
      iAmShoted();
      shot_counter++;
    } else if(results.value==0xF583){
      shot_counter--;
    }
    irrecv.resume(); // Receive the next value
  }

}

void drive(int x_axis, int y_axis) {

 
  int x_hiz = map(x_axis,0,1023,-255,255);
  int y_hiz = map(y_axis,0,1023,-170,170);
  
  if(abs(y_hiz) > sensitivity){
    int left_substract = x_hiz > sensitivity ? turning_strength : 0;
    int right_substract = x_hiz < -1 * sensitivity ? turning_strength : 0;
    int speed_left = 60 + abs(y_hiz) - left_substract;
    int speed_right = 60 + abs(y_hiz) - right_substract;
    engineControl(LEFT, y_hiz > 0 ? FORWARD : BACKWARD, speed_left > 0 ? speed_left : 0 );
    engineControl(RIGHT, y_hiz > 0 ? FORWARD : BACKWARD, speed_right > 0 ? speed_right : 0 );
  } else {
    engineControl(LEFT, FORWARD, 0 );
    engineControl(RIGHT, FORWARD, 0 );
  }
    
}

void iAmShoted(){
  for(int i = 0; i<=shot_counter; i++){
    digitalWrite(buzzerPin, 1);
    engineControl(LEFT, FORWARD, 155 );
    engineControl(RIGHT, BACKWARD, 155 );
    delay(50 + shot_counter * 10);
    engineControl(LEFT, BACKWARD, 155 );
    engineControl(RIGHT, FORWARD, 155 );
    delay(50 + shot_counter * 10);
    digitalWrite(buzzerPin, 0);
    engineControl(LEFT, FORWARD, 155 );
    engineControl(RIGHT, BACKWARD, 155 );
    delay(50 + shot_counter * 10);
    engineControl(LEFT, BACKWARD, 155 );
    engineControl(RIGHT, FORWARD, 155 );
    delay(50 + shot_counter * 10);
    engineControl(LEFT, FORWARD, 0 );
    engineControl(RIGHT, FORWARD, 0 );
  }
}
void iShot(){
    digitalWrite(buzzerPin, 1);

    engineControl(LEFT, FORWARD, 155 );
    engineControl(RIGHT, FORWARD, 155 );
    delay(70);
    engineControl(LEFT, BACKWARD, 155 );
    engineControl(RIGHT, BACKWARD, 155 );
    delay(70);
    engineControl(LEFT, FORWARD, 155 );
    engineControl(RIGHT, FORWARD, 155 );
    delay(10);
    digitalWrite(buzzerPin, 0);

}

void engineControl(byte engine, byte direction, byte speed){
  
  if(engine == LEFT) {
    digitalWrite(motorADigitalPin, direction == FORWARD ? LOW : HIGH);
    analogWrite(motorAPWMPin, direction == FORWARD ? speed : 255 - speed);
  } else {
    digitalWrite(motorBDigitalPin, direction == FORWARD ? LOW : HIGH);
    analogWrite(motorBPWMPin, direction == FORWARD ? speed : 255 - speed);
  }
}

void resetOutput(){
  for (int i = 0; i < 3; i++) {
    digitalWrite(digitsPins[i], LOW);
  }
}
void counterOff(){
  for (int i = 0; i < 3; i++) {
    digitalWrite(digitsPins[i], LOW);
  }
}

void printNumber(int number){
    byte hundreds = number / 100;
    byte dozens = (number - hundreds * 100) / 10;
    byte oneness = number - hundreds * 100 - dozens * 10;

    byte digits[] = {hundreds, dozens, oneness};
    printDigits(digits);

}
void printDigits(byte digits[]){
  int digits_count = 3;
  static int count = 0;
  byte symbols[] = {
    B00010100, // 0
    B10110111, // 1
    B00101100, // 2
    B00100101, // 3
    B10000111, // 4
    B01000101, // 5
    B01000100, // 6
    B00110111, // 7
    B00000100, // 8
    B00000101, // 9
    B11111111 // 10
  };

  for (int i = 0; i < digits_count; i++) {
    digitalWrite(digitsPins[i], LOW);
  }
  byte eightBits = symbols[digits[count]];

  digitalWrite(latchPin, LOW);  // prepare shift register for data
  shiftOut(dataPin, clockPin, LSBFIRST, eightBits); // send data
  digitalWrite(latchPin, HIGH); // update display

  digitalWrite(digitsPins[count], HIGH);
  
  count = (count + 1) % 3; 
  for (int i = 0; i < digits_count; i++) {
    digitalWrite(digitsPins[i], LOW);
  }

}
