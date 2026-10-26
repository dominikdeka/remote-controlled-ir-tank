// Off-the-shelf part sizes and simple ghost models for previews. Units mm.
// docs/measurements.md is the source of truth for every value here, with its source
// and status. Change both together. "unverified" values are not final.

// Mounted with the long axis horizontal and the 22.3 width vertical.
// Local frame of tt_motor_ghost(): shaft on the X axis, gearbox end towards -Y.
tt_len = 64.4;
tt_w = 22.3;
tt_clip_w = 22.6;
tt_t = 18.7;
tt_shaft_from_end = 11.0;
tt_shaft_d = 5.4;
tt_shaft_len = 9.1;
tt_boss_d = 5.5;
tt_hole_d = 2.8;
// [along length from shaft, across width from shaft]
tt_holes = [[20.1, 8.85], [20.1, -8.85], [-13.4, 0]];
tt_tab_len = 5.0;
tt_tab_w = 5.7;
// Round peg on the gearbox side, estimated from the drawing scale.
tt_peg = [11.2, 0];
tt_peg_d = 4.0;
tt_top_above_axle = max(tt_w, tt_clip_w) / 2;

wheel_d = 65;
wheel_w = 26;

caster_h = 35;
caster_wheel_d = 25;
caster_hole_d = 5;
caster_hole_spacing = [28, 23];
caster_plate = [38, 32];
caster_plate_t = 2;

// Plate underside height; the caster must reach the same height. Recompute after
// measuring wheel_d, tt_top_above_axle, motor_top_gap and caster_h.
// On the prototype an aluminium angle flange sits between plate and motor (photo
// estimate). The gap also keeps the top motor nut trap clear of the plate.
motor_top_gap = 2;
plate_underside_h = wheel_d / 2 + tt_top_above_axle + motor_top_gap;
caster_spacer_h = plate_underside_h - caster_h;

led_d = 5.0;
led_flange_d = 5.8;
led_flange_h = 1.0;
led_h = 8.6;
led_lead_pitch = 2.54;

// IR receivers: [body w, body h, depth incl. lens, lens centre above body bottom,
//     outer pin spacing, pins from back face]
tsop1730 = [10.0, 12.5, 5.8, 9.2, 7.62, 1.4];
// Upgrade option only (docs/hardware-upgrades.md). Lens height and pin offset are guesses.
tsop38238 = [5.0, 6.95, 4.8, 4.5, 5.08, 1.0];
function tsop_w(t) = t[0];
function tsop_h(t) = t[1];
function tsop_depth(t) = t[2];
function tsop_lens_h(t) = t[3];
function tsop_pin_span(t) = t[4];
function tsop_pin_back(t) = t[5];

btn_hole_d = 24;
btn_bezel_d = 30;
btn_above_panel = 10;
btn_depth = 33;
btn_nut_d = 30;

switch_body = [8.6, 3.6, 3.5];
switch_lever = [2.0, 2.0, 4.0];
switch_travel = 2.0;

cell_d = 18.5;
cell_len = 65.2;

joystick_cap_top = 32;
joystick_cap_d = 25;

// Height above the PCB top per Eagle package, for previews and clearance.
pcb_part_heights = [
    ["KEYSTONE_1049_DUAL_18650_HOLDER", 20],
    ["SINGLE_18650_HOLDER", 20],
    ["NRF24L01+", 13],
    ["NANO", 11],
    ["BA56-12EWA", 8],
    ["DIL14", 7],
    ["DIL16", 7],
    ["F/CM12P", 9.5],
    ["JOYSTICK-2AXIS-BUTTON", 17],
    ["DC-DC-STEP-UP-5V", 7],
    ["TL3XPO", 3.5],
];
function pcb_part_height(package) =
    let(i = search([package], pcb_part_heights)[0])
    is_num(i) ? pcb_part_heights[i][1] : 3;

module tt_motor_ghost() {
    color("gold") {
        translate([-tt_t / 2, -tt_shaft_from_end, -tt_w / 2]) cube([tt_t, tt_len, tt_w]);
        translate([0, -tt_shaft_from_end - tt_tab_len, 0])
            cube([3, 2 * tt_tab_len, tt_tab_w], center = true);
    }
    color("white") rotate([0, 90, 0])
        cylinder(d = tt_shaft_d, h = tt_t + 2 * tt_shaft_len, center = true);
}

module wheel_ghost() {
    color("dimgray") rotate([0, 90, 0]) cylinder(d = wheel_d, h = wheel_w, center = true);
}

// Top of the mounting plate at z = 0, wheel on the ground at z = -caster_h.
module caster_ghost() {
    color("white") {
        translate([0, 0, -caster_plate_t / 2]) cube([caster_plate.x, caster_plate.y, caster_plate_t], center = true);
        translate([0, 0, -caster_h + caster_wheel_d / 2]) rotate([0, 90, 0])
            cylinder(d = caster_wheel_d, h = 10, center = true);
        translate([-8, -4, -caster_h + caster_wheel_d / 2]) cube([16, 8, caster_h - caster_wheel_d / 2]);
    }
}

// Body bottom at z = 0, lens facing +Y.
module tsop_ghost(t = tsop1730) {
    color("black") translate([-tsop_w(t) / 2, 0, 0]) cube([tsop_w(t), tsop_depth(t), tsop_h(t)]);
    color("red") translate([0, tsop_depth(t), tsop_lens_h(t)]) sphere(1);
}

// Two receivers glued back to back, as on the prototype: one lens +Y, one -Y.
module tsop_pair_ghost(t = tsop1730) {
    tsop_ghost(t);
    rotate([0, 0, 180]) tsop_ghost(t);
}

// Flange bottom at z = 0, pointing +Z.
module led_ghost() {
    color("lightblue") {
        cylinder(d = led_flange_d, h = led_flange_h);
        cylinder(d = led_d, h = led_h - led_d / 2);
        translate([0, 0, led_h - led_d / 2]) sphere(d = led_d);
    }
}

// Panel front face at z = 0, button pointing +Z.
module arcade_button_ghost() {
    color("crimson") cylinder(d = btn_bezel_d, h = btn_above_panel);
    color("gray") translate([0, 0, -btn_depth]) cylinder(d = btn_hole_d - 1, h = btn_depth);
}

// PCB from a generated pcb_*.scad table with footprint boxes as part ghosts.
// Bottom of the PCB at z = 0. Parts named in flat_parts are only wire connection
// points on this PCB (the real part sits elsewhere) and are drawn flat.
module pcb_ghost(outline, holes, parts, flat_parts = []) {
    color("darkgreen") difference() {
        linear_extrude(pcb_thickness) polygon(outline);
        for (h = holes) translate([h[1], h[2], 0]) hole(h[3], pcb_thickness, cl = 0);
    }
    for (p = parts) {
        box = p[7];
        h = is_num(search([p[0]], flat_parts)[0]) ? 0.3 : pcb_part_height(p[1]);
        color(h > 15 ? "black" : "steelblue", 0.8)
            translate([box[0], box[1], pcb_thickness]) cube([box[2] - box[0], box[3] - box[1], h]);
    }
}
