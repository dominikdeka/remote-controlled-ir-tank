// Controller case: base plate under the PCB and the button block on the PCB +Y edge, in
// one piece. Modeled in assembly orientation: origin at the PCB lower-left corner, z = 0
// on the base plate top. Printed on the block front face, so the button holes are round
// and the PCB standoffs and rests can be part of the plate.
// The block is open at the rear: the buttons reach almost to the PCB edge and their
// wires go straight to the PCB. Held in the hand, so the outside is closed and every
// outer edge is rounded; the space under the plate is hollow and opens into the block.

include <../lib/common.scad>
include <../lib/parts.scad>
include <../lib/pcb_controller.scad>

case_size = [100, 90];
// Case bottom below the plate underside, as the block lip on the prototype.
case_lip = 8;
block_above_pcb = 21;
block_wall = 2.4;
edge_r = 2.5;
btn_panel_t = 3;
btn_spacing = 60;
btn_hole_cl = 0.2;
// Plate strip between the buttons, tying the plate to the front panel.
tongue_w = 26;
standoff_d = 7;
joystick = pcb_part(pcb_controller_parts, "U$1");
// [x, y, d]: rests where the PCB bottom has no pads (checked against the .brd). The
// top-right corner has Nano pins, so that rest sits further in. The joystick is
// pressed down to click, so it gets one too.
rests = [[4.5, 4.5, 6], [89, 53.2, 5], [joystick[3], joystick[4], 8]];

block_y0 = pcb_controller_size.y;
block_d = case_size.y - block_y0;
block_z0 = -base_plate_t - case_lip;
block_z1 = pcb_standoff_h + pcb_thickness + block_above_pcb;
block_h = block_z1 - block_z0;
inner_h = block_h - 2 * block_wall;
// The front face edges end in a 45 deg flat on the bed, which widens the flat face.
front_flat_h = block_h - 2 * edge_r + 2 * edge_r * (sqrt(2) - 1);
btn_z = (block_z0 + block_z1) / 2;
btn_x = [for (s = [-1, 1]) case_size.x / 2 + s * btn_spacing / 2];

function controller_case_size() = case_size;
function controller_case_buttons() = [for (x = btn_x) [x, case_size.y, btn_z]];

assert(case_size.x >= pcb_controller_size.x, "case narrower than the PCB");
assert(case_size.x <= bed_size.x && case_size.y <= bed_size.z, "case does not fit the bed");
assert(btn_depth <= block_d, "buttons reach past the block rear into the PCB");
assert(btn_bezel_d <= front_flat_h, "bezel larger than the flat front face");
assert(edge_r >= block_wall, "rounding thinner than the walls leaves sharp wall ends");
assert(btn_nut_d + 2 * clearance <= inner_h, "button nut does not fit the block height");
assert(btn_x[0] - btn_nut_d / 2 >= block_wall + clearance, "button nut hits the block end wall");
assert(tongue_w / 2 + clearance <= btn_spacing / 2 - btn_nut_d / 2, "plate strip hits the button nuts");
echo(block_h = block_h, btn_z = btn_z, inner_h = inner_h, front_flat_h = front_flat_h);

// Box from p0 to p1 with every edge rounded by r. With bed_face, the edges of the +Y face
// end in a 45 deg flat on that face, so they print without support.
module rounded_box(p0, p1, r, bed_face = false) {
    hull() for (x = [p0.x + r, p1.x - r], z = [p0.z + r, p1.z - r]) {
        for (y = [p0.y + r, p1.y - r]) translate([x, y, z]) sphere(r);
        if (bed_face) translate([x, p1.y - eps, z]) rotate([-90, 0, 0]) cylinder(r = r * (sqrt(2) - 1), h = eps);
    }
}

module case_body() {
    difference() {
        union() {
            rounded_box([0, block_y0, block_z0], [case_size.x, case_size.y, block_z1], edge_r, true);
            rounded_box([0, 0, block_z0], [case_size.x, block_y0 + 2 * edge_r, 0], edge_r);
        }
        translate([block_wall, block_y0 - eps, block_z0 + block_wall])
            cube([case_size.x - 2 * block_wall, block_d - btn_panel_t + eps, inner_h]);
        translate([block_wall, block_wall, block_z0 + block_wall])
            cube([case_size.x - 2 * block_wall, block_y0, -base_plate_t - block_z0 - block_wall]);
    }
}

module controller_case() {
    difference() {
        union() {
            case_body();
            translate([(case_size.x - tongue_w) / 2, block_y0, -base_plate_t])
                cube([tongue_w, block_d - eps, base_plate_t]);
            // Started below z = 0 to merge with the rounded plate edge.
            for (h = pcb_controller_holes) translate([h[1], h[2], -1]) cylinder(d = standoff_d, h = pcb_standoff_h + 1);
            for (r = rests) translate([r.x, r.y, -1]) cylinder(d = r.z, h = pcb_standoff_h + 1);
        }
        for (h = pcb_controller_holes) translate([h[1], h[2], 0]) {
            // Teardrop tip points -Y, which is up when printed on the block front face.
            translate([0, 0, -base_plate_t]) rotate([90, 0, 0]) teardrop(m25_d, base_plate_t + pcb_standoff_h);
            // Open down through the case bottom, so the nut goes in from below.
            translate([0, 0, block_z0]) nut_trap(m25_nut_af, -block_z0 - base_plate_t + m25_nut_h + clearance);
        }
        for (b = controller_case_buttons())
            translate(b - [0, btn_panel_t, 0]) rotate([-90, 0, 0]) hole(btn_hole_d, btn_panel_t, btn_hole_cl);
    }
}

translate([0, 0, case_size.y]) rotate([-90, 0, 0]) controller_case();
