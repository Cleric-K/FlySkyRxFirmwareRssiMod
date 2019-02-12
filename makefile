DIRS := $(wildcard src/*)
CLEANDIRS := $(addsuffix .clean, $(DIRS))

.PHONY: ${DIRS} ${CLEANDIRS}

all: ${DIRS}

${DIRS}:
	$(MAKE) -C $@ RSSI_CHANNEL=14
	$(MAKE) -C $@ RSSI_CHANNEL=8

clean: ${CLEANDIRS}

${CLEANDIRS}: %.clean:
	$(MAKE) -C $* clean
