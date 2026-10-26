// Gun block: raked block with the barrel bore, the TSOP pair seat on top and the wall
// as its rear part. Modeled in assembly orientation: x = 0 on the barrel axis, y = 0
// at the wall rear face, z = 0 on the base plate top. Printed on the wall rear face,
// so the barrel bore is vertical and round.
// The barrel slides in from the front until its rear end is flush with the wall rear
// face (press the block rear on the table). It is held by friction (barrel_fit_cl).

include <../lib/common.scad>
include <../lib/parts.scad>
use <barrel.scad>

block_w = 30;
block_h = 40;
// Flat top for the TSOP pair, from the wall rear face; the front face leans back by block_rake.
block_top_len = 20;
block_rake = 30;
// Wall: full plate width, sides sloping down to wall_side_h.
wall_w = 100;
wall_t = 4;
wall_side_h = 15;
// Foot on the plate for the M2.5 screws; nuts go under the base plate.
flange_t = 3;
flange_len = 12;
flange_front_w = 84;
flange_hole_x = [25, 40];
flange_hole_y = 8;
barrel_axis_z = 15;
barrel_fit_cl = 0.2;
tsop = tsop1730;
tsop_seat_depth = 5;
// Under the lens ends of the pair; the bodies rest on it, the legs go down between.
tsop_ledge = 2;
// [width, height] of the wire channel from the TSOP legs out of the wall rear face.
tsop_wire_channel = [6, 5];
// Dome radius is 2.75; the whole lens must stay above the block top.
min_lens_above_top = 3.5;

block_len = block_top_len + block_h * tan(block_rake);
bore_d = barrel_od() + barrel_fit_cl;
tsop_y = block_top_len / 2;
tsop_floor_z = block_h - tsop_seat_depth;
wire_z = barrel_axis_z + bore_d / 2 + wall_min;

function gun_block_len() = block_len;
function gun_block_wall_w() = wall_w;
function gun_block_wall_t() = wall_t;
function gun_block_barrel_z() = barrel_axis_z;
function gun_block_tsop_seat() = [0, tsop_y, tsop_floor_z];
function gun_block_holes() = [for (sx = [-1, 1], x = flange_hole_x) [sx * x, flange_hole_y]];

assert(tsop_lens_h(tsop) - tsop_seat_depth >= min_lens_above_top, "TSOP seat too deep, lens would be covered");
assert(tsop_y + (2 * tsop_depth(tsop) + clearance) / 2 + wall_min <= block_top_len, "TSOP pocket does not fit the flat top");
assert(bore_d + 2 * wall_min <= block_w, "block too narrow for the barrel");
assert(barrel_axis_z - bore_d / 2 >= wall_min, "barrel bore too low");
assert(wire_z + tsop_wire_channel.y <= tsop_floor_z - wall_min, "no room for the TSOP wires above the barrel");
echo(block_len = block_len, tsop_legs_max = tsop_floor_z - wire_z, lens_above_top = tsop_lens_h(tsop) - tsop_seat_depth);

// Top face at z = 0, pair centred on the origin, legs straight down into the cavity.
module tsop_seat_cut(t = tsop, depth = tsop_seat_depth, cavity_h = 10, ledge = tsop_ledge) {
    pocket = [tsop_w(t) + clearance, 2 * tsop_depth(t) + clearance];
    cavity = [pocket.x, pocket.y - 2 * ledge];
    assert(tsop_pin_back(t) + 0.5 <= cavity.y / 2, "ledge covers the legs");
    translate([-pocket.x / 2, -pocket.y / 2, -depth]) cube([pocket.x, pocket.y, depth + eps]);
    translate([-cavity.x / 2, -cavity.y / 2, -depth - cavity_h]) cube([cavity.x, cavity.y, cavity_h + eps]);
}

module gun_block() {
    difference() {
        union() {
            hull() {
                translate([-block_w / 2, 0, 0]) cube([block_w, block_len, eps]);
                translate([-block_w / 2, 0, block_h - eps]) cube([block_w, block_top_len, eps]);
            }
            translate([0, wall_t, 0]) rotate([90, 0, 0]) linear_extrude(wall_t) polygon([
                [-wall_w / 2, 0], [wall_w / 2, 0], [wall_w / 2, wall_side_h],
                [block_w / 2, block_h], [-block_w / 2, block_h], [-wall_w / 2, wall_side_h],
            ]);
            linear_extrude(flange_t) polygon([
                [-wall_w / 2, 0], [wall_w / 2, 0], [wall_w / 2, wall_t],
                [flange_front_w / 2, flange_len], [-flange_front_w / 2, flange_len], [-wall_w / 2, wall_t],
            ]);
        }
        translate([0, -eps, barrel_axis_z]) rotate([-90, 0, 0]) cylinder(d = bore_d, h = block_len + 2 * eps);
        translate([0, tsop_y, block_h]) tsop_seat_cut(cavity_h = tsop_floor_z - wire_z);
        translate([-tsop_wire_channel.x / 2, -eps, wire_z]) cube([tsop_wire_channel.x, tsop_y + eps, tsop_wire_channel.y]);
        // Teardrop tip points +Y, which is up when printed on the wall rear face.
        for (sx = [-1, 1], x = flange_hole_x)
            translate([sx * x, flange_hole_y, flange_t]) rotate([-90, 0, 0]) teardrop(m25_d, flange_t);
    }
}

rotate([90, 0, 0]) gun_block();
