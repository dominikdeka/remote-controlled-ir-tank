// TT motor wall: a piece of base plate with one wall for one motor, the same wall as in
// vehicle/base_plate.scad.
// Print orientation: plate on the bed, wall up. In use it is upside down: the wall hangs
// under the plate and the motor top touches the plate underside (+ motor_top_gap).
// As on the prototype, the wall is inboard of the motor: the motor sits on the +Y face
// (outboard), M2.5 nuts go in traps on the -Y face (inboard).
// Hole, peg and shaft positions are from the drawing and unverified; this print checks them.

include <../lib/common.scad>
include <../lib/parts.scad>
use <../vehicle/base_plate.scad>

wall_t = 4;
margin = 5;
x0 = tt_holes[2][0] - margin;
x1 = tt_holes[0][0] + margin;
plate = [x1 - x0, wall_t + tt_t + 5, base_plate_t];
shaft_z = plate.z + motor_top_gap + tt_top_above_axle;

translate([x0, 0, 0]) cube(plate);
tt_motor_wall();

%translate([0, wall_t + tt_t / 2, shaft_z]) rotate([0, 0, -90]) tt_motor_ghost();
