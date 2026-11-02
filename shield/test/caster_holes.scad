// Caster hole pattern check: a 3 mm plate the size of the caster mounting plate with
// M3 holes at caster_hole_spacing. Lay the caster on it and pass M3 screws through
// both to check the pattern.

include <../lib/common.scad>
include <../lib/parts.scad>

t = 3;

difference() {
    translate([-caster_plate.x / 2, -caster_plate.y / 2, 0]) cube([caster_plate.x, caster_plate.y, t]);
    for (sx = [-1, 1], sy = [-1, 1])
        translate([sx * caster_hole_spacing.x / 2, sy * caster_hole_spacing.y / 2, 0]) hole(m3_d, t, m3_cl);
    translate([0, 0, t]) label(str(caster_hole_spacing.x, "x", caster_hole_spacing.y), size = 4);
}
