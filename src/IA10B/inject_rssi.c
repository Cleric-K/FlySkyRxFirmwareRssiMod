
unsigned int get_signal_strength();
unsigned int prepare_ppm_buf(unsigned short*);


/*
    RSSI injection is achieved inside a function which processes the newly received
    channel data (or failsafe values). It also calls another function
    which I call `prepare_ppm_buf()` and which has to do with PPM stuff.
    We replace that call with our `inject_rssi()` which patches a
    channel with rssi data. Then we continue to call the original ppm funciton.
*/
int inject_rssi (unsigned short *buf) {
    int ss = get_signal_strength(); // ss varies from 0 (full signal) to 100 (worst)

    if(ss == 0xffff)
        buf[RSSI_CHANNEL - 1] = 1000;
    else
        buf[RSSI_CHANNEL - 1] = 1000 + (100 - ss)*10; // scale to channel value [1000; 2000]*/

    return prepare_ppm_buf(buf);
}
