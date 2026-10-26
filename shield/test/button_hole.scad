// 24 mm arcade button panel holes with clearance 0, 0.2, 0.4 (label = hole diameter).
// Panel is panel_t thick; spacing leaves room for the nut behind the panel.

include <../lib/common.scad>
include <../lib/parts.scad>

panel_t = 3;
clearances = [0, 0.2, 0.4];
pitch = btn_nut_d + 3;
panel = [len(clearances) * pitch, pitch + 8, panel_t];

difference() {
    cube(panel);
    for (i = [0 : len(clearances) - 1]) {
        cl = clearances[i];
        translate([pitch / 2 + i * pitch, pitch / 2, 0]) hole(btn_hole_d, panel.z, cl);
        translate([pitch / 2 + i * pitch, pitch + 3.5, panel.z]) label(str(btn_hole_d + cl), size = 4);
    }
}
