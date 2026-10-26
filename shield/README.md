# shield

3D-printable bodies for the IR tank and its controller, replacing the wooden prototypes (`docs/photos/prototype.jpg`). They fit the current PCBs and parts without changes.

Status: the fit-test coupons and the vehicle parts (base plate, gun block, barrel, PCB standoffs) are ready to print. The controller case is not designed yet.

## Contents

| Path | What |
|---|---|
| `lib/` | Shared parameters, part sizes, generated PCB data |
| `tools/brd2scad.py` | Extracts PCB outline, holes and part positions from `../eagle/*.brd` |
| `vehicle/barrel.scad` | IR gun barrel with LED seat and rear cap |
| `lib/vehicle_layout.scad` | Vehicle layout: plate size, axle, caster and gun block positions |
| `vehicle/base_plate.scad` | Base plate with the motor walls and the caster spacer |
| `vehicle/pcb_standoff.scad` | PCB standoff sleeves and corner rests |
| `vehicle/gun_block.scad` | Gun block with the wall, barrel bore, TSOP seat and wire channel |
| `vehicle/assembly_preview.scad`, `controller/assembly_preview.scad` | PCB + parts + layout placeholders, for checking, not printable |
| `test/` | Fit-test coupons |
| `docs/measurements.md` | Part sizes with source and status, open checklist |

## Render

Needs OpenSCAD (tested with 2021.01) and Python 3 for `make pcb`.

```
cd shield
make            # STL + PNG into build/
make stl
make png
make pcb        # after changing a .brd file
make clean
```

## Print

Bambu Lab A1 mini, 0.4 mm nozzle, PLA or PETG, 0.2 mm layers, no supports. Each STL is already in print orientation.

Print the coupons first, in this order, and tune `clearance` in `lib/common.scad`:

| Coupon | Checks |
|---|---|
| `test/m25_fit` | M2.5 hole and nut trap clearance (0.1 to 0.4, label = tenths) |
| `test/pcb_standoff` | Standoff height under the PCB, nut trap from below |
| `test/led_seat` | LED seat clearance 0.1 / 0.2 / 0.3 (notches = tenths), rear cap |
| `test/tsop_seat` | Seat for two TSOP1730 glued back to back, legs straight down (set `tsop = tsop38238` for the upgrade) |
| `test/tt_motor_mount` | TT motor holes, shaft and peg positions from the drawing |
| `test/caster_mount` | The computed spacer height (printed on top); drill the caster holes by hand |
| `test/button_hole` | 24 mm button hole, 24.0 / 24.2 / 24.4 |
| `test/barrel_set` | Barrels 40 / 50 / 60 mm, same bore and wall, for hit precision at distance |
| `test/barrel_fit` | Barrel fit in the gun block bore, clearance 0.1 / 0.2 / 0.3 (notches = tenths) |

Barrels print muzzle down. Use a brim for the 50 and 60 mm ones.

Vehicle parts, all in print orientation, no supports:

| Part | Notes |
|---|---|
| `vehicle/base_plate` | Top face on the bed (the motor walls and the caster spacer grow up). Print `test/tt_motor_mount`, `test/m25_fit` and `test/caster_mount` first |
| `vehicle/pcb_standoff` | 3 sleeves and 3 rests (2 mm, one spare each); rests peg up |
| `vehicle/gun_block` | On the wall rear face, no brim. Set `barrel_fit_cl` in `vehicle/gun_block.scad` from `test/barrel_fit` first |
| `vehicle/barrel` | Muzzle down, with a brim |

## Components

Upgrade options are listed in [`../docs/hardware-upgrades.md`](../docs/hardware-upgrades.md). Sizes are in [`docs/measurements.md`](docs/measurements.md).

### Vehicle

| Part | Value / model | Source | Notes |
|---|---|---|---|
| Arduino Nano | Nano | Eagle `U$1` (NANO) | Two extra caps on VIN, keep clearance |
| Radio | NRF24L01+ module | Eagle `NRF24L` | Hangs 19.3 mm past the PCB front edge |
| Motor driver | L293D | Eagle `IC3` (DIL16) | |
| Shift register | 74HC595N | Eagle `IC2` (DIL16) | Drives the display |
| AND gate | 74ALS08N | Eagle `IC1` (DIL14) | Combines the two receiver outputs |
| Display | 3-digit 7-segment BA56-12EWA | Eagle `7SEG` | Hit counter |
| Buzzer | F/CM12P | Eagle `SG1` | |
| Battery holder | Keystone 1049, dual 18650 | Eagle `B1` | About 20 mm tall, tallest part on the PCB |
| Low battery LED | 5 mm LED | Eagle `BATTERY` | |
| Capacitor | 22 uF | Eagle `C1` | |
| Resistors | 180 (x3), 30K (x2), 160 (x2), 100 | Eagle `R1`-`R8` | |
| Pin header | 4-pin | Eagle `SV1` (MA04-1) | |
| Power switch | SS12D00G4 | Eagle `S1` (footprint TL3XPO) | Must stay reachable |
| IR LED connection | - | Eagle `IR` (LED5MM footprint) | Wire point only, LED sits in the barrel |
| IR receiver connections | - | Eagle `TSOP1`, `TSOP2` | Wire points only, receivers sit on the gun block |
| Mounting holes | 2x 2.8 | Eagle `H1`, `H2` | M2.5 |
| Cells | 2x 18650 | measure | No BMS |
| Drive motors + wheels | 2x TT motor 5 V 48:1, wheel 65 x 26 | [Botland 3696](https://botland.com.pl/silniki-dc-katowe-z-przekladnia/3696-kolo-silnik-65x26mm-5v-z-przekladnia-48-1-5903351248129.html) | Mount through the side of the body |
| Caster | Swivel caster, 25 mm wheel, 35 mm tall | [Botland 7292](https://botland.com.pl/kola-z-oponami/7292-obrotowe-kolko-do-podwozia-robota-5904422301194.html) | 4x 5 mm holes, 28 x 23 |
| IR LED (gun) | Generic 5 mm, 940 nm, 60 mW | measure | In the barrel |
| IR receivers | 2x TSOP1730 | Vishay datasheet 82030 | Glued back to back on top of the gun block, one forward, one backward |
| Extra VIN capacitors | Ceramic + electrolytic | measure | Soldered to the Nano VIN, not in Eagle |
| Screws | M2.5 + nuts (PCB, motors, gun block), short self-tapping screws in drilled holes (caster) | measure | Lengths in the measurements checklist |

### Controller

| Part | Value / model | Source | Notes |
|---|---|---|---|
| Arduino Nano | Nano | Eagle `U$2` (NANO) | |
| Radio | NRF24L01+ module | Eagle `NRF24L` | |
| Joystick | 2-axis + button | Eagle `U$1` (JOYSTICK-2AXIS-BUTTON) | Cap top 32 mm above the PCB |
| Step-up converter | DC-DC 5 V module | Eagle `U$3` | |
| Battery holder | Single 18650 | Eagle `B1` | |
| Low battery LED | 5 mm LED | Eagle `BATTERY` | |
| Capacitor | 22 uF | Eagle `C1` | |
| Resistors | 10k (x2), 160 | Eagle `R1`, `R2`, `R6` | |
| Pin header | 4-pin | Eagle `SV1` (MA04-1) | |
| Power switch | SS12D00G4 | Eagle `S1` (footprint TL3XPO) | At the PCB edge, must stay reachable |
| Mounting holes | 2x 2.8 | Eagle `H1`, `H2` | M2.5 |
| Cell | 1x 18650 | measure | No BMS |
| Buttons A and B | 2x 24 mm arcade button with micro switch | measure | Front face, wired to the PCB |
| Screws | M2.5 + nuts | measure | |
