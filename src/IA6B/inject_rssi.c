#define OFFSET_CHANNEL_14 13

unsigned int get_signal_strength();


void inject_rssi (unsigned short *buf) {
    int ss = get_signal_strength(); // ss varies from 0 (full signal) to 100 (worst)

    if(ss == 0xffff)
        buf[OFFSET_CHANNEL_14] = 1000;
    else
        buf[OFFSET_CHANNEL_14] = 1000 + (100 - ss)*10; // scale to channel value [1000; 2000]
}
