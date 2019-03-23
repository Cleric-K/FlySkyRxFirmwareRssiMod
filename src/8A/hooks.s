.thumb


.section .hook_rssi_in_set_some_state, "ax"
    bl inject_rssi
    
.section .hook_rssi_in_process_rx_frame, "ax"
    bl inject_rssi
    
.section .hook_rssi_in_state_machine, "ax"
    bl inject_rssi

.section .hook_measure_noise, "ax"
    bl measure_noise

.section .hook_measure_signal, "ax"
    bl measure_signal

.section .hook_calc_rssi_in_main, "ax"
    bl calc_rssi

.section .hook_frame_cycle_in_state_machine_case_6, "ax"
    bl increment_frame_cycles

.section .hook_add_sig_noise_in_get_rx_frame, "ax"
    bl add_sig_noise


