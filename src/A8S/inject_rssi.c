
/**
 * Implementation of RSSI reading from the A7105 chip
 * 
 * This code is implemented as closely as possible to the FlySky code found in the
 * receivers which support telemetry and RSSI.
 * 
 * The A8S and 8A receivers seem to use a stripped down version of the firmware
 * used by the larger receivers. The state machines are pretty much the sames,
 * except they are missing most of the code - but the states (cases in switch statement)
 * themselves are still there. This makes it quite easy to reimplement the SPI commands
 * for reading RSSI in the same states as the larger receivers.
 */
unsigned int prepare_ppm_buf(unsigned short*, int flag);
void spi_send(char *buf, int count);
void spi_send_and_receive(char cmd, char *buf, int count);
void next_state_after(int time);
void next_state_after_with_save(int time);
void save_config_to_eeprom2();

extern unsigned char main_state;
extern unsigned char some_state;


#define SLOTS 16

static unsigned char last_signal;
static unsigned char last_noise;

static unsigned short signal;
static unsigned short noise;
static unsigned short snr;
static unsigned short num_total_samples;

static unsigned short num_samples;
static unsigned int sum_signal;
static unsigned int sum_noise;

static volatile char rssi_lock;

static unsigned char frame_cycles;

static unsigned char slot_index;
static unsigned char sample_count_arr[SLOTS];
static unsigned char signal_arr[SLOTS];
static unsigned char noise_arr[SLOTS];

/**
 * This is the nonlinearmapping between SNR and Signal Strength.
 * Taken from FlySky receivers' code
 */
static const unsigned char sigstrength_lookup[] = {
    98, 96, 94, 92, 89, 87, 85, 83, 81, 80, 78, 76, 74, 72, 71,
    69, 67, 66, 64, 63, 61, 60, 59, 57, 56, 55, 53, 52, 51, 50,
    49, 47, 46, 45, 44, 43, 42, 41, 40, 39, 38, 37, 36, 36, 35,
    34, 33, 32, 32, 31, 30, 29, 29, 28, 27, 27, 26, 25, 25, 24,
    24, 23, 23, 22, 21, 21, 20, 20, 19, 19, 18, 18, 18, 17, 17,
    16, 16, 16, 15, 15, 14, 14, 14, 13, 13, 13, 12, 12, 12, 11,
    11, 11, 11, 10, 10, 10, 10, 9, 9, 9, 9, 8, 8, 8, 8, 7, 7, 7,
    7, 7, 7, 6, 6, 6, 6, 6, 6, 5, 5, 5, 5, 5, 5, 4, 4, 4, 4, 4,
    4, 4, 4, 4, 3, 3, 3, 3, 3, 3, 3, 3, 3, 2, 2, 2, 2, 2, 2, 2,
    2, 2, 2, 2, 2, 2, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
    1, 1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0 };

/**
 * Converts A7105 RSSI ADC value to dbM
 */
char rawToDbm(char val) {
    val = 20 * (val - 107) / 60 + 90;
    
    if ( val < 60 ) {
        val = 60;
    }
    else if ( val > 120 ) {
        val = 120;
    }
    return val;
}

/**
 * This is called from the function which receives a frame from
 * the A7105. The function itself is called by interrupt on EXTI
 * (signalled by A7105).
 */
void measure_signal(char* buf, int count) {
    unsigned char adc;
    
    // read ADC
    spi_send_and_receive(0x5D, &adc, 1);
    last_signal = rawToDbm(adc);
    
    // call replaced function (RX FIFO reset)
    spi_send(buf, count);
}


/**
 * This is called from the main state machine (state 4)
 */
void measure_noise(int arg) {
    unsigned char adc;

    spi_send_and_receive(0x5D, &adc, 1);
    last_noise = rawToDbm(adc);

    // call replaced function
    next_state_after(arg);
}


/**
 * Called from the main loop all the time.
 * 
 * RSSI measurement works by having 16 slots which implement a moving average.
 * After 32 frames have been read, the current averate signal and noise are saved in
 * a slot.
 */
int calc_rssi() {
    unsigned int total_samples = 0,
                    total_signal_sum = 0,
                    total_noise_sum = 0;

    // call replaced function
    save_config_to_eeprom2();
    
    if (some_state == 1) {
        if ( !main_state || main_state == 1 || main_state == 2 ) {
            rssi_lock = 1;

            if (frame_cycles >= 32) {
                if (slot_index >= SLOTS)
                    slot_index = 0;

                if (num_samples) {
                    signal_arr[slot_index] = sum_signal / num_samples;
                    noise_arr[slot_index] = sum_noise / num_samples;
                    sample_count_arr[slot_index] = num_samples;
                }
                else {
                    signal_arr[slot_index] = 255;
                }

                num_samples = 0;
                frame_cycles = 0;
                sum_signal = 0;
                sum_noise = 0;
                slot_index++;

                for (int i = 0; i < SLOTS; i++) {
                    if (signal_arr[i] != 255) {
                        int count = sample_count_arr[i];
                        total_samples += count;
                        total_signal_sum += signal_arr[i] * count;
                        total_noise_sum += noise_arr[i] * count;
                    }
                }

                if (total_samples) {
                    signal = 10 * total_signal_sum / total_samples;
                    noise = 10 * total_noise_sum / total_samples;
                    if (noise < signal)
                        snr = 0;
                    else
                        snr = noise - signal;
                    num_total_samples = total_samples;
                }
                else {
                    snr = 0xffff;
                }
            }

            rssi_lock = 0;
        }
    }
}

/**
 * Called from the main state machine (state 6 - the last state of the frame receive cycle)
 * We could not wrap the BL called in the state machine, because it is shared by several
 * switch cases. So we replace two instructions (setting the mainstate and loading 150 in R0)
 */
int increment_frame_cycles(int time) {
    main_state = 0; // replaced instruction

    if ( some_state == 1 ) {
        if ( !rssi_lock)
            frame_cycles++;
    }

    return 150; // replaced instruction
}

/**
 * Called by the same function which calls measure_signal()
 * but after the frame has been read and processed.
 *
 * It accumulates signal and noise values
 */
void add_sig_noise(int time) {
    if ( some_state == 1 && rssi_lock == 0) {
        sum_signal += last_signal;
        sum_noise += last_noise;
        num_samples++;
    }

    next_state_after_with_save(time);
}


/**
 * Get Signal Strength by looking up SNR in the table.
 * In this table 0% is best signal, 100% is worst.
 */
unsigned short get_signal_strength() {
    unsigned short sigstr = 0xffff;

    if (snr != 0xFFFF) {
        sigstr = snr;

        if (sigstr > 450) {
            sigstr = 450;
        }
        else if (sigstr < 78) {
            sigstr = 78;
        }
        sigstr = sigstrength_lookup[(sigstr - 78)/2];

        // Flysky make some sanity checks here
        if ( sigstr >= 70 || num_total_samples >= 32 ) {
            if ( sigstr < 60 && num_total_samples < 64 )
                // rssi is better than 60 (40% displayed), but less than 64 frames
                // are recieved so the higher rssi is misleading.
                sigstr = 60;
        }
        else {
            // rssi is better than 70 (30% displayed), but less than 32 frames
            // are recieved so the higher rssi is misleading.
            sigstr = 70;
        }
    }

    return sigstr;
}


/*
    RSSI injection is achieved inside a function which processes the newly received
    channel data (or failsafe values). It also calls another function
    which I call `prepare_ppm_buf()` and which has to do with PPM stuff.
    We replace that call with our `inject_rssi()` which patches a
    channel with rssi data. Then we continue to call the original ppm funciton.
*/
int inject_rssi (unsigned short *buf, int flag) {
    int ss = get_signal_strength(); // ss varies from 0 (full signal) to 100 (worst)

    if (ss == 0xffff)
        buf[RSSI_CHANNEL - 1] = 1000;
    else
        buf[RSSI_CHANNEL - 1] = 1000 + (100 - ss)*10; // scale to channel value [1000; 2000]

    
    // call replaced function
    return prepare_ppm_buf(buf, flag);
}
