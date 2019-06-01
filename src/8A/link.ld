/* MCU is STM32F030F4P6 16K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x4000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x08000BD0 : {
        *(.text)
    } > FLASH

    .rodata : {
        . = ALIGN(4);
        *(.rodata)
    } > FLASH

    .bss 0x200009A0 : {
        *(.bss)
    } > RAM
    
    
    
    
    .hook_rssi_in_set_some_state 0x08002C46 : {
        *(.hook_rssi_in_set_some_state)
    } >FLASH
    
    .hook_rssi_in_process_rx_frame 0x080032E8 : {
        *(.hook_rssi_in_process_rx_frame)
    } >FLASH
    
    .hook_rssi_in_state_machine 0x08003792 : {
        *(.hook_rssi_in_state_machine)
    } >FLASH
    
    .hook_measure_noise 0x080037A6 : {
        *(.hook_measure_noise)
    } >FLASH
    
    .hook_measure_signal 0x08002718 : {
        *(.hook_measure_signal)
    } >FLASH
    
    .hook_calc_rssi_in_main 0x08003B72 : {
        *(.hook_calc_rssi_in_main)
    }

    .hook_frame_cycle_in_state_machine_case_6 0x08003580 : {
        *(.hook_frame_cycle_in_state_machine_case_6)
    }
    
    .hook_add_sig_noise_in_get_rx_frame 0x08002750 : {
        *(.hook_add_sig_noise_in_get_rx_frame)
    }
    
    .hook_disable_checksum 0x080021C6 : {
        *(.hook_disable_checksum)
    }

    /* variables */
    main_state = 0x200000E7;
    some_state = 0x200000E6;

    /* functions */
    prepare_ppm_buf = 0x080023C0;
    next_state_after = 0x080025CC;
    next_state_after_with_save = 0x080025E0;
    spi_send = 0x08002E48;
    spi_send_and_receive = 0x08002D94;
    __aeabi_idiv = 0x0800170E;
    __aeabi_uidiv = 0x080016F2;
    save_config_to_eeprom2 = 0x080028D4;
    
}
