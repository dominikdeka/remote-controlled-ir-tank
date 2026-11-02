// Vehicle base plate with the TT motor walls and the caster spacer in one piece.
// Modeled in assembly orientation (see lib/vehicle_layout.scad). Printed top face down, so the
// motor walls and the caster spacer grow up from the bed without supports.
// PCB and gun block: M3 screws from the top, nuts in traps in the plate bottom.
// PCB standoffs and rests are separate (pcb_standoff.scad); the rests sit in blind holes.
// Caster: self-tapping screws from below into blind pilot holes in the spacer.

include <../lib/vehicle_layout.scad>
use <gun_block.scad>

motor_wall_t = 4;
// [x, y] size of the motor wire slots, in front of the PCB, in line with each motor.
wire_slot = [5, 10];
wire_slot_y = 104;
// For the 10 mm caster screws (user value).
caster_pilot_d = 2;
caster_pilot_depth = 10;
// A thin ring slit around each pilot hole makes the slicer print walls on both sides of
// it, so the screw bites into solid plastic instead of infill.
caster_slit_r = caster_pilot_d / 2 + 1.6;
caster_slit_w = 0.15;

motor_wall_h = motor_top_gap + tt_w + 3;

// Motor wall in its own frame, the same as test/tt_motor_mount: x along the motor from
// the shaft towards the motor end, wall at y 0..motor_wall_t with the motor on +Y and
// the nuts on -Y, z = 0 on the plate top and growing down into the plate and the wall.
module tt_motor_wall() {
    x0 = tt_holes[2][0] - motor_wall_margin;
    x1 = tt_holes[0][0] + motor_wall_margin;
    shaft_z = base_plate_t + motor_top_gap + tt_top_above_axle;
    difference() {
        translate([x0, 0, 0]) cube([x1 - x0, motor_wall_t, base_plate_t + motor_wall_h]);
        for (h = tt_holes) translate([h[0], 0, shaft_z + h[1]]) {
            teardrop(m3_d, motor_wall_t, m3_cl);
            translate([0, -eps, 0]) rotate([-90, 0, 0]) nut_trap(m3_nut_af, m3_nut_h + clearance, m3_nut_cl);
        }
        translate([0, 0, shaft_z]) teardrop(tt_boss_d + 1.5, motor_wall_t);
        translate([tt_peg[0], 0, shaft_z + tt_peg[1]]) teardrop(tt_peg_d, motor_wall_t);
    }
}

module plate_outline() {
    nose_y = plate_size.y - nose_len;
    polygon([
        [0, 0], [plate_size.x, 0], [plate_size.x, nose_y],
        [(plate_size.x + nose_front_w) / 2, plate_size.y],
        [(plate_size.x - nose_front_w) / 2, plate_size.y], [0, nose_y],
    ]);
}

// As long as the gun block above, so the two read as one nose. Top at z = 0 (plate
// underside), caster face at z = -caster_spacer_h.
caster_spacer_nose = caster_spacer_h * tan(caster_spacer_rake);
module caster_spacer() {
    hull() {
        translate([-caster_plate.x / 2, block_y, -caster_spacer_h]) cube([caster_plate.x, plate_size.y - caster_spacer_nose - block_y, eps]);
        translate([-caster_plate.x / 2, block_y, -eps]) cube([caster_plate.x, plate_size.y - block_y, eps]);
    }
}

function caster_holes() = [for (sx = [-1, 1], sy = [-1, 1])
    [centre_x + sx * caster_hole_spacing.x / 2, caster_y + sy * caster_hole_spacing.y / 2]];

module caster_screw_cut(p) {
    translate([p.x, p.y, -base_plate_t - caster_spacer_h]) {
        hole(caster_pilot_d, caster_pilot_depth, 0);
        difference() {
            hole(2 * caster_slit_r + caster_slit_w, caster_pilot_depth, 0);
            hole(2 * caster_slit_r - caster_slit_w, caster_pilot_depth, eps);
        }
    }
}

module bottom_nut_trap(x, y) {
    translate([x, y, -base_plate_t]) {
        hole(m3_d, base_plate_t, m3_cl);
        nut_trap(m3_nut_af, base_plate_t - nut_roof, m3_nut_cl);
    }
}

module base_plate() {
    difference() {
        union() {
            translate([plate_x0, 0, -base_plate_t]) linear_extrude(base_plate_t) plate_outline();
            for (side = [-1, 1]) {
                inner_x = side < 0 ? plate_x0 + tt_t + motor_wall_t : plate_x0 + plate_size.x - tt_t - motor_wall_t;
                multmatrix([[0, side, 0, inner_x], [1, 0, 0, axle_y], [0, 0, -1, 0]]) tt_motor_wall();
            }
            translate([centre_x, 0, -base_plate_t]) caster_spacer();
        }
        for (h = pcb_vehicle_holes) bottom_nut_trap(h[1], h[2]);
        for (p = pcb_rest_points) translate([p.x, p.y, -pcb_rest_peg[1] - 0.5])
            cylinder(d = pcb_rest_peg[0] + clearance, h = pcb_rest_peg[1] + 0.5 + eps);
        for (p = gun_block_holes()) bottom_nut_trap(centre_x + p.x, block_y + p.y);
        for (p = caster_holes()) caster_screw_cut(p);
        for (x = [plate_x0 + tt_t / 2, plate_x0 + plate_size.x - tt_t / 2])
            translate([x - wire_slot.x / 2, wire_slot_y, -base_plate_t - eps]) cube([wire_slot.x, wire_slot.y, base_plate_t + 2 * eps]);
    }
}

assert(plate_size.x <= bed_size.x && plate_size.y <= bed_size.y, "plate larger than the bed");
assert(gun_block_wall_w() <= plate_size.x, "gun block wall wider than the plate");
assert(plate_size.y - nose_len >= block_y + gun_block_wall_t(), "plate nose cuts under the gun block wall");
assert(caster_y - caster_plate.y / 2 >= block_y, "caster plate overhangs the spacer rear end");
assert(block_y + gun_block_len() <= plate_size.y, "gun block overhangs the plate front");
assert(wire_slot_y > pcb_vehicle_size.y && wire_slot_y + wire_slot.y < block_y, "wire slot not between the PCB and the gun block");
assert(caster_pilot_depth <= caster_spacer_h + base_plate_t - 1, "caster pilot hole breaks through the plate top");
echo(caster_screw_max = caster_plate_t + caster_pilot_depth, caster_slit_d = 2 * caster_slit_r);
echo(plate_underside_h = plate_underside_h, caster_spacer_h = caster_spacer_h, motor_wall_h = motor_wall_h);

rotate([180, 0, 0]) base_plate();
