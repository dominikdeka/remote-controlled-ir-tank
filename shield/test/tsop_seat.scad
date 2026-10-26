// Seat for the two IR receivers glued back to back, as on the prototype: one lens
// faces +Y, one -Y. Same seat as vehicle/gun_block.scad: the pair sinks into a pocket,
// the bodies rest on two ledges, the legs go straight down. Set tsop = tsop38238 to test
// the upgrade receiver.

include <../lib/common.scad>
include <../lib/parts.scad>
use <../vehicle/gun_block.scad>

tsop = tsop1730;
seat_depth = 5;
block_h = 12;
// Dome radius is 2.75; the whole lens must stay above the block top.
min_lens_above_top = 3.5;

pocket = [tsop_w(tsop) + clearance, 2 * tsop_depth(tsop) + clearance, seat_depth];
block = [pocket.x + 10, pocket.y + 10, block_h];

assert(tsop_lens_h(tsop) - seat_depth >= min_lens_above_top, "seat too deep, lens would be covered");
echo(lens_above_block_top = tsop_lens_h(tsop) - seat_depth);

difference() {
    translate([-block.x / 2, -block.y / 2, 0]) cube(block);
    translate([0, 0, block.z]) tsop_seat_cut(tsop, seat_depth, block.z - seat_depth + eps);
}

%translate([0, 0, block_h - seat_depth]) tsop_pair_ghost(tsop);
