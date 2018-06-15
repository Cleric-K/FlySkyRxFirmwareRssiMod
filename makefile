all:
	$(MAKE) -C src/IA6B
	$(MAKE) -C src/X6B

clean:
	$(MAKE) -C src/IA6B clean
	$(MAKE) -C src/X6B clean