// Vehicle layout shared by the vehicle parts and the preview. Values only, no geometry.
// PCB coordinates: origin at the PCB outline lower-left corner, +Y front, z = 0 on the
// base plate top.

include <common.scad>
include <parts.scad>
include <pcb_vehicle.scad>
use <../vehicle/gun_block.scad>

// The barrel sticks out in front of the plate, so only the plate is limited (by the bed).
plate_size = [100, 170];
plate_x0 = (pcb_vehicle_size.x - plate_size.x) / 2;
// Shorter than on the prototype (48) so the nose starts in front of the gun block wall.
nose_len = 39;
// Motor wall length past the outer motor holes.
motor_wall_margin = 5;
// As far back as it goes with the motor walls ending at the plate rear edge.
axle_y = motor_wall_margin - tt_holes[2][0];
// Front face of the caster spacer leans back going down, as on the prototype.
caster_spacer_rake = 30;
// Gun block wall rear face must stay in front of the NRF24 module.
nrf_gap = 1.0;

// PCB rests at the two corners without holes (no solder joints there), mirrored from H1 and H2.
// [diameter, length] of the rest peg that locates it in the plate.
pcb_rest_peg = [3, 2];

centre_x = plate_x0 + plate_size.x / 2;
pcb_rest_points = [
    [pcb_vehicle_holes[0][1], pcb_vehicle_holes[1][2]],
    [pcb_vehicle_holes[1][1], pcb_vehicle_holes[0][2]],
];
// The gun block on top and the caster spacer below both end at the plate front edge, as a
// nose; the plate front is as wide as both.
nose_front_w = caster_plate.x;
block_y = plate_size.y - gun_block_len();
caster_y = plate_size.y - caster_spacer_h * tan(caster_spacer_rake) - caster_plate.y / 2;

assert(block_y >= pcb_part(pcb_vehicle_parts, "NRF24L")[7][3] + nrf_gap, "gun block wall hits the NRF24 module");
