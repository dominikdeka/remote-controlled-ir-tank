// Controller preview: PCB, bought parts and layout placeholders. Not a printable part.
// Every layout_* value is a placeholder for the case design, not a decision.
// Origin: PCB outline lower-left corner. z = 0: top of the case floor.
// The button block is on the +Y edge, as on the prototype (docs/photos/controller_top.jpg).

include <../lib/common.scad>
include <../lib/parts.scad>
include <../lib/pcb_controller.scad>

layout_case = [100, 90];
layout_block_h = 30;
layout_button_x = [25, 75];

block_y = pcb_controller_size.y;
pcb_top_z = pcb_standoff_h + pcb_thickness;
joystick = pcb_part(pcb_controller_parts, "U$1");

color("tan", 0.6) translate([0, 0, -base_plate_t]) cube([layout_case.x, layout_case.y, base_plate_t]);

translate([0, 0, pcb_standoff_h]) pcb_ghost(pcb_controller_outline, pcb_controller_holes, pcb_controller_parts);

color("black") translate([joystick[3], joystick[4], pcb_top_z]) {
    cylinder(d = 4, h = joystick_cap_top);
    translate([0, 0, joystick_cap_top - 8]) cylinder(d = joystick_cap_d, h = 8);
}

color("sienna", 0.35) translate([0, block_y, 0]) cube([layout_case.x, layout_case.y - block_y, layout_block_h]);

for (x = layout_button_x)
    translate([x, layout_case.y, layout_block_h / 2]) rotate([-90, 0, 0]) arcade_button_ghost();
