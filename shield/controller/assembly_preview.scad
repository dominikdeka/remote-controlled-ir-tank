// Controller preview: case, PCB and bought parts. Not a printable part.
// Coordinates: see controller/case.scad.

include <../lib/common.scad>
include <../lib/parts.scad>
include <../lib/pcb_controller.scad>
use <case.scad>

pcb_top_z = pcb_standoff_h + pcb_thickness;
joystick = pcb_part(pcb_controller_parts, "U$1");

color("tan", 0.8) controller_case();

translate([0, 0, pcb_standoff_h]) pcb_ghost(pcb_controller_outline, pcb_controller_holes, pcb_controller_parts);

color("black") translate([joystick[3], joystick[4], pcb_top_z]) {
    cylinder(d = 4, h = joystick_cap_top);
    translate([0, 0, joystick_cap_top - 8]) cylinder(d = joystick_cap_d, h = 8);
}

for (b = controller_case_buttons()) translate(b) rotate([-90, 0, 0]) arcade_button_ghost();
