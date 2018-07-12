.thumb

.section .hook_ibus_rssi, "ax"
    bl hook_ibus_rssi

.text
hook_ibus_rssi:
    @ execute the two instructions we replaced with BL
    ldrh r1, [r2,#0x1c]
    ldrb r2, [r0,#1]

    push {r0-r3,lr}
    @ r4 contains the base buffer structure. First channel is at offset 0x56
    mov r0, r4
    add r0, #0x56
    bl inject_rssi
    pop {r0-r3,pc}
