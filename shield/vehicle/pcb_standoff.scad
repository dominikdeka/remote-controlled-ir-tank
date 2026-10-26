// PCB standoffs between the base plate and the PCB: sleeves for the two M2.5 screws
// and rests with a locating peg for the two corners without holes. Printed separately
// because the base plate prints top face down. One spare of each.

include <../lib/vehicle_layout.scad>

standoff_d = 7;

module pcb_standoff() {
    difference() {
        cylinder(d = standoff_d, h = pcb_standoff_h);
        hole(m25_d, pcb_standoff_h);
    }
}

// Peg down into the plate, pad top at z = pcb_standoff_h.
module pcb_rest() {
    cylinder(d = standoff_d, h = pcb_standoff_h);
    translate([0, 0, -pcb_rest_peg[1]]) cylinder(d = pcb_rest_peg[0], h = pcb_rest_peg[1] + eps);
}

for (i = [0 : 2]) translate([i * (standoff_d + 3), 0, 0]) {
    pcb_standoff();
    translate([0, standoff_d + 3, pcb_standoff_h]) rotate([180, 0, 0]) pcb_rest();
}
