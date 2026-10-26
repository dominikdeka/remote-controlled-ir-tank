// Vehicle layout shared by the vehicle parts and the preview. Values only, no geometry.
// PCB coordinates: origin at the PCB outline lower-left corner, +Y front, z = 0 on the
// base plate top.

include <common.scad>
include <parts.scad>
include <pcb_vehicle.scad>

// Plate rear edge to muzzle tip.
vehicle_len = 180;
plate_size = [100, 170];
plate_x0 = (pcb_vehicle_size.x - plate_size.x) / 2;
// Shorter than on the prototype (48) so the nose starts in front of the gun block wall.
nose_len = 44;
nose_front_w = 33;
axle_y = 37;
caster_y = 142;
// Front face of the caster spacer leans back going down, as on the prototype.
caster_spacer_rake = 30;
// Gun block wall rear face, just in front of the NRF24 module.
nrf_gap = 1.0;

// PCB rests at the two corners without holes (no solder joints there), mirrored from H1 and H2.
// [diameter, length] of the rest peg that locates it in the plate.
pcb_rest_peg = [3, 2];

centre_x = plate_x0 + plate_size.x / 2;
pcb_rest_points = [
    [pcb_vehicle_holes[0][1], pcb_vehicle_holes[1][2]],
    [pcb_vehicle_holes[1][1], pcb_vehicle_holes[0][2]],
];
block_y = pcb_part(pcb_vehicle_parts, "NRF24L")[7][3] + nrf_gap;
