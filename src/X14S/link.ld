/* MCU is STM32F030F4P6 16K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x4000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x08002E20 : {
        *(.text)
    } > FLASH

    .rodata : {
        . = ALIGN(4);
        *(.rodata)
    } > FLASH

    .bss 0x20000800 : {
        *(.bss)
    } > RAM
    
    
    
    
    .hook_rssi_in_set_some_state 0x080020C2 : {
        *(.hook_rssi_in_set_some_state)
    } >FLASH
    
    .hook_rssi_in_process_rx_frame 0x08001DA8 : {
        *(.hook_rssi_in_process_rx_frame)
    } >FLASH
    
    .hook_rssi_in_state_machine 0x0800238E : {
        *(.hook_rssi_in_state_machine)
    } >FLASH
    
    .hook_measure_noise 0x080023A2 : {
        *(.hook_measure_noise)
    } >FLASH
    
    .hook_measure_signal 0x0800151C : {
        *(.hook_measure_signal)
    } >FLASH
    
    .hook_calc_rssi_in_main 0x08002C0C : {
        *(.hook_calc_rssi_in_main)
    }

    .hook_frame_cycle_in_state_machine_case_6 0x0800217C : {
        *(.hook_frame_cycle_in_state_machine_case_6)
    }
    
    .hook_add_sig_noise_in_get_rx_frame 0x08001554 : {
        *(.hook_add_sig_noise_in_get_rx_frame)
    }
    
    /* variables */
    main_state = 0x20000127;
    some_state = 0x20000126;

    /* functions */
    prepare_ppm_buf = 0x08001094;
    next_state_after = 0x080013D8;
    next_state_after_with_save = 0x080013EC;
    spi_send = 0x0800261C;
    spi_send_and_receive = 0x0800256C;
    __aeabi_idiv = 0x080002FE;
    __aeabi_uidiv = 0x080002E2;
    save_config_to_eeprom2 = 0x080028C0;
    
}
