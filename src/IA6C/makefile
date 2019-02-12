PREFIX = arm-none-eabi-
CC := ${PREFIX}gcc
LD := ${PREFIX}ld
OBJCOPY := ${PREFIX}objcopy
FLAGS = -mthumb -mcpu=cortex-m0

RSSI_CHANNEL ?= 14

# get device name from directory name
DEVICE := $(lastword $(subst /, ,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))
FW_ORIG := ${DEVICE}_orig.bin
FW_RSSI_ELF := ${DEVICE}_rssi_ch${RSSI_CHANNEL}.elf
FW_RSSI_BIN := ../../build/${DEVICE}_rssi_ch${RSSI_CHANNEL}.bin

OBJECTS := hooks.o inject_rssi_ch${RSSI_CHANNEL}.o


${FW_RSSI_BIN}: link.ld ${OBJECTS}
	${LD} -T link.ld ${OBJECTS} -o ${FW_RSSI_ELF}
	${OBJCOPY} ${FW_RSSI_ELF} --update-section .org_fw=${FW_ORIG} --set-section-flags .org_fw=alloc
	${OBJCOPY} -O binary ${FW_RSSI_ELF} ${FW_RSSI_BIN}

%.o: %.s
	${CC} ${FLAGS} -c $<

inject_rssi_ch${RSSI_CHANNEL}.o: inject_rssi.c
	${CC} ${FLAGS} -D RSSI_CHANNEL=${RSSI_CHANNEL} -c -Os -o $@ $<

clean:
	rm -f *.o *.elf ../../build/${DEVICE}_*.bin
