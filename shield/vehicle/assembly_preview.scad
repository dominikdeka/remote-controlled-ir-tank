// Vehicle preview: printed parts, PCB and bought parts. Not a printable part.
// Checks the extracted PCB data, the levelling math and the vehicle length.
// Coordinates: see lib/vehicle_layout.scad.

include <../lib/vehicle_layout.scad>
use <barrel.scad>
use <gun_block.scad>
use <base_plate.scad>
use <pcb_standoff.scad>

preview_barrel_len = 60;

ground_z = -base_plate_t - plate_underside_h;
axle_z = ground_z + wheel_d / 2;
muzzle_y = block_y + preview_barrel_len;

assert(muzzle_y <= vehicle_len, "barrel makes the vehicle too long");
echo(muzzle_y = muzzle_y, barrel_len_max = vehicle_len - block_y);

color("tan", 0.8) base_plate();

for (h = pcb_vehicle_holes) color("white") translate([h[1], h[2], 0]) pcb_standoff();
for (p = pcb_rest_points) color("white") translate([p.x, p.y, 0]) pcb_rest();
translate([0, 0, pcb_standoff_h])
    pcb_ghost(pcb_vehicle_outline, pcb_vehicle_holes, pcb_vehicle_parts, ["IR", "TSOP1", "TSOP2"]);

for (side = [0, 1]) {
    x_face = side == 0 ? plate_x0 : plate_x0 + plate_size.x;
    dir = side == 0 ? 1 : -1;
    translate([x_face + dir * tt_t / 2, axle_y, axle_z]) tt_motor_ghost();
    translate([x_face - dir * (2 + wheel_w / 2), axle_y, axle_z]) wheel_ghost();
}

translate([centre_x, caster_y, -base_plate_t - caster_spacer_h]) caster_ghost();

translate([centre_x, block_y, 0]) {
    color("sienna", 0.6) gun_block();
    color("silver") translate([0, preview_barrel_len, gun_block_barrel_z()])
        rotate([90, 0, 0]) barrel(len = preview_barrel_len);
    translate(gun_block_tsop_seat()) tsop_pair_ghost(tsop1730);
}

color("lightgray", 0.3) translate([plate_x0 - 40, -20, ground_z - 0.5])
    cube([plate_size.x + 80, plate_size.y + 60, 0.5]);
