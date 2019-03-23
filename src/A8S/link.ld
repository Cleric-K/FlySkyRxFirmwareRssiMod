/* MCU is STM32F030F4P6 16K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x4000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x08002290 : {
        *(.text)
    } > FLASH

    .rodata : {
        . = ALIGN(4);
        *(.rodata)
    } > FLASH

    .bss 0x20000650 : {
        *(.bss)
    } > RAM
    
    
    
    
    .hook_rssi_in_set_some_state 0x080018BE : {
        *(.hook_rssi_in_set_some_state)
    } >FLASH
    
    .hook_rssi_in_process_rx_frame 0x080015F0 : {
        *(.hook_rssi_in_process_rx_frame)
    } >FLASH
    
    .hook_rssi_in_state_machine 0x08001B36 : {
        *(.hook_rssi_in_state_machine)
    } >FLASH
    
    .hook_measure_noise 0x08001B4A : {
        *(.hook_measure_noise)
    } >FLASH
    
    .hook_measure_signal 0x08000E64 : {
        *(.hook_measure_signal)
    } >FLASH
    
    .hook_calc_rssi_in_main 0x0800209A : {
        *(.hook_calc_rssi_in_main)
    }

    .hook_frame_cycle_in_state_machine_case_6 0x08001924 : {
        *(.hook_frame_cycle_in_state_machine_case_6)
    }
    
    .hook_add_sig_noise_in_get_rx_frame 0x08000E9C : {
        *(.hook_add_sig_noise_in_get_rx_frame)
    }
    
    /* variables */
    main_state = 0x2000005F;
    some_state = 0x2000005E;

    /* functions */
    prepare_ppm_buf = 0x08000B5C;
    next_state_after = 0x08000D6C;
    next_state_after_with_save = 0x08000D7C;
    spi_send = 0x08001D5C;
    spi_send_and_receive = 0x08001CD4;
    __aeabi_idiv = 0x0800031A;
    __aeabi_uidiv = 0x080002FE;
    save_config_to_eeprom2 = 0x08000FEC;
    
}
