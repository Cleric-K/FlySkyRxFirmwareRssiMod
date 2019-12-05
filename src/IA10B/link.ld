/* MCU is STM32F030C6 32K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x8000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x080065C0 : {
        *(.text)
    } > FLASH

    .hook_rssi 0x0800392A : {
        *(.hook_rssi)
    } >FLASH

    .hook_skip_crc 0x08000ED6 : {
        *(.hook_skip_crc)
    } >FLASH


    get_signal_strength = 0x0800417C;
    prepare_ppm_buf = 0x08003A28;
}
