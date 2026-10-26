// PCB standoff on a piece of base plate. M2.5 screw from the top through the PCB,
// nut trapped in the plate bottom. Checks the standoff height under the PCB leads.

include <../lib/common.scad>

standoff_d = 7;
plate = [24, 24, base_plate_t];

difference() {
    union() {
        cube(plate);
        translate([plate.x / 2, plate.y / 2, 0]) cylinder(d = standoff_d, h = plate.z + pcb_standoff_h);
    }
    translate([plate.x / 2, plate.y / 2, 0]) {
        hole(m25_d, plate.z + pcb_standoff_h);
        nut_trap(m25_nut_af, m25_nut_h + clearance);
    }
    translate([plate.x / 2, 4, plate.z]) label(str(pcb_standoff_h), size = 3.5);
}
