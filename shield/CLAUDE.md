# shield/ - CAD rules

3D-printable bodies for the vehicle and the controller, in plain OpenSCAD (no BOSL2).

## Hard constraint

- The bodies must fit the existing PCBs, parts and firmware as they are. PCB and firmware changes are out of scope.
- Do not edit `eagle/*` or `arduino/*` from here.
- Optional upgrades live in `../docs/hardware-upgrades.md`. Do not design around them. Where an upgrade changes a part shape (TSOP38238 vs TSOP1730), keep only a seat parameter.

## Layout

- `lib/vehicle_layout.scad`: vehicle layout values (plate, axle, caster, gun block position) shared by the vehicle parts and the preview.
- `lib/common.scad`: print parameters, tolerances, fasteners, helper modules (`hole`, `nut_trap`, `teardrop`, `label`, `pcb_part`).
- `lib/parts.scad`: off-the-shelf part sizes, derived values (`caster_spacer_h`), ghost models, `pcb_ghost`.
- `lib/pcb_vehicle.scad`, `lib/pcb_controller.scad`: **generated** by `tools/brd2scad.py`. Never edit by hand; run `make pcb`.
- `vehicle/`, `controller/`: one part per file. `assembly_preview.scad` files are previews, not printable.
- `test/`: small fit-test coupons, printed before any full body.
- `docs/measurements.md`: every part size with its source and status.

## Source of truth

| Data | Source |
|---|---|
| PCB outline, mounting holes, part positions, footprint boxes | `eagle/*.brd` via `make pcb` |
| Off-the-shelf part sizes, with source and status | `docs/measurements.md` (copied into `lib/parts.scad`; change both together) |
| Print and fastener values | `lib/common.scad` (nut sizes also listed in `docs/measurements.md`) |
| Part heights above the PCB | `pcb_part_heights` in `lib/parts.scad` (guesses, see measurements) |

Values tagged drawing, nominal or guess in `docs/measurements.md` are unverified. Do not treat them as final. Say so when a design depends on one.

## Units and axes

- Units mm.
- Origin: lower-left corner of the PCB outline (Eagle coordinates shifted by `pcb_*_eagle_origin`).
- +X right, +Y front, +Z up. Vehicle front (+Y) = gun side, NRF24 and 7-segment display; rear = 18650 holder and drive wheels.
- z = 0 is the top of the base plate; the PCB bottom sits at `pcb_standoff_h`.
- Body parts are modeled in assembly orientation; the file's top-level call places the part in print orientation. Test coupons are modeled in print orientation directly.
- Each part file defines a module and calls it once at the end. Other files load it with `use <...>`, which skips that call.

## Print constraints

- Bambu Lab A1 mini: bed 180 x 180 x 180, 0.4 mm nozzle, PLA or PETG.
- No supports: flat bottom face, overhangs at 45 deg or less, horizontal holes as `teardrop()`.
- Min wall 1.6 (`wall_min`).
- Holes and press fits: `clearance` (+0.2 on the diameter) until the test prints say otherwise.
- PCB and gun block mounting: M2.5 screws from the top, nuts in hex traps (`nut_trap`) in the base plate bottom. PCB standoffs (sleeves at the holes, pegged rests at the other two corners) are separate parts on the vehicle, because the plate prints top face down; on the controller they are part of the case. No heat-set inserts.
- Caster: short self-tapping screws into holes drilled on assembly; no holes or nut traps in the model (it sits under the gun block).

## Barrel and gun block (top priority)

- The barrel is the most important part. IR may leave only through the muzzle, in a narrow beam.
- Any change to the gun block must keep the barrel coaxial with the LED seat, its axis parallel to the ground and to the vehicle centre line, and the receivers close to barrel height.
- The barrel is a separate part that slides into the gun block from the front and is held by friction (`barrel_fit_cl`). Its rear end (LED, cap) is flush with the wall rear face; the muzzle sticks out of the block front.
- The LED must stay replaceable from the rear, with a wire path to the PCB.
- The two receivers stay glued back to back on top of the block, as on the prototype: one lens forward, one backward. They sink into a pocket to sit lower; their legs go straight down (bending them backward does not work back to back), shortened to stay above the barrel; the wires run in a channel above the barrel and leave through the wall rear face, towards the PCB.
- Bore and length are parameters. Baffles or a muzzle aperture go into `barrel_bore()` in `vehicle/barrel.scad`.
- Many filaments, even black, pass 940 nm IR through thin walls. Fallback (foil/tape outside, metal tube insert) is not designed yet.

## Design intent from the prototype

Photos and estimates: `docs/photos/`, "Prototype reference" in `docs/measurements.md`.

- Vehicle: max 180 long from the plate rear edge to the muzzle tip. Plate level, barrel parallel to the floor (caster spacer from `caster_spacer_h`).
- Gun block: front face leans back (raked, "aggressive" look). Keep it. 40 high, with a flat top long enough for the TSOP pair. Starts just in front of the NRF24.
- Wall: the rear part of the gun block, one piece with it, full plate width, sides sloping down (not a rectangle).
- Caster spacer: front face raked, leaning back going down, as on the prototype.
- Base plate: full width under the PCB, then a nose tapering to a narrow flat front.
- TT motors: gearbox and shaft at the rear, motor can forward. Mount wall inboard of the motor, nuts on the inboard face, screws through the 2 holes near the motor end.
- Controller: case 100 x 90, one piece, printed on the button block front face. Button block on the PCB +Y edge (34 deep, open at the rear), buttons 60 apart on its front face. Block top 21 above the PCB top, case bottom 8 below the plate underside, as on the prototype. Held in the hand: closed underside (hollow, opens into the block), every outer edge rounded (`edge_r`).

## Commands

Run from `shield/`.

```
openscad --version          # check it is installed; if missing, tell the user, do not install it
make                        # all STL + PNG into build/
make stl                    # printable parts only
make png                    # previews of everything
make build/test/m25_fit.stl # one part
make build/vehicle/barrel.png
make pcb                    # regenerate lib/pcb_*.scad after a .brd change
make clean
```

PNG camera and size are set in `CAMERA` in the Makefile. For another view, run openscad directly, e.g.
`openscad --camera=0,0,0,90,0,90,0 --viewall --autocenter --projection=o --imgsize=1400,700 -o side.png vehicle/assembly_preview.scad`.
Previews in `build/` are scratch output; `build/` is gitignored.

## Workflow

1. Change a `.scad` file.
2. Render its PNG (and STL for printable parts). Check the output for `WARNING` or `assert`.
3. Look at the PNG yourself. For fit questions, render extra views (side, top, section) into the scratchpad.
4. Report what changed, what you checked, and which unverified values the change depends on.

Comment sparingly: only for a non-obvious reason or a constraint. Keep parameters at the top of each file.
