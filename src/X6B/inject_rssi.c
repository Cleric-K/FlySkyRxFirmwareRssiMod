unsigned int get_signal_strength();

void inject_rssi (unsigned short *buf) {
    int ss = get_signal_strength(); // ss varies from 0 (full signal) to 100 (worst)

    if(ss == 0xffff)
        buf[13] = 0;
    else
        buf[13] = 1000 + (100 - ss)*10; // scale to channel value 1000; 2000
}