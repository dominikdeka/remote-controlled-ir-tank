# Measurements

Sizes of the off-the-shelf parts used by the bodies. Units mm.
`lib/parts.scad` and `lib/common.scad` copy these values; change both together.
PCB outline, holes and part positions are not here: they come from `eagle/*.brd` through `make pcb` (see `lib/pcb_*.scad`).

Source tags:
- **measured**: your measurement on the real part or the prototype.
- **brd**: extracted from the Eagle board file.
- **datasheet**: manufacturer datasheet.
- **drawing**: dimension drawing, not from the manufacturer.
- **nominal**: shop page or standard size.
- **guess**: estimate. Measure it before you rely on it.

Status: values tagged drawing, nominal or guess are **unverified** until a test print or caliper check confirms them. Change the tag to `measured` or `verified by print` when they are confirmed.

## Boards and plates

| Value | mm | Source | Status |
|---|---|---|---|
| PCB thickness | 1.6 | measured | ok |
| Base plate thickness (prototype, start value) | 3 | measured | ok |
| Vehicle PCB outline | 98.73 x 99.56 | brd | ok |
| Controller PCB outline | 100 x 55.87 | brd | ok |
| Mounting holes, both boards | 2x 2.8 drill | brd | ok |
| Standoff under PCB (leads + solder) | 2 | decided (vehicle PCB); controller PCB not checked | ok |

## Fasteners

| Value | mm | Source | Status |
|---|---|---|---|
| M2.5 nut across flats / thickness | 5.0 / 2.0 | nominal (ISO 4032) | unverified |
| Start clearance on hole diameters | +0.2 | decision | tune with `test/m25_fit` |

## TT gear motor 48:1 and wheel

Shop: https://botland.com.pl/silniki-dc-katowe-z-przekladnia/3696-kolo-silnik-65x26mm-5v-z-przekladnia-48-1-5903351248129.html
Drawing: `photos/tt_motor_drawing.jpg`, from https://docs.sunfounder.com/projects/sf-components/en/latest/_images/motor_size.jpg

Motor axes: "length" runs from the gearbox end to the motor end (64.4), "width" is across it (22.3), "thickness" runs along the shaft (18.7). Mounted under the plate with the length horizontal and the width vertical.

| Value | mm | Source | Status |
|---|---|---|---|
| Total length (gearbox end to motor end, without tab) | 64.4 | drawing | unverified |
| Gearbox width | 22.3 | drawing | unverified |
| Motor clip width | 22.6 | drawing | unverified |
| Thickness along shaft | 18.7 | drawing | unverified |
| Shaft axis from gearbox end | 11.0 | drawing | unverified |
| Shaft axis across width | centred | drawing (by scale) | unverified |
| Shaft protrusion past body | 9.1 | drawing | unverified |
| Shaft flats | 3.7 | drawing | unverified |
| Shaft boss | 5.5 dia | drawing | unverified |
| Mounting holes | 3x 2.8 dia, through the thickness | drawing | unverified |
| Upper 2 holes: from shaft along length | 20.1 (31.1 - 11.0) | drawing | unverified |
| Upper 2 holes: spacing across width | 17.7 (+-8.85) | drawing, measured by scale | unverified |
| Tab hole: from shaft along length | -13.4 (11.0 + 2.4) | drawing | unverified |
| Tab length past gearbox end | 5.0 | drawing | unverified |
| Tab width | 5.7 | drawing, measured by scale | unverified |
| Round peg on gearbox side: position from shaft | 11.2 along length | drawing, measured by scale | guess |
| Round peg diameter | 4.0 | drawing, measured by scale | guess |
| "7.2" on the side view | unclear (maybe the tab or the 2nd shaft end) | drawing | measure |
| Wheel diameter | 65 | nominal (shop) | unverified |
| Wheel width | 26 | nominal (shop) | unverified |

The shop page notes that the wheels wobble ("figure-eight"). The real ride height may differ from the nominal radius.

## Swivel caster

Shop: https://botland.com.pl/kola-z-oponami/7292-obrotowe-kolko-do-podwozia-robota-5904422301194.html

| Value | mm | Source | Status |
|---|---|---|---|
| Total height | 35 | nominal (shop) | unverified |
| Wheel diameter | 25 | nominal (shop) | unverified |
| Mounting holes | 4x 5 dia (short self-tapping screws into drilled holes) | nominal (shop) | unverified |
| Hole spacing | 28 x 23 | nominal (shop) | unverified |
| Mounting plate size | 38 x 32 | guess | measure |
| Mounting plate thickness | 2 | guess | measure |

## Level base plate (derived)

The base plate is level when the caster reaches the same plate underside height as the rear wheels.

```
plate_underside_h = wheel_d / 2 + tt_top_above_axle + motor_top_gap
                  = 32.5 + 11.3 + 2 = 45.8
caster_spacer_h   = plate_underside_h - caster_h = 45.8 - 35 = 10.8
```

- `tt_top_above_axle` = max(22.3, 22.6) / 2 = 11.3: the shaft is centred in the width, so the motor reaches half its width above the axle.
- `motor_top_gap` = 2 (decided): on the prototype an aluminium angle flange sits between the plate and the motor (`photos/vehicle_bottom.jpg`). It also keeps the top motor nut trap clear of the plate.
- Target: level plate and a barrel parallel to the floor, so the spacer is 10.8 (decided). The prototype spacer looks thicker (about 15 mm), which tilts its plate.
- All inputs are unverified. Recompute after measuring the wheel diameter, motor width and caster height. `test/caster_mount` prints the computed value on its top face.

## IR LED (barrel)

Generic 5 mm IR LED, 940 nm, 60 mW, beam angle unknown.

| Value | mm | Source | Status |
|---|---|---|---|
| Body diameter | 5.0 | nominal | unverified |
| Flange diameter | 5.8 | nominal | unverified |
| Flange thickness | 1.0 | nominal | unverified |
| Height, flange bottom to dome top | 8.6 | nominal | unverified |
| Lead pitch | 2.54 | nominal | ok |

## IR receivers

TSOP1730, Vishay TSOP17.. datasheet, document 82030 rev. 10 (2001), page 6 "Dimensions in mm".

| Value | mm | Source | Status |
|---|---|---|---|
| Body width | 10.0 +-0.3 | datasheet | ok |
| Body height | 12.5 +-0.4 | datasheet | ok |
| Body depth without lens / with lens | 4.0 / 5.8 +-0.3 | datasheet | ok |
| Lens dome radius | 2.75 | datasheet | ok |
| Centre of sensitive area above body bottom | 9.2 | datasheet | ok |
| Total height incl. legs | 30.6 | datasheet | ok |
| Pins (GND, VS, OUT) | 0, 2.54, 7.62 | datasheet | ok |
| Pins from back face | 1.4 | datasheet | ok |

Mounting: two receivers glued back to back (back faces together), as on the prototype. Pair depth with lenses: 2 x 5.8 = 11.6. With the 5 mm seat in `test/tsop_seat`, the lens centre is 4.2 above the block top.

TSOP38238 is an upgrade option only (see `../../docs/hardware-upgrades.md`). It is kept as the `tsop38238` seat parameter.

| Value | mm | Source | Status |
|---|---|---|---|
| Body (w x d x h) | 5.0 x 4.8 x 6.95 | nominal (distributor listing) | unverified |
| Lens centre height, pin offset | 4.5, 1.0 | guess | measure |

## Controller parts

| Value | mm | Source | Status |
|---|---|---|---|
| Joystick cap top above PCB | 32 | measured | ok |
| Joystick cap diameter | 25 | guess | measure |
| Joystick module height above PCB (without stick) | 17 | guess | measure |
| Arcade button panel hole | 24 | nominal | unverified |
| Arcade button bezel diameter | 30 | guess | measure |
| Arcade button height above panel | 10 | guess | measure |
| Arcade button depth behind panel (incl. micro switch) | 33 | guess | measure |
| Arcade button nut outer diameter | 30 | guess | measure |

## Other parts

| Value | mm | Source | Status |
|---|---|---|---|
| 18650 cell | 18.5 dia x 65.2 | nominal | unverified |
| Dual 18650 holder (Keystone 1049), footprint | 77.3 x 40.0 | brd | ok |
| Dual 18650 holder, height above PCB | 20 | measured (about) | ok |
| Single 18650 holder, footprint | 77.3 x 20.1 | brd | ok |
| Single 18650 holder, height above PCB | 20 | guess | measure |
| NRF24L01+ module | 29 x 15.2 | nominal | unverified |
| NRF24L01+ height above PCB (on header) | 13 | guess | measure |
| NRF24L01+ overhang past vehicle PCB front edge | 19.3 | brd | ok |
| Arduino Nano board | 18.5 x 43.2 | nominal | unverified |
| Arduino Nano height above PCB (on header) | 11 | guess | measure |
| SS12D00G4 body | 8.6 x 3.6 x 3.5 | nominal | unverified |
| SS12D00G4 lever length / travel | 4.0 / 2.0 | nominal (C&K SS12D01G4 listing) | unverified |
| SS12D00G4 pin pitch on the PCB | 2.54 | brd (footprint TL3XPO) | ok |
| 7-segment display BA56-12EWA height | 8 | guess | measure |
| Buzzer F/CM12P | 12 dia x 9.5 | guess | measure |
| DIL ICs height (with socket) | 7 | guess | measure |
| DC-DC step-up module height | 7 | guess | measure |
| Gun block height above base plate (prototype) | 40 | measured (about) | ok |
| Barrel axis above base plate (prototype) | 15 | measured (about) | ok |
| Prototype barrel (marker tube) length | 50-60 | measured (about) | ok |

## Prototype reference (photos)

Photos in `photos/`: `prototype.jpg` (both devices), `vehicle_top.jpg`, `vehicle_bottom.jpg`, `vehicle_left.jpg`, `vehicle_right.jpg`, `vehicle_rear.jpg`, `vehicle_motor_mount.jpg`, `controller_front.jpg`, `controller_side.jpg`, `controller_top.jpg`, `controller_top_tape.jpg`.

Values below are estimates from the photos (scaled from the PCB, wheel or joystick). Status for all: photo estimate, measure.

Vehicle:

| Value | Estimate | Source photo |
|---|---|---|
| Base plate length / width | about 165 / 98 | vehicle_top |
| Plate shape | full width under the PCB, then a nose tapering to a flat front | vehicle_top, vehicle_bottom |
| Nose: length / flat front width | about 48 / 33 | vehicle_top |
| Rear axle from the PCB rear edge | about 37 | vehicle_top |
| Overall width over the wheels | about 155 | vehicle_top |
| Motor mount | aluminium angle per motor: flange under the plate, vertical flange inboard of the motor; 2 screws through the holes near the motor end, nuts inboard; tab hole not used | vehicle_bottom, vehicle_motor_mount, vehicle_rear |
| Motor direction | gearbox and shaft at the rear, motor can points forward | vehicle_bottom |
| Gun block (base length x width) | about 40 x 30, on the centre line, in front of the PCB, next to the NRF24 | vehicle_top |
| Gun block front face | leans back, about 15-30 deg from vertical (the "aggressive" look; keep it) | vehicle_left, vehicle_right |
| Caster spacer | wooden block, front face also raked | vehicle_left, vehicle_right |
| LED wires | leave the block through a hole in its side | vehicle_right |
| Receivers | TSOP pair glued back to back on top of the block | vehicle_top, vehicle_left |

Controller:

| Value | Estimate | Source photo |
|---|---|---|
| Button block position | on the PCB +Y edge (opposite the battery holder), confirmed | controller_top |
| Button block (length x depth x height) | about 110 x 34 x 45 | controller_top_tape, controller_front, controller_side |
| Block top above PCB | about 21 | controller_side |
| Block bottom below the base | about 8 | controller_side |
| Base board thickness (wood) | about 13 | controller_side |
| Buttons | centred on the block height, about 60 apart, bezel about 31 | controller_front |

## Open checklist

Measure these before the chassis design depends on them:

- [ ] Wheel outer diameter (decides ride height).
- [ ] TT motor: hole positions, round peg position and size, the "7.2" value. Print `test/tt_motor_mount` and try a real motor.
- [ ] Caster: total height, mounting plate size and thickness.
- [ ] Extra Nano VIN capacitors: values, size, height, position. They are not in Eagle; keep clearance around the Nano.
- [ ] Heights above the PCB: NRF24L01+, Nano, 7-segment, buzzer, ICs, single 18650 holder, joystick module.
- [ ] Standoff height under the controller PCB (2 like the vehicle?).
- [ ] Arcade button: depth behind the panel, nut diameter, max panel thickness.
- [ ] Marker tube outer diameter on the prototype, if the test barrels should fit the wooden block (now `od = 14` in `test/barrel_set.scad`).
- [ ] Wire lengths from the PCB to the gun block (TSOPs, IR LED) and to the controller buttons.
- [ ] Screw lengths: M2.5 for PCB and motors (motor: 18.7 + wall + nut, about M2.5 x 25-30). PCB: M2.5 x 8 (PCB 1.6 + sleeve 2 + plate 3, nut in the plate). Gun block: M2.5 x 6-8 (foot 3 + plate 3, nut in the plate). Caster: short self-tapping screws that fit the 5 mm holes, shorter than spacer + plate (13.8).

## Layout notes from the previews

These come from `vehicle/assembly_preview.scad` and `controller/assembly_preview.scad`. They are inputs for the chassis design, not decisions.

- Vehicle length: max 180 from the plate rear edge to the muzzle tip (decided). The plate is 170 long, so it prints on the 180 bed.
- Vehicle: the NRF24L01+ footprint ends 19.3 mm past the PCB front edge (y 118.8, x 17-32, about 13 mm tall). The gun block starts 1.0 mm in front of it (y 119.8; decided: make the vehicle longer instead of cutting the wall). The footprint box is 29.3 long, the module 29 nominal.
- Gun block (`vehicle/gun_block.scad`): 40 high, 30 wide, 20 long flat top for the TSOP pair, front face raked 30 deg, so 43.1 long at the base (y 119.8-162.9). Printed on the wall rear face, so the barrel bore is round and square to the wall.
- Wall: the rear 4 mm of the gun block, full plate width (100), sides sloping from the block top down to 15 at the plate edges. Over the NRF24 it is 28-39 high (module top about 16.6).
- Barrel: separate part, slid into the block; its rear end (LED, cap) is flush with the wall rear face (y 119.8), so the LED is reachable from behind. With 180 max, a barrel can be at most 60.2 long: the 50 and 60 mm test barrels fit (60: muzzle y 179.8, 25.6 past the block face at axis height). The 70 mm one does not.
- TSOP legs: the pair sits 5 deep (bottom z 35) on two 2 mm ledges. Below is a cavity for the leg joints down to z 23.7 (1.6 above the barrel bore), so legs can be at most 11.3 long (decided: shorten them). The wires run in a 6 x 5 channel to the wall rear face, above the barrel.
- Gun block mounting: 3 mm foot in front of the wall, 4x M2.5 (x +-25 and +-40, 8 in front of the wall rear face), nuts in traps in the base plate bottom. The foot tapers like the plate nose; the nose is 44 long (prototype about 48) so it starts in front of the wall.
- Base plate (`vehicle/base_plate.scad`): one piece with both motor walls (as `test/tt_motor_mount`, 27.3 below the plate) and the caster spacer (10.8, raked front). Printed top face down. Motor wire slots 5 x 10 at y 104-114, in line with each motor, between the PCB front edge and the gun block. About 70 cm3 solid.
- PCB: 2 mm sleeves at the two holes (H1, H2) and 2 mm rests at the two other corners (no solder joints there, checked on the PCB). The rests have a 3 mm peg in a blind hole in the plate.
- Caster (y 142) sits under the gun block. It is held by short self-tapping screws in holes drilled on assembly (decided), so the model has no holes or nut traps there. The spacer front face is raked 30 deg (leans back going down, as on the prototype); its top reaches y 164.2.
- Vehicle: with `motor_top_gap` = 2, the top motor nut trap clears the plate (flat about 1.9 below it). With 0 it touched the plate.
- Controller: case 100 x 90 (decided), so the button block is 34 deep, as on the prototype. It fits the guessed button depth (33).
