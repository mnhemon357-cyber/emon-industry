#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    unsigned int seed = (unsigned int)time(NULL);
    srand(seed);
    double temp_c = 36.5 + (rand() % 18) * 0.1;
    int spo2 = 95 + (rand() % 5);
    int bpm = 68 + (rand() % 28);
    double bus_v = 11.8 + (rand() % 7) * 0.1;

    printf("{\"division\":\"DIV-01 Emontron\",\"node\":\"ESP32-SOV-01\","
           "\"temp_c\":%.1f,\"spo2\":%d,\"bpm\":%d,\"bus_voltage\":%.2f,\"timestamp\":%u}\n",
           temp_c, spo2, bpm, bus_v, seed);
    return 0;
}
