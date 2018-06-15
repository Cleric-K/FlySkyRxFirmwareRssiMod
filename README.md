# RSSI support for IA6B and X6B FlySky receivers

These receivers have knowledge of RSSI (as it can be seen from the telemetry values
at the transmitter side) but they do not make it available to the Flight
Controller.

This modification injects the Signal Strength value into channel 14 of the
IBUS frame.

## Signal Strength

The receivers have knowledge of RSSI and Noise levels. The difference between the two is the
Signal-To-Noise ratio (SNR). Additionally, on the telemetry screen at the TX side we can see that there is as SigS value
which varies from 0 to 10 (10 being best signal). This is the value that is used in this mod. It is mapped to the standard
channel range [1000; 2000], thus it can be easily used in BetaFlight/iNav.

> In code the value actually varies between 100 (for worst signal) and 0 (best) - it seems it is flipped, divided by 10 and rounded at the TX side.


## How to use

You can either build the images yourself or use the prebuilt ones in the [build](build) directory.

To flash them you'll need a ST-Link dongle.
Checkout povlhp's repo [FlySkyRxFirmware](https://github.com/povlhp/FlySkyRxFirmware) for detailed
instructions.

**!!!Always backup your existing firmware first!!!**

Also consider replacing the four bytes at offset 0x1C00 (see the above link for details) if you want to avoid rebinding
after flashing.

## Details about Signal Strength calculation
The original firmware reveals how the Signal Strength is calculated. It is based on SNR.
Any value of SNR above 45dB is considered full signal. Values below 7.8dB are considered
lost signal. The values in between are mapped to the percent-like Signal Strength. The mapping is
non-linear. A lookup table in ROM is used. Here is how this mapping looks like in practice:
![snr/sigs](https://user-images.githubusercontent.com/9365881/41402828-037e95ae-6fcc-11e8-939f-167e4dab414b.png)
