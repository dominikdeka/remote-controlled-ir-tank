// LED seat test: short rear barrel sections with seat clearance 0.1, 0.2, 0.3.
// Notches on the rear rim count the tenths. Same print orientation as vehicle/barrel.scad.

use <../vehicle/barrel.scad>
include <../lib/common.scad>
include <../lib/parts.scad>

stub_len = 18;
od = 14;

for (i = [1 : 3]) translate([(i - 1) * (od + 6), 0, 0]) {
    difference() {
        barrel(len = stub_len, od = od, seat_cl = i / 10);
        for (n = [1 : i]) rotate([0, 0, n * 25]) translate([od / 2, 0, stub_len]) cube([1.6, 1.2, 6], center = true);
    }
}
translate([3 * (od + 6), 0, 0]) barrel_cap();
