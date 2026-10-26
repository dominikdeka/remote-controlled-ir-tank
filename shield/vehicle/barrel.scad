// IR gun barrel: thick-wall tube, LED seated coaxially at the rear, held by a rear cap.
// Modeled in print orientation: axis on Z, muzzle on the bed at z = 0, rear at z = len.
// The LED goes in from the rear, its flange stops on a step, and the cap presses it there.

include <../lib/common.scad>
include <../lib/parts.scad>

barrel_len = 60;
barrel_bore_d = 5.0;
barrel_od = 14;
barrel_cap_d = 9;
barrel_cap_h = 3;
barrel_wire_slot = [4.0, 2.0];

function barrel_od() = barrel_od;

// Longer than the LED body so the flange, not the dome, is the stop.
led_seat_len = led_h - led_flange_h + 0.5;

module barrel(len = barrel_len, bore_d = barrel_bore_d, od = barrel_od, seat_cl = clearance) {
    assert(od - barrel_cap_d >= 2 * wall_min, "barrel wall around the cap is too thin");
    assert(len > barrel_cap_h + led_flange_h + led_seat_len + 5, "barrel too short for the LED seat");
    difference() {
        cylinder(d = od, h = len);
        barrel_bore(len, bore_d, seat_cl);
    }
}

// Kept separate so baffles or a muzzle aperture can be added here later.
module barrel_bore(len, bore_d, seat_cl) {
    flange_z = len - barrel_cap_h - led_flange_h;
    hole(bore_d, len, cl = 0);
    translate([0, 0, flange_z - led_seat_len]) cylinder(d = led_d + seat_cl, h = led_seat_len + eps);
    translate([0, 0, flange_z]) cylinder(d = led_flange_d + seat_cl, h = led_flange_h + eps);
    translate([0, 0, len - barrel_cap_h]) cylinder(d = barrel_cap_d + clearance, h = barrel_cap_h + eps);
}

// Printed flat side down; that face presses on the LED flange.
module barrel_cap() {
    difference() {
        cylinder(d = barrel_cap_d, h = barrel_cap_h);
        translate([0, 0, barrel_cap_h / 2])
            cube([barrel_wire_slot.x, barrel_wire_slot.y, barrel_cap_h + 1], center = true);
    }
}

barrel();
translate([barrel_od + 5, 0, 0]) barrel_cap();
