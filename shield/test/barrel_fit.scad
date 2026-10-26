// Barrel fit in the gun block bore: short rings with barrel_fit_cl 0.1, 0.2, 0.3
// (notches = tenths). Printed like the block, bore vertical. Try them with the
// test/barrel_set barrels: the barrel should slide in by hand and stay put.

use <../vehicle/barrel.scad>
include <../lib/common.scad>

ring_h = 10;
ring_wall = 3;

for (i = [1 : 3]) {
    d = barrel_od() + i / 10;
    od = d + 2 * ring_wall;
    translate([(i - 1) * (od + 5), 0, 0]) difference() {
        cylinder(d = od, h = ring_h);
        hole(d, ring_h, cl = 0);
        for (n = [1 : i]) rotate([0, 0, n * 25]) translate([od / 2, 0, ring_h]) cube([1.6, 1.2, 6], center = true);
    }
}
