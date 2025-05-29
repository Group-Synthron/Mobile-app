#include <Wire.h>
#include <LiquidCrystal_I2C.h>
#include <TinyGPS++.h>
#include <HX711.h>
#include <SPI.h>
#include <SD.h>

// Initialize LCD (I2C address 0x27, 16 columns, 2 rows)
LiquidCrystal_I2C lcd(0x27, 16, 2);

// GPS setup
TinyGPSPlus gps;
HardwareSerial gpsSerial(1); // Use UART1
#define GPS_RX 20
#define GPS_TX 21

// HX711 setup
#define HX711_DT 2
#define HX711_SCK 3
HX711 scale;

// SD card setup
#define SD_CS 7

// Timing
unsigned long previousMillis = 0;
const long interval = 60000; // 1 minute

void setup() {
  // Initialize Serial for debugging
  Serial.begin(115200);

  // Initialize LCD
  lcd.begin(16, 2);
  lcd.backlight();
  lcd.print("Initializing...");

  // Initialize GPS Serial
gpsSerial.begin(9600, SERIAL_8N1, GPS_RX, GPS_TX);

  // Initialize HX711
  scale.begin(HX711_DT, HX711_SCK);
  scale.set_scale(); // Set your scale factor
  scale.tare();      // Reset the scale to 0

  // Initialize SD card
  if (!SD.begin(SD_CS)) {
    lcd.clear();
    lcd.print("SD init failed!");
    while (1);
  }

  lcd.clear();
  lcd.print("Setup complete");
  delay(2000);
  lcd.clear();
}

void loop() {
  // Read GPS data
  while (gpsSerial.available() > 0) {
    gps.encode(gpsSerial.read());
  }

  // Display GPS data every interval
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) {
    previousMillis = currentMillis;

    if (gps.location.isValid()) {
      float latitude = gps.location.lat();
      float longitude = gps.location.lng();

      // Display on LCD
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("Lat:");
      lcd.print(latitude, 6);
      lcd.setCursor(0, 1);
      lcd.print("Lon:");
      lcd.print(longitude, 6);

      // Save to SD card
      File dataFile = SD.open("gps_data.csv", FILE_APPEND);
      if (dataFile) {
        dataFile.print(latitude, 6);
        dataFile.print(",");
        dataFile.println(longitude, 6);
        dataFile.close();
      } else {
        Serial.println("Error opening gps_data.csv");
      }
    } else {
      lcd.clear();
      lcd.print("GPS not valid");
    }
  }

  // Read weight
  if (scale.is_ready()) {
    float weight = scale.get_units(10);

    // Display weight on LCD
    lcd.setCursor(0, 0);
    lcd.print("Weight:");
    lcd.print(weight, 2);
    lcd.print(" kg");

    // Send weight to Serial (for mobile app)
    Serial.print("Weight: ");
    Serial.print(weight, 2);
    Serial.println(" kg");
  } else {
    lcd.setCursor(0, 0);
    lcd.print("Scale not ready");
  }

  delay(1000);
}
