#include <SPI.h>
#include <MFRC522.h>
#include <Arduino.h>
#include <ArduinoJson.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <TimeLib.h>
#include <Keypad.h>
#include <Arduino_JSON.h>
// to disable brownout detector for esp32
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

int buzzer = 32;
int flamesensor = 27;
int windowsensor = 34;
String modeofsensor;
int state = LOW;


const char* serverName = "https://13.112.12.146/user/getflamesensordetails/dananjaya.nisansale@gmail.com";
const char* serverName2 = "https://13.112.12.146/user/updatemodesensorstatus/H1SN003";

String json = "{"
              "\"app_id\": \"b146c005-8195-4098-ac19-0e79fd7b7ae2\","
              "\"included_segments\": [\"All\"],"
              "\"data\": {\"foo\": \"bar\"},"
              "\"contents\": {\"en\": \"Fire Sensor is triggering\"},"
              "\"big_picture\": \"https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSZY7qIa1Uqay1qEHGiUfKlw4Bk7qKUonvT9WZ4rM7P&s\""
              "}";

String json2 = "{"
              "\"app_id\": \"b146c005-8195-4098-ac19-0e79fd7b7ae2\","
              "\"included_segments\": [\"All\"],"
              "\"data\": {\"foo\": \"bar\"},"
              "\"contents\": {\"en\": \"Window Sensor is triggering\"},"
              "\"big_picture\": \"https://thumbs.dreamstime.com/b/glass-break-sensor-icon-logo-security-sensor-sign-glass-break-sensor-icon-logo-security-sensor-sign-white-background-138709631.jpg\""
              "}";

char jsonOutput[128];

WiFiMulti WiFiMulti;

void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  // initialize serial communication @ 9600 baud:
  Serial.begin(9600); 
  pinMode(buzzer, OUTPUT);
  pinMode(flamesensor, INPUT);
  pinMode(windowsensor, INPUT);
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP("OPPO", "1343149nd");
  // wait for WiFi connection
  Serial.print("Waiting for WiFi to connect...");
  while ((WiFiMulti.run() != WL_CONNECTED)) {
    Serial.print(".");
  }
  Serial.println(" connected");
}
void loop() {
  WiFiClientSecure *client = new WiFiClientSecure;
  client -> setInsecure();//skip verification
  HTTPClient https;
  WiFiClient client2;
  HTTPClient http;
  String sensorReadings;
	int sensorReading = digitalRead(flamesensor);
  int windowReading = digitalRead(windowsensor);
  Serial.println(sensorReading);
  if(sensorReading == 0){
    if(WiFi.status()== WL_CONNECTED){
              
      sensorReadings = httpGETRequest(serverName);
      JSONVar myObject = JSON.parse(sensorReadings);
  
      // JSON.typeof(jsonVar) can be used to get the type of the var
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }
      modeofsensor =(const char*)myObject["mode"];
      //Serial.println(myObject["mode"]);
    }
    if(modeofsensor.equals("true")){
      Serial.println("There is a fire");
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ; 
      delay(50);
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ;
      delay(50);
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ;
      Serial.println("Fire sensor is triggering");
      Serial.println();
      delay(3000);
      if (https.begin(*client, "https://onesignal.com/api/v1/notifications"))
      { // HTTPS
        https.addHeader("Content-Type", "application/json; charset=utf-8", true, false);
        https.addHeader("Authorization", "Basic MjY2MTA1MjktYzJjZS00ODBmLTg1NmUtZmI1MDUwM2JkMmY4"); // remove '<>' wheb typing api key

        Serial.print("[HTTPS] POST...\n");
        // start connection and send HTTP header
        int httpCode = https.POST(json);

        // httpCode will be negative on error
        if (httpCode > 0)
        {
          // HTTP header has been send and Server response header has been handled
          Serial.printf("[HTTPS] POST... code: %d\n", httpCode);

          if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY)
          {
            String payload = https.getString();
            Serial.println(payload);
          }
        } 
        else
        {
          Serial.printf("[HTTPS] POST... failed, error: %s\n", https.errorToString(httpCode).c_str());
        }
          https.end();
        }
      else
      {
        Serial.printf("[HTTPS] Unable to connect\n");
      }
      HTTPClient client;
        client.begin("https://13.112.12.146/user/updatemodesensorstatus/H1SN003");
        client.addHeader("Content-Type", "application/json");

        const size_t CAPACITY = JSON_OBJECT_SIZE(2);
        StaticJsonDocument<CAPACITY> doc;

        JsonObject object = doc.to<JsonObject>();

        object["status"] = "active";

        serializeJson(doc, jsonOutput);
        Serial.println(jsonOutput);
        int httpCode = client.POST(String(jsonOutput));

        if(httpCode > 0){
          String payload = client.getString();
          Serial.println("\nStatuscode: " + String(httpCode));
          Serial.println(payload);
          client.end();
        }
        else{
          Serial.println("Error on HTTP request");
        }

      
    }
  }
  if(windowReading == 1){
    if(state == LOW){
      if(WiFi.status()== WL_CONNECTED){
              
      sensorReadings = httpGETRequest(serverName);
      JSONVar myObject = JSON.parse(sensorReadings);
  
      // JSON.typeof(jsonVar) can be used to get the type of the var
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }
      modeofsensor =(const char*)myObject["mode"];
      //Serial.println(myObject["mode"]);
    }
    if(modeofsensor.equals("true")){
      Serial.println("Window opened");
      state = HIGH;
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ; 
      delay(50);
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ;
      delay(50);
      digitalWrite(buzzer, HIGH);
      delay(300);
      digitalWrite (buzzer, LOW) ;
      if (https.begin(*client, "https://onesignal.com/api/v1/notifications"))
      { // HTTPS
        https.addHeader("Content-Type", "application/json; charset=utf-8", true, false);
        https.addHeader("Authorization", "Basic MjY2MTA1MjktYzJjZS00ODBmLTg1NmUtZmI1MDUwM2JkMmY4"); // remove '<>' wheb typing api key

        Serial.print("[HTTPS] POST...\n");
        // start connection and send HTTP header
        int httpCode = https.POST(json2);

        // httpCode will be negative on error
        if (httpCode > 0)
        {
          // HTTP header has been send and Server response header has been handled
          Serial.printf("[HTTPS] POST... code: %d\n", httpCode);

          if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY)
          {
            String payload = https.getString();
            Serial.println(payload);
          }
        }
        else
        {
          Serial.printf("[HTTPS] POST... failed, error: %s\n", https.errorToString(httpCode).c_str());
        }
          https.end();
        }
        else
        {
            Serial.printf("[HTTPS] Unable to connect\n");
        }
        HTTPClient client;
        client.begin("https://13.112.12.146/user/updatemodesensorstatus/H1SN001");
        client.addHeader("Content-Type", "application/json");

        const size_t CAPACITY = JSON_OBJECT_SIZE(2);
        StaticJsonDocument<CAPACITY> doc;

        JsonObject object = doc.to<JsonObject>();

        object["status"] = "active";

        serializeJson(doc, jsonOutput);
        Serial.println(jsonOutput);
        int httpCode = client.POST(String(jsonOutput));

        if(httpCode > 0){
          String payload = client.getString();
          Serial.println("\nStatuscode: " + String(httpCode));
          Serial.println(payload);
          client.end();
        }
        else{
          Serial.println("Error on HTTP request");
        }

    }
  }
    
  }
  else{
    if(state == HIGH){
      state = LOW;
    }
  }
}
String httpGETRequest(const char* serverName) {
  WiFiClient client;
  HTTPClient http;
    
  // Your Domain name with URL path or IP address with path
  http.begin(serverName);
  
  // Send HTTP POST request
  int httpResponseCode = http.GET();
  
  String payload = "{}"; 
  
  if (httpResponseCode>0) {
    Serial.print("HTTP Response code: ");
    Serial.println(httpResponseCode);
    payload = http.getString();
  }
  else {
    Serial.print("Error code: ");
    Serial.println(httpResponseCode);
  }
  // Free resources
  http.end();

  return payload;
}