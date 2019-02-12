/* MCU is STM32F030C6 32K flash and 4K SRAM */

MEMORY {
    FLASH : org = 0x08000000, l = 0x8000
    RAM : org = 0x20000000, l = 0x1000
}

SECTIONS {
    .org_fw : {
        . = . ;
    } >FLASH

    .text 0x08006FB0 : {
        *(.text)
    } > FLASH

    .hook_rssi 0x08004364 : {
        *(.hook_ibus_rssi)
    } >FLASH

    .hook_skip_crc 0x08000E94 : {
        *(.hook_skip_crc)
    } >FLASH


    get_signal_strength = 0x080048C4;
    prepare_ppm_buf = 0x0800447C;
}
