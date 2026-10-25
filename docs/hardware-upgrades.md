# Hardware upgrade ideas

The current hardware works. These are optional upgrades for a future PCB v2 or a parts refresh, not open bugs.

## Vehicle

| Part (now) | Issue | Option | Cost of change |
|---|---|---|---|
| L293D motor driver | Old bipolar driver: about 2-3 V drop, 0.6 A continuous per channel (1.2 A peak). TT motors can draw close to 1 A on stall and on the fast reversals in the hit reaction. It works today partly because the drop brings the 2S Li-ion pack (7.4 V nominal) down near the 5 V motor rating. | TB6612FNG or DRV8833 module (MOSFET, small drop, more current). | PCB change. Firmware must cap PWM (about 70 percent) because motors are rated 5 V and would get almost full pack voltage. |
| 2x TSOP1730 IR receivers | Vishay TSOP17xx line is obsolete. Tuned to 30 kHz, while IRremote sends JVC at 38 kHz, so sensitivity and range are lower than they could be. | TSOP38238 or TSOP4838 (38 kHz, active-low output like now). | No PCB change: receivers sit on the gun block and are wired to the PCB. Pinout differs, so rewire: TSOP17xx = GND, VS, OUT; TSOP382xx/TSOP48xx = OUT, GND, VS. Smaller body, so the receiver seat in the gun block changes. |
| IR LED, generic 5 mm 940 nm 60 mW | Beam angle not specified, likely wide. The barrel does most of the beam shaping. | Narrow-angle 940 nm LED, for example Vishay TSAL6100 (+-10 deg). Optional later: collimating lens in the barrel. | No PCB change, same 5 mm package. |
| 74ALS08 (combines the two receiver outputs) | Old ALS logic family, harder to buy. | 74HC08, same DIP-14 pinout. | Drop-in. |
| 2S 18650 pack, no BMS | Only protection is the low-battery LED (7.6 V). No balancing, no cutoff. | 2S BMS board, or protected cells. | Protected cells are longer (about 67-70 mm) and may not fit the Keystone 1049 holder. BMS needs space in the body. |
| Extra capacitors on Nano VIN (ceramic + electrolytic) | Added by hand, not in the Eagle design. | Add them to the schematic in PCB v2. | PCB change. |

## Controller

| Part (now) | Issue | Option | Cost of change |
|---|---|---|---|
| Single 18650, no BMS | Same as the vehicle pack. | Protected cell or a charger/protection module (for example TP4056 with protection). | Space in the case. |

## Keep as is

NRF24L01+ radio, Arduino Nano, 74HC595, 3-digit 7-segment display, TT motors and wheels, swivel caster, SS12D00G4 slide switches, 24 mm arcade buttons.

## Bigger redesign (only if starting over)

An ESP32 board with a built-in radio (ESP-NOW) could replace both the Nano and the NRF24L01+. This means new PCBs and new firmware.

## Software

The vehicle firmware uses the legacy IRremote 2.x API. Moving to IRremote 3.x+ needs code changes (see root CLAUDE.md).
