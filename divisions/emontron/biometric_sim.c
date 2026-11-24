#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(void) {
    srand((unsigned int)time(NULL));
    double temp_c = 36.4 + ((rand() % 14) / 10.0);
    int spo2 = 96 + (rand() % 4);
    int bpm = 68 + (rand() % 24);
    double batt_v = 3.85 + ((rand() % 30) / 100.0);
    const char *status = (temp_c > 37.5 || spo2 < 95) ? "ALERT" : "NORMAL";
    printf("{\"division\":\"Emontron->MotiorPharma\",\"temp_c\":%.1f,\"spo2\":%d,\"bpm\":%d,\"battery_v\":%.2f,\"status\":\"%s\"}\n",
           temp_c, spo2, bpm, batt_v, status);
    return 0;
}
