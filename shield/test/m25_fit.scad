// M2.5 fit test. Columns use clearance 0.1, 0.2, 0.3, 0.4 (label = tenths).
// Front row: plain through hole. Back row: through hole with a nut trap from the top.
// Plate is base_plate_t thick, so the nut trap row also shows what is left under a nut.

include <../lib/common.scad>

clearances = [0.1, 0.2, 0.3, 0.4];
pitch = 11;
size = [len(clearances) * pitch + 2, 32, base_plate_t];

difference() {
    cube(size);
    for (i = [0 : len(clearances) - 1]) {
        cl = clearances[i];
        translate([pitch / 2 + 1 + i * pitch, 0, 0]) {
            translate([0, 8, 0]) hole(m25_d, size.z, cl);
            translate([0, 20, 0]) {
                hole(m25_d, size.z, cl);
                translate([0, 0, size.z - m25_nut_h - cl]) nut_trap(m25_nut_af, m25_nut_h + cl, cl);
            }
            translate([0, 28.5, size.z]) label(str(round(cl * 10)), size = 3.5);
        }
    }
}
