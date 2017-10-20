#include <nRF24L01.h>
#include <printf.h>
#include <RF24.h>
#include <RF24_config.h>
#include <SevenSeg.h>
#include <IRremote.h>

SevenSeg disp(A0,A1,A2,A3,A4,A5,8);
const int numOfDigits=2;
int digitPins[numOfDigits]={0,1};

int RECV_PIN = 7;
IRrecv irrecv(RECV_PIN);
decode_results results;

IRsend irsend;

const int motorLeftIn2 = 2;
const int motorRightIn2 = 4;

const int motorLeftIn1 = 6;
const int motorRightIn1 = 5;


#define CE_PIN   9
#define CSN_PIN 10

const uint64_t pipe = 0xE8E8F0F0E1LL;
RF24 radio(CE_PIN, CSN_PIN); 

int turning_strength = 130;
int speed_pwm = 255;
int sensitivity = 10;

int x_hiz=0;
int y_hiz=0;

int data[9]; 
int shot_counter = 0;
unsigned long last_shot_time = -5000;
int shot_delay = 5000;
int blink_interval = 500;
boolean display_on = true;
unsigned long last_blink = -500; 
void setup()   
{
  pinMode(motorLeftIn1,OUTPUT);
  pinMode(motorRightIn1,OUTPUT);
  pinMode(motorLeftIn2,OUTPUT);
  pinMode(motorRightIn2,OUTPUT);
//  pinMode(7, OUTPUT);  //setting rows to ouput
//  pinMode(1, OUTPUT);  //setting rows to ouput
//  pinMode(0, OUTPUT);  //setting rows to ouput
//  pinMode(A6, OUTPUT);  

  disp.setDigitPins(numOfDigits, digitPins);

//  disp.setDPPin(A7);
 
//  Serial.begin(9600);                        
    
  radio.begin();
  radio.setChannel(40);
  radio.setDataRate(RF24_250KBPS);
  radio.openReadingPipe(1,pipe);
  radio.startListening();

  pinMode(RECV_PIN, INPUT);
  irrecv.enableIRIn();
}

void loop() {
  unsigned long current_millis = millis();

  //seven segments display
  if(current_millis - last_shot_time > shot_delay){
    disp.write(shot_counter);
  } else {
    //blinking display    

    if (current_millis - last_blink >= blink_interval) {
      last_blink = current_millis;
      display_on = !display_on;
    }
    if(display_on){
      disp.write(shot_counter);
    } else {
      disp.clearDisp();
    }
  }

  //read nl24l (wifi) input
  if ( radio.available() )
  {
    int data[9]; 
    radio.read( data, sizeof(data) ); 
    int joystickX = data[0];
    int joystickY = data[1];
    int button1 = data[2]; 
    int button2 = data[3];  
    int button3 = data[4]; 
    int button4 = data[5];
    int button5 = data[6];
    int button6 = data[7];
    int button7 = data[8];

    drive(joystickX,joystickY);

    if(!button3 && button2 && button4 && button5 && millis() - last_shot_time > shot_delay){
      irsend.sendJVC(0xF503, 16, 0);
      irrecv.enableIRIn();
      last_shot_time = current_millis;
    }
  
    if(!button5 && button2 && button3 && button4){
      shot_counter=0;
    }
  
    if(!button2 && button4 && speed_pwm < 255){
      speed_pwm+=10; 
    }
  
    if(button2 && !button4 && speed_pwm > 140){
      speed_pwm-=10;   
    }

  }

  //read TSOP31236 (infra red) input
  if (irrecv.decode(&results)) {
//    Serial.println(results.value, HEX);
    if(results.value==0xF503){
      iAmShot();
      shot_counter++;
    } else if(results.value==0xF583){
      shot_counter--;
    }
    irrecv.resume(); // Receive the next value
  }

}

void drive(int x_axis, int y_axis) {

 
  int x_hiz = map(x_axis,0,1023,-255,255);
  int y_hiz = map(y_axis,0,1023,-255,255);
  
  int right_substract = x_hiz > sensitivity ? turning_strength : 0;
  int left_substract = x_hiz < -1 * sensitivity ? turning_strength : 0;
  
  int left_speed_pwm = y_hiz > sensitivity ? speed_pwm  - left_substract : (y_hiz < -1 * sensitivity ? 255 - speed_pwm + left_substract : 0);
  int left_mode = y_hiz < -1 * sensitivity ? 255 : 0;
  int right_speed_pwm = y_hiz > sensitivity ? speed_pwm - right_substract : (y_hiz < -1 * sensitivity ? 255 - speed_pwm + right_substract : 0);
  int right_mode = y_hiz < -1 * sensitivity ? 255 : 0;
  
  analogWrite(motorLeftIn1, left_speed_pwm);
  analogWrite(motorLeftIn2, left_mode);
  analogWrite(motorRightIn1, right_speed_pwm);
  analogWrite(motorRightIn2, right_mode);
}

void iAmShot(){
  analogWrite(motorLeftIn1, 255);
  analogWrite(motorLeftIn2, 0);
  analogWrite(motorRightIn1, 0);
  analogWrite(motorRightIn2, 255);
  delay(100);
  analogWrite(motorLeftIn1, 0);
  analogWrite(motorLeftIn2, 255);
  analogWrite(motorRightIn1, 255);
  analogWrite(motorRightIn2, 0);
  delay(100);
  analogWrite(motorLeftIn1, 255);
  analogWrite(motorLeftIn2, 0);
  analogWrite(motorRightIn1, 0);
  analogWrite(motorRightIn2, 255);
  delay(100);
  analogWrite(motorLeftIn1, 0);
  analogWrite(motorLeftIn2, 255);
  analogWrite(motorRightIn1, 255);
  analogWrite(motorRightIn2, 0);
  delay(100);
  analogWrite(motorLeftIn1, 0);
  analogWrite(motorLeftIn2, 1);
  analogWrite(motorRightIn1, 0);
  analogWrite(motorRightIn2, 1);

}

