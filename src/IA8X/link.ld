/* MCU is STM32F030C6 32K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x8000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x08006700 : {
        *(.text)
    } > FLASH

    .hook_rssi 0x08003AE0 : {
        *(.hook_rssi)
    } >FLASH

    .hook_skip_crc 0x080010B8 : {
        *(.hook_skip_crc)
    } >FLASH


    get_signal_strength = 0x08004030;
    prepare_ppm_buf = 0x08003BE4;
}
