#include <Arduino.h>
#include <WiFi.h>
#include <WiFiMulti.h>
#include <HTTPClient.h>
#include <WiFiClientSecure.h>
#include <Arduino_JSON.h>
// to disable brownout detector for esp32
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

const int Buzzer = 32;       
const int Fire_digital = 14; 

const char* serverName = "https://{DESTINATION URL}/user/getflamesensordetails/dananjaya.nisansale@gmail.com";
const char* serverName2 = "https://{DESTINATION URL}/user/updatemodesensorstatus/H1SN004";
String sensorReadings;
String modeofsensor;

String json = "{" 
  "\"app_id\": \"b146c005-8195-4098-ac19-0e79fd7b7ae2\","
  "\"included_segments\": [\"All\"],"
  "\"data\": {\"foo\": \"bar\"},"
  "\"contents\": {\"en\": \"Flame sensor is triggering\"},"
  "\"big_picture\": \"https://thumbs.dreamstime.com/z/fire-warning-sign-risk-black-flame-symbol-yellow-triangle-isolated-white-background-flammable-materials-caution-simple-icon-155208636.jpg\""
"}";

String httpGETRequest(const char* serverName) {
  WiFiClient client;
  HTTPClient http;
    
  // Your Domain name with URL path or IP address with path
  http.begin(client, serverName);
  
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

void setClock() {
  configTime(0, 0, "pool.ntp.org", "time.nist.gov");

  Serial.print(F("Waiting for NTP time sync: "));
  time_t nowSecs = time(nullptr);
  while (nowSecs < 8 * 3600 * 2) {
    delay(500);
    Serial.print(F("."));
    yield();
    nowSecs = time(nullptr);
  }

  Serial.println();
  struct tm timeinfo;
  gmtime_r(&nowSecs, &timeinfo);
  Serial.print(F("Current time: "));
  Serial.print(asctime(&timeinfo));
}


WiFiMulti WiFiMulti;

void setup() {
  WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
  Serial.begin(115200);
  pinMode(Buzzer, OUTPUT);      
  pinMode(Fire_digital, INPUT_PULLUP);
  
  WiFi.mode(WIFI_STA);
  WiFiMulti.addAP("TEWM_321F2E", "884708C6DC");

  
  // wait for WiFi connection
  Serial.print("Waiting for WiFi to connect...");
  while ((WiFiMulti.run() != WL_CONNECTED)) {
    Serial.print(".");
  }
  Serial.println(" connected");

  //setClock();  
}

void loop() {
  WiFiClientSecure *client = new WiFiClientSecure;
  client -> setInsecure();//skip verification
  HTTPClient https;
  WiFiClient client2;
  HTTPClient http;
  Serial.print("[HTTPS] begin...\n");
  
  int Flame = digitalRead(Fire_digital);

  if(Flame == LOW){
      sensorReadings = httpGETRequest(serverName);
      Serial.println(sensorReadings);
      JSONVar myObject = JSON.parse(sensorReadings);
  
      // JSON.typeof(jsonVar) can be used to get the type of the var
      if (JSON.typeof(myObject) == "undefined") {
        Serial.println("Parsing input failed!");
        return;
      }

      Serial.print("JSON object = ");
      Serial.println(myObject["mode"]);
      modeofsensor = myObject["mode"];
      if(modeofsensor == "true"){
      digitalWrite(Buzzer, HIGH);
        if (https.begin(*client, "https://onesignal.com/api/v1/notifications")) {  // HTTPS
        https.addHeader("Content-Type", "application/json; charset=utf-8",true,false);
        https.addHeader("Authorization", "Basic MjY2MTA1MjktYzJjZS00ODBmLTg1NmUtZmI1MDUwM2JkMmY4"); // remove '<>' wheb typing api key
        
        
        Serial.print("[HTTPS] POST...\n");
        // start connection and send HTTP header
        int httpCode = https.POST(json);
  
        // httpCode will be negative on error
        if (httpCode > 0) {
          // HTTP header has been send and Server response header has been handled
          Serial.printf("[HTTPS] POST... code: %d\n", httpCode);
  
          // file found at server
          // file found at server
          if (httpCode == HTTP_CODE_OK || httpCode == HTTP_CODE_MOVED_PERMANENTLY) {
            String payload = https.getString();
            Serial.println(payload);
          }
        } else {
          Serial.printf("[HTTPS] POST... failed, error: %s\n", https.errorToString(httpCode).c_str());
        }
  
        https.end();
      } else {
        Serial.printf("[HTTPS] Unable to connect\n");
      }
  http.begin(client2, serverName2);
  http.addHeader("Content-Type", "application/json");
  int httpResponseCode2 = http.POST("{\"status\":\"active\"}");
  http.end();
  }
  }
  else{
    digitalWrite(Buzzer, LOW);
  }

}
