// Shared print, fastener and helper definitions. Units mm.

$fa = 4;
$fs = 0.3;

eps = 0.01;

// Added to the diameter of holes, seats and press fits. Tune after the test prints.
clearance = 0.2;
wall_min = 1.6;
layer_h = 0.2;
bed_size = [180, 180, 180];

pcb_thickness = 1.6;
base_plate_t = 3;
// Under the PCB for through-hole leads and solder. Set from the vehicle PCB, see docs/measurements.md.
pcb_standoff_h = 2;

// ISO 4032 nuts, nominal.
m25_d = 2.5;
m25_nut_af = 5.0;
m25_nut_h = 2.0;

label_font = "Liberation Sans:style=Bold";

// Vertical hole from z = 0 to z = h.
module hole(d, h, cl = clearance) {
    translate([0, 0, -eps]) cylinder(d = d + cl, h = h + 2 * eps);
}

// Hex pocket from z = 0 to z = h, two flats parallel to X.
module nut_trap(af, h, cl = clearance) {
    translate([0, 0, -eps]) rotate([0, 0, 30])
        cylinder(d = (af + cl) / cos(30), h = h + eps, $fn = 6);
}

// Hole along +Y from y = 0 to y = h with a 45 deg roof pointing +Z,
// so it prints without support when the part's +Z is up on the printer.
module teardrop(d, h, cl = clearance) {
    r = (d + cl) / 2;
    rotate([90, 0, 0]) translate([0, 0, -h - eps])
        linear_extrude(h + 2 * eps) hull() {
            circle(r);
            translate([0, r * sqrt(2) - eps]) square(2 * eps, center = true);
        }
}

// Engraved label, top face at z = 0.
module label(txt, size = 4, depth = 0.6) {
    translate([0, 0, -depth]) linear_extrude(depth + eps)
        text(txt, size = size, font = label_font, halign = "center", valign = "center");
}

// Row from the generated pcb_*.scad parts table by element name.
function pcb_part(parts, name) = parts[search([name], parts)[0]];
