// PCB standoff on a piece of base plate. M3 screw from the top through the PCB,
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
        hole(m3_d, plate.z + pcb_standoff_h, m3_cl);
        nut_trap(m3_nut_af, plate.z - nut_roof, m3_nut_cl);
    }
    translate([plate.x / 2, 4, plate.z]) label(str(pcb_standoff_h), size = 3.5);
}
