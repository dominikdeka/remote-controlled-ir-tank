#include <RF24.h>

#define CE_PIN A1
#define CSN_PIN A0
#define x_axis A3 // x axis
#define y_axis A4 //y axis
#define button1 A2 // joystick button
#define button2 2 // A button
#define button3 3 // B button

byte veh_no = 4; //set vehicle number before uploading 

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

byte batteryLedPin = 4;

int data[5];  
int last_data[5];  

void setup() 
{
  radio.begin();
  radio.setChannel(wifi_chanel);
  radio.setDataRate(RF24_250KBPS);
  radio.openWritingPipe(pipe);
  radio.stopListening();
  pinMode(button1, INPUT_PULLUP);
  pinMode(button2, INPUT);
  pinMode(button3, INPUT);
  delay(100);
}
int i = 0;
void loop()   
{

  //read voltage and show battery level indicator
  int sensorValue = analogRead(A5);
  float voltage = sensorValue * (5.00 / 1023.00);
  if(voltage < 3.90){
    digitalWrite(batteryLedPin, HIGH);
  } else {
    digitalWrite(batteryLedPin, LOW);
  }

  
  data[0] = analogRead(x_axis);
  data[1] = analogRead(y_axis);
  data[2] = 1 - digitalRead(button1);
  data[3] = digitalRead(button2);
  data[4] = digitalRead(button3);
  if(abs(last_data[0] - data[0])>10 ||
    abs(last_data[1] - data[1])>10 ||
    last_data[2] != data[2] ||
    last_data[3] != data[3] ||
    last_data[4] != data[4]){  

    last_data[0] = data[0];
    last_data[1] = data[1];
    last_data[2] = data[2];
    last_data[3] = data[3];
    last_data[4] = data[4];
    radio.write( data, sizeof(data) ); 
    
  }
}
