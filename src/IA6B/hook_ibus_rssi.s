.thumb

.section .hook_ibus_rssi, "ax"
    bl hook_ibus_rssi

.text
hook_ibus_rssi:
    @ execute the two instructions we replaced with BL
    ldrh r0, [r1,#0x1c]
    ldrb r1, [r4,#1]

    push {r0-r3,lr}
    @ r4 contains the channels buffer
    mov r0, r4
    bl inject_rssi
    pop {r0-r3,pc}
