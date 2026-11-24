// EMONTRON: MAX30102 Biometric Sensor Reader (ESP32)
// Compile with ESP-IDF or Arduino IDE
#include <stdio.h>
#include <stdint.h>
#include <unistd.h>

typedef struct {
    int bpm;
    float spo2;
    float temp;
} Biometrics;

Biometrics read_sensor() {
    Biometrics data;
    // In real hardware, this interfaces with I2C (MAX30102)
    // Simulating realistic values for demonstration
    data.bpm = 70 + (rand() % 15);
    data.spo2 = 96.0 + ((rand() % 30) / 10.0);
    data.temp = 36.5 + ((rand() % 10) / 10.0);
    return data;
}

int main() {
    printf("[EMONTRON] Initializing MAX30102...\n");
    sleep(1);
    printf("[EMONTRON] Sensor Online. Streaming to FHIR server...\n");
    
    for(int i=0; i<3; i++) {
        Biometrics b = read_sensor();
        printf("-> BPM: %d | SpO2: %.1f%% | Temp: %.1f C\n", b.bpm, b.spo2, b.temp);
        sleep(1);
    }
    
    printf("[EMONTRON] Stream paused.\n");
    return 0;
}
