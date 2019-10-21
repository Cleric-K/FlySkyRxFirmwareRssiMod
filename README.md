# RSSI support for FlySky receivers

Supported receivers:
* IA6B
* X6B
* IA6C
* X8B
* IA8X
* A8S
* 8A

These receivers (except A8S and 8A) have knowledge of RSSI (as it can be seen from the telemetry values
at the transmitter side) but they do not make it available to the Flight
Controller.

A8S and 8A receivers do not have telemetry in their original firmware. By using the code from the other receivers as reference, it was possible to implement RSSI measurement. Telemetry is not implemented.

This modification injects the Signal Strength value into one of the channels (most commonly channel 14) which is then read by the Flight Controller. All protocols (IBUS, SBUS and PPM) are supported (see below for an important note on PPM).

## Signal Strength

The receivers have knowledge of Signal and Noise levels. The difference between the two is the
Signal-To-Noise ratio (SNR). Additionally, on the telemetry screen at the TX side we can see that there is as SigS value
which varies from 0 to 10 (10 being best signal). This is the value that is used in this mod. It is mapped to the standard
channel range [1000; 2000], thus it can be easily used in BetaFlight/iNav.

> In code the value actually varies between 100 (for worst signal) and 0 (best) - it seems it is flipped, divided by 10 and rounded at the TX side.


## How to use

> Montis has written a detailed flashing guide. You can find it [here](http://www.multirotorguide.com/guide/flysky-receivers-rssi-mod-alternative-firmware/).

You can either build the images yourself or use the prebuilt ones in the [build](build) directory.

The prebuilt images have two versions each - one which injects the Signal Strength into channel 14 and one for channel 8.
> You need the `channel 8` version if you intend to use PPM. The reason for this is that PPM protocol (as implemented by these receivers) has only 8 channels and channel data for channels above 8 is ignored.
> Digital protocols (IBUS and SBUS) can use either version, but it is recommended to use the `channel 14` version, because most transmitters can send only up to 10 channels, thus by using channel 14 you are not wasting one of your usable channels.

To flash the firmware you'll need a ST-Link dongle.
Checkout povlhp's repo [FlySkyRxFirmware](https://github.com/povlhp/FlySkyRxFirmware) for detailed
instructions.

> Note: If you are having problems with flashing, consider connecting also the `RST` (Reset) pad of the receiver to the `RST` pin of the ST-Link.<br/>
> Also it might be better to power up the whole receiver with +5V (you can use the +5V from the ST-Link) instead of supplying just the +3.3V for flashing. `GND` should be connected in all cases. **Never connect +5V to the +3.3V pad of the receiver.**

**!!!Always backup your existing firmware first!!!**

Also consider replacing the four bytes at offset 0x1C00 (see the above link for details) if you want to avoid rebinding
after flashing.

> Note: **DON'T DO THAT** on the **A8S** and **8A** receivers. They store the transmitter ID in EEPROM and it is not affected by flashing - you won't need to rebind. Offset 0x1C00 contains code in these receivers and if you modify it you'll corrupt the firmware.

## Details about Signal Strength calculation
The original firmware reveals how the Signal Strength is calculated. It is based on SNR.
Any value of SNR above 45dB is considered full signal. Values below 7.8dB are considered
lost signal. The values in between are mapped to the percent-like Signal Strength. The mapping is
non-linear. A lookup table in ROM is used. Here is how this mapping looks like in practice:
![snr/sigs](https://user-images.githubusercontent.com/9365881/41402828-037e95ae-6fcc-11e8-939f-167e4dab414b.png)
