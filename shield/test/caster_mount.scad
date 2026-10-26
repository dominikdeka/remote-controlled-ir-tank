// Caster spacer with a piece of base plate on top, so the plate sits level with the
// rear wheels. Print orientation: plate top on the bed, caster face up.
// Solid: the caster holes are drilled on assembly, the caster held by short self-tapping screws.
// caster_spacer_h is derived in lib/parts.scad from unverified sizes.

include <../lib/common.scad>
include <../lib/parts.scad>

margin = 6;
spacer = [caster_plate.x, caster_plate.y, caster_spacer_h];
plate = [spacer.x + 2 * margin, spacer.y + 2 * margin, base_plate_t];
top = spacer.z + plate.z;

echo(caster_spacer_h = caster_spacer_h, plate_underside_h = plate_underside_h);

difference() {
    union() {
        translate([-plate.x / 2, -plate.y / 2, 0]) cube(plate);
        translate([-spacer.x / 2, -spacer.y / 2, plate.z]) cube(spacer);
    }
    translate([0, 0, top]) label(str(round(caster_spacer_h * 10) / 10), size = 5);
}

%translate([0, 0, top]) rotate([180, 0, 0]) caster_ghost();
