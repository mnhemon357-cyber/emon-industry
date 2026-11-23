#include <stdio.h>
int main(void) {
    float temp_celsius = 36.7;
    int pulse_bpm = 74;
    printf("[EMONTRON C] Temp: %.1f C | Pulse: %d BPM | Status: NORMAL\n", temp_celsius, pulse_bpm);
    return 0;
}
