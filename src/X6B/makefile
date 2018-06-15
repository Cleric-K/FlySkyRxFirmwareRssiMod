PREFIX=arm-none-eabi-
CC=${PREFIX}gcc
LD=${PREFIX}ld
OBJCOPY=${PREFIX}objcopy
FLAGS=-mthumb -mcpu=cortex-m0

DEVICE=X6B
FW_ORIG=${DEVICE}_orig.bin
FW_RSSI_ELF=${DEVICE}_rssi.elf
FW_RSSI_BIN=../../build/${DEVICE}_rssi.bin

OBJECTS=hook_ibus_rssi.o inject_rssi.o hook_skip_crc.o



all: ${FW_RSSI_BIN}

${FW_RSSI_BIN}: link.ld ${OBJECTS}
	${LD} -T link.ld ${OBJECTS} -o ${FW_RSSI_ELF}
	${OBJCOPY} ${FW_RSSI_ELF} --update-section .org_fw=${FW_ORIG} --set-section-flags .org_fw=alloc
	${OBJCOPY} -O binary ${FW_RSSI_ELF} ${FW_RSSI_BIN}

%.o: %.s
	${CC} ${FLAGS} -c $<

%.o: %.c
	${CC} ${FLAGS} -c -Os $<

clean:
	rm -f ${OBJECTS} ${FW_RSSI_ELF} ${FW_RSSI_BIN}
