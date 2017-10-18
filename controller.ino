#include <nRF24L01.h>
#include <printf.h>
#include <RF24.h>
#include <RF24_config.h>



#define CE_PIN   9
#define CSN_PIN 10
#define x_axis A0 // x axis
#define y_axis A1 //y axis
#define button1 8 // joystick button
#define button2 2 // A button
#define button3 3 // B button
#define button4 4 // C button
#define button5 5 // D button
#define button6 6 // E button
#define button7 7 // F button




const uint64_t pipe = 0xE8E8F0F0E1LL; 
RF24 radio(CE_PIN, CSN_PIN); 
int data[9];  
int last_data[9];  

void setup() 
{
//  Serial.begin(9600);
  radio.begin();
  radio.setChannel(40);
  radio.setDataRate(RF24_250KBPS);
  radio.openWritingPipe(pipe);
  radio.stopListening();
  pinMode(button1, INPUT);
  pinMode(button2, INPUT);
  pinMode(button3, INPUT);
  pinMode(button4, INPUT);
  pinMode(button5, INPUT);
  pinMode(button6, INPUT);
  pinMode(button7, INPUT);
//  delay(100);
}
int i = 0;
void loop()   
{
  data[0] = analogRead(x_axis);
  data[1] = analogRead(y_axis);
  data[2] = digitalRead(button1);
  data[3] = digitalRead(button2);
  data[4] = digitalRead(button3);
  data[5] = digitalRead(button4);
  data[6] = digitalRead(button5);
  data[7] = digitalRead(button6);
  data[8] = digitalRead(button7);
  if(abs(last_data[0] - data[0])>10 ||
    abs(last_data[1] - data[1])>10 ||
    last_data[2] != data[2] ||
    last_data[3] != data[3] ||
    last_data[4] != data[4] ||
    last_data[5] != data[5] ||
    last_data[6] != data[6] ||
    last_data[7] != data[7] ||
    last_data[8] != data[8]){  
    last_data[0] = data[0];
    last_data[1] = data[1];
    last_data[2] = data[2];
    last_data[3] = data[3];
    last_data[4] = data[4];
    last_data[5] = data[5];
    last_data[6] = data[6];
    last_data[7] = data[7];
    last_data[8] = data[8];
//    Serial.println(i++);
    radio.write( data, sizeof(data) ); 
  }
}
