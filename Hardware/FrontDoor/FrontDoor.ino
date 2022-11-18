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
#include <LiquidCrystal_I2C.h>
// to disable brownout detector for esp32
#include "soc/soc.h"
#include "soc/rtc_cntl_reg.h"

#define SS_PIN 5
#define RST_PIN 15
MFRC522 mfrc522(SS_PIN, RST_PIN); // Create MFRC522 instance.

#define ROW_NUM 4    // four rows
#define COLUMN_NUM 3 // three columns

int lcdColumns = 16;
int lcdRows = 2;

// set LCD address, number of columns and rows
// if you don't know your display address, run an I2C scanner sketch
LiquidCrystal_I2C lcd(0x27, lcdColumns, lcdRows); 

String json = "{"
              "\"app_id\": \"b146c005-8195-4098-ac19-0e79fd7b7ae2\","
              "\"included_segments\": [\"All\"],"
              "\"data\": {\"foo\": \"bar\"},"
              "\"contents\": {\"en\": \"Authorized Access by Dananjaya\"},"
              "\"big_picture\": \"https://cdn0.iconfinder.com/data/icons/flat-security-icons/512/lock-open-blue.png\""
              "}";

String json2 = "{"
               "\"app_id\": \"b146c005-8195-4098-ac19-0e79fd7b7ae2\","
               "\"included_segments\": [\"All\"],"
               "\"data\": {\"foo\": \"bar\"},"
               "\"contents\": {\"en\": \"Unauthorized Access\"},"
               "\"big_picture\": \"https://cdn0.iconfinder.com/data/icons/flat-security-icons/512/lock-open-blue.png\""
               "}";
char jsonOutput[128];

char keys[ROW_NUM][COLUMN_NUM] = {
    {'1', '2', '3'},
    {'4', '5', '6'},
    {'7', '8', '9'},
    {'*', '0', '#'}};

byte pin_rows[ROW_NUM] = {13, 12, 14, 27};  // GIOP18, GIOP5, GIOP17, GIOP16 connect to the row pins
byte pin_column[COLUMN_NUM] = {26, 25, 33}; // GIOP4, GIOP0, GIOP2 connect to the column pins

Keypad keypad = Keypad(makeKeymap(keys), pin_rows, pin_column, ROW_NUM, COLUMN_NUM);

const String password = "1340"; // change your password here
String input_password;

String httpGETRequest(const char *serverName)
{
    WiFiClient client;
    HTTPClient http;

    // Your Domain name with URL path or IP address with path
    http.begin(client, serverName);

    // Send HTTP POST request
    int httpResponseCode = http.GET();

    String payload = "{}";

    if (httpResponseCode > 0)
    {
        Serial.print("HTTP Response code: ");
        Serial.println(httpResponseCode);
        payload = http.getString();
    }
    else
    {
        Serial.print("Error code: ");
        Serial.println(httpResponseCode);
    }
    // Free resources
    http.end();

    return payload;
}

void notify_authorized(){
            WiFiClientSecure *client = new WiFiClientSecure;
            client->setInsecure(); // skip verification
            HTTPClient https;
            WiFiClient client2;
            HTTPClient http;
            Serial.println("Authorized access");
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

                        // file found at server
                        // file found at server
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
                if (WiFi.status() == WL_CONNECTED)
                {
                    HTTPClient client;
                    client.begin("https://192.168.199.39:3000/user/accessdetails");
                    client.addHeader("Content-Type", "application/json");

                    const size_t CAPACITY = JSON_OBJECT_SIZE(1);
                    StaticJsonDocument<CAPACITY> doc;

                    JsonObject object = doc.to<JsonObject>();
                    object["name"] = "Dananjaya";
                    object["houseid"] = "HN101";
                    object["date"] = day();
                    Serial.println(object);

                    serializeJson(doc, jsonOutput);
                    int httpCode = client.POST(String(jsonOutput));

                    if (httpCode > 0)
                    {
                        String payload = client.getString();
                        Serial.println("\nStatuscode: " + String(httpCode));
                        Serial.println(payload);
                        client.end();
                    }
                    else
                    {
                        Serial.println("Error on HTTP request");
                    }
                }
                else
                {
                    Serial.println("Connection lost");
                }
}

void notify_unauthorized(){
              WiFiClientSecure *client = new WiFiClientSecure;
            client->setInsecure(); // skip verification
            HTTPClient https;
            WiFiClient client2;
            HTTPClient http;
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

                        // file found at server
                        // file found at server
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
            }

// Not sure if WiFiClientSecure checks the validity date of the certificate.
// Setting clock just to be sure...
void setClock()
{
    configTime(0, 0, "pool.ntp.org", "time.nist.gov");

    Serial.print(F("Waiting for NTP time sync: "));
    time_t nowSecs = time(nullptr);
    while (nowSecs < 8 * 3600 * 2)
    {
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

void setup()
{
    WRITE_PERI_REG(RTC_CNTL_BROWN_OUT_REG, 0);
    Serial.begin(9600); // Initiate a serial communication
    Serial.println();
    Serial.println();
    Serial.println();
    input_password.reserve(32);
    pinMode(2,OUTPUT);
    lcd.init();
    // turn on LCD backlight                      
    lcd.backlight();

    WiFi.mode(WIFI_STA);
    WiFiMulti.addAP("OPPO", "1343149nd");
    // wait for WiFi connection
    Serial.print("Waiting for WiFi to connect...");
    while ((WiFiMulti.run() != WL_CONNECTED))
    {
        Serial.print(".");
    }
    Serial.println(" connected");

    setClock();
    SPI.begin();        // Initiate  SPI bus
    mfrc522.PCD_Init(); // Initiate MFRC522
    Serial.println("Approximate your card to the reader...");
    Serial.println();
    lcd.setCursor(0, 0);
    // print message
    lcd.print("SAFENET");
}
void loop()
{
    digitalWrite(2, HIGH);
    char key = keypad.getKey();

    if (key)
    {
        Serial.println(key);

        if (key == '*')
        {
            delay(1000);
            WiFiClientSecure *client = new WiFiClientSecure;
            client->setInsecure(); // skip verification
            HTTPClient https;
            WiFiClient client2;
            HTTPClient http;

            // Look for new cards
            if (!mfrc522.PICC_IsNewCardPresent())
            {
                return;
            }
            // Select one of the cards
            if (!mfrc522.PICC_ReadCardSerial())
            {
                return;
            }
            // Show UID on serial monitor
            Serial.print("UID tag :");
            String content = "";
            byte letter;
            for (byte i = 0; i < mfrc522.uid.size; i++)
            {
                Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
                Serial.print(mfrc522.uid.uidByte[i], HEX);
                content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
                content.concat(String(mfrc522.uid.uidByte[i], HEX));
            }
            Serial.println();
            Serial.print("Message : ");
            content.toUpperCase();
            if (content.substring(1) == "5B 58 7D 00") // change here the UID of the card/cards that you want to give access
            {
              lcd.clear();
                lcd.setCursor(0, 0);
                // print message
                lcd.print("Authorized Access!");
                digitalWrite(2, LOW);  // turn the LED on (HIGH is the voltage level)
                delay(5000);                      // wait for a second
                digitalWrite(2, HIGH);

                Serial.println("Authorized access by Dananjaya");
                Serial.println();
                delay(1000);
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

                        // file found at server
                        // file found at server
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
                if (WiFi.status() == WL_CONNECTED)
                {
                    HTTPClient client;
                    client.begin("https://192.168.199.39:3000/user/accesshousedetails");
                    client.addHeader("Content-Type", "application/json");

                    const size_t CAPACITY = JSON_OBJECT_SIZE(1);
                    StaticJsonDocument<CAPACITY> doc;

                    JsonObject object = doc.to<JsonObject>();
                    object["name"] = "Dananjaya";
                    object["houseid"] = "HN101";

                    serializeJson(doc, jsonOutput);
                    int httpCode = client.POST(String(jsonOutput));

                    if (httpCode > 0)
                    {
                        String payload = client.getString();
                        Serial.println("\nStatuscode: " + String(httpCode));
                        Serial.println(payload);
                        client.end();
                    }
                    else
                    {
                        Serial.println("Error on HTTP request");
                    }
                }
                else
                {
                    Serial.println("Connection lost");
                }
                lcd.clear();
            }

            else
            {
                lcd.setCursor(0, 0);
                // print message
                lcd.print("Acess Denied!");
                Serial.println("Access denied");
                delay(1000);
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

                        // file found at server
                        // file found at server
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
            }
        }
        else if (key == '#')
        {
            if (password == input_password)
            {
                              // DO YOUR WORK HERE
              lcd.clear();
              lcd.setCursor(0, 0);
              // print message
              lcd.print("Authorized Access!");// turn the LED off by making the voltage LOW
              Serial.println("The password is correct, ACCESS GRANTED!");
              notify_authorized();
            }
            else
            {
              Serial.println("The password is incorrect, ACCESS DENIED!");
              notify_unauthorized();
              lcd.clear();
              lcd.setCursor(0, 0);
              // print message
              lcd.print("Access Denied");
            }

            input_password = ""; // clear input password
        }
        else
        {
            input_password += key; // append new character to input password string
        }
    }
    lcd.clear();
}
