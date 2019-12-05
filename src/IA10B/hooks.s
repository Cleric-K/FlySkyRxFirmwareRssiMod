.thumb

.section .hook_skip_crc, "ax"
    nop

.section .hook_rssi, "ax"
    bl inject_rssi
