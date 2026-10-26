// Barrel precision test set: same bore and wall, three lengths, one cap each.
// Compare hit precision at distance on the real vehicle.

use <../vehicle/barrel.scad>

lengths = [40, 50, 60];
od = 14;

for (i = [0 : len(lengths) - 1]) translate([i * (od + 6), 0, 0]) {
    barrel(len = lengths[i], od = od);
    translate([0, od + 4, 0]) barrel_cap();
}
