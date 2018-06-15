.thumb

.section .hook_ibus_rssi, "ax"
    bl hook_ibus_rssi

.text
hook_ibus_rssi:
    @ execute the two instructions we replaced with BL
    ldrh    r1, [r2,#0x1c]
    ldrb    r2, [r0,#1]

    push {r0-r3,lr}
    @ r0 contains the channels buffer
    bl inject_rssi
    pop {r0-r3,pc}
