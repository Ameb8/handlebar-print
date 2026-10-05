// Vape cradle only, based on vape-mount.md. Units: mm.
// No handlebar attachment, magnets, tether, straps or physical pads.
// IMPORTANT: L_body, L_mouth, R and strap_t are provisional measurements.
// Measure them before printing a full holder; first print a fit coupon.
// The vape's long axis is Z: closed/body end at Z=0, mouthpiece at +Z.
// X is depth (back to front), Y is height between the retaining lips.
// Printing on the short end keeps the lip/plate cross-section in each layer.
// Route each strap: rear -> lower slot -> across the vape's front ->
// upper slot -> rear. Leave room behind the plate in your separate bar mount.
// Cut pad openings at the slots, and stop all padding at the holder's end.
// The raw cavity includes pad allowance: after padding its height is H+c
// and its depth between back/front contact pads is T+c.
// Mouthpiece clearance takes priority over the spec's full-body plate length:
// the plate and full-length bottom lip both end c+2 mm before L_body.
// Preview is a bounding envelope, not proof of insertion or real-world fit.
// Tough PLA: >=4 perimeters, 30-40% infill. Confirm orientation/supports in
// the slicer; print the fit_coupon before the holder, then test strap retention.

/* [Vape measurements] */
// Overall long axis: maximum upright height from measurments.md.
L = 85.3;
// ESTIMATE: measure the main body excluding the mouthpiece.
L_body = 75.0;
// ESTIMATE: exposed mouthpiece section along the long axis.
L_mouth = 10.3;
// Largest measured width; the vape is rotated relative to its upright pose.
H = 40.3;
// Largest measured front-to-back depth.
T = 21.2;
// Approximate body corner radius, for reference only; no curve matching.
R = 3.0;

/* [Fit and walls] */
// Total free play per padded axis, not clearance on each side.
c = 1.0;
// Pad on back, both shelves and the inside faces of the front curls.
p = 1.5;
t_wall = 3.0;
O_bottom = 3.5;
O_top = 3.5;
L_top_lip = L_body * 0.5;
r_fillet = 2.0;

/* [Straps] */
strap_w = 18.0;
// ESTIMATE: measure your strap.
strap_t = 3.0;
// Additional rounding at the entry/exit of each through-slot.
slot_edge_r = 0.6;

/* [Options] */
// End stops were unconfirmed in the spec; disabled by default.
end_stops = false;
end_stop_h = 3.0;
// holder, fit_coupon, or lip_test
part = "holder"; // [holder,fit_coupon,lip_test]
coupon_length = 8.0;
// Preview-only body envelope; never included in STL exports.
show_vape = true;

/* [Hidden] */
$fn = 64;
eps = 0.02;
mouth_clear = c + 2;
// Conservative setback: nothing extends into the mouthpiece keep-out.
// The final mouth_clear mm of the main body remain unsupported.
holder_len = L_body - mouth_clear;
top_len = min(L_top_lip, holder_len);
// Both lip contact faces are padded, so add 2*p to the raw height.
gap_h = H + c + 2*p;
// Back pad and front-curl pad each consume p of the raw depth.
gap_d = T + c + 2*p;
front_x = t_wall + gap_d;
outer_d = front_x + t_wall;
outer_h = gap_h + 2*t_wall;
slot_w = strap_w + 1.5;
slot_h = strap_t + 1.5;
// Keep a full wall thickness outside even the flared slot mouths.
slot_margin = t_wall + slot_edge_r;
strap_z = [slot_margin + slot_w/2,
           holder_len - slot_margin - slot_w/2];
slot_y = [t_wall + r_fillet + slot_margin + slot_h/2,
          outer_h - t_wall - r_fillet - slot_margin - slot_h/2];

assert(L > 0 && L_body > 0 && L_mouth >= 0 && H > 0 && T > 0,
       "Vape dimensions must be positive.");
assert(abs(L - L_body - L_mouth) < 0.1,
       "L must equal L_body + L_mouth. Measure the mouthpiece split.");
assert(c >= 0 && p >= 0 && t_wall >= 3 && r_fillet >= 2,
       "Use nonnegative fit allowances, walls >=3 mm and fillets >=2 mm.");
assert(O_bottom >= r_fillet && O_top >= r_fillet,
       "Lip overlaps must be at least the inside fillet radius.");
assert(top_len > 0 && L_top_lip <= holder_len,
       "Top lip must end before the mouthpiece keep-out.");
assert(strap_w > 0 && strap_t > 0 && slot_w >= slot_h,
       "Strap slot width must exceed its height.");
assert(slot_edge_r > 0 && 2*slot_edge_r < t_wall,
       "Slot edge rounding must be less than half the plate thickness.");
assert(strap_z[1] - strap_z[0] >= slot_w + 2*slot_edge_r + t_wall,
       "Body is too short for two straps with adequate material between slots.");
assert(slot_y[1] - slot_y[0] >= slot_h + 2*slot_edge_r + t_wall,
       "Body is too narrow for the strap slots.");
assert(coupon_length > 0 && coupon_length <= top_len,
       "Fit coupon must fit inside the top-lip section.");
assert(part == "holder" || part == "fit_coupon" || part == "lip_test",
       "Select holder, fit_coupon or lip_test.");

// Material fillet at a concave corner. Local cavity extends toward +X,+Y.
module inside_fillet(r) {
    difference() {
        square([r, r]);
        translate([r, r]) circle(r=r);
    }
}

// Full-length back plate, bottom shelf and front retaining curl.
module bottom_profile() {
    union() {
        square([t_wall, outer_h]);
        square([outer_d, t_wall]);
        translate([front_x, 0])
            square([t_wall, t_wall + p + O_bottom]);
        translate([t_wall, t_wall]) inside_fillet(r_fillet);
        translate([front_x, t_wall])
            mirror([1, 0]) inside_fillet(r_fillet);
    }
}

// Partial top shelf/curl with structural fillets at both inside roots.
module top_profile() {
    union() {
        translate([0, outer_h-t_wall]) square([outer_d, t_wall]);
        translate([front_x, outer_h-t_wall-p-O_top])
            square([t_wall, t_wall+p+O_top]);
        translate([t_wall, outer_h-t_wall])
            mirror([0, 1]) inside_fillet(r_fillet);
        translate([front_x, outer_h-t_wall])
            rotate(180) inside_fillet(r_fillet);
    }
}

module slot_outline(w, h) {
    hull() for (z = [-(w-h)/2, (w-h)/2])
        translate([z, 0]) circle(d=h);
}

// Sweep through the plate along X. Multiple expanded rings create a
// rounded entry/exit, while the narrowest throat stays slot_w by slot_h.
module strap_slot(y, z) {
    rotate([0, 90, 0]) translate([-z, y, 0])
        union() {
            for (i = [0:11]) {
                x0 = -eps + (t_wall+2*eps)*i/12;
                x1 = -eps + (t_wall+2*eps)*(i+1)/12;
                hull() for (x = [x0, x1]) {
                    edge_dist = max(0, min(x, t_wall-x));
                    delta = edge_dist >= slot_edge_r ? 0 :
                        slot_edge_r - sqrt(max(0, slot_edge_r*slot_edge_r
                            - pow(slot_edge_r-edge_dist, 2)));
                    translate([0, 0, x]) linear_extrude(height=eps)
                        offset(delta=delta) slot_outline(slot_w, slot_h);
                }
            }
        }
}

module cradle(length, upper_length, slots=false, stops=false) {
    difference() {
        union() {
            linear_extrude(height=length) bottom_profile();
            linear_extrude(height=upper_length) top_profile();
            // Closed-end wall protrudes outwards. The mouthpiece-side wall
            // sits inside the last t_wall mm of the shelf to keep the setback.
            if (stops) for (z = [-t_wall, length-t_wall])
                translate([0, 0, z])
                    cube([outer_d, t_wall+p+end_stop_h, t_wall]);
        }
        if (slots) for (z = strap_z) for (y = slot_y)
            strap_slot(y, z);
    }
}

if (part == "holder")
    cradle(holder_len, top_len, true, end_stops);
else if (part == "fit_coupon")
    cradle(coupon_length, coupon_length);
else
    // A slice containing an actual strap's upper and lower slots.
    intersection() {
        cradle(holder_len, top_len, true);
        translate([-eps, -eps, 0])
            cube([outer_d+2*eps, outer_h+2*eps,
                  strap_z[0]+slot_w/2+slot_margin]);
    }

if (show_vape && part == "holder") {
    // Bounding box only: no claim to reproduce the vape's curved body.
    %color("SteelBlue", 0.3)
        translate([t_wall+p+c/2, t_wall+p+c/2, 0])
            cube([T, H, L_body]);
    // Full cross-section keep-out conservatively covers unknown mouth shape.
    %color("Orange", 0.25)
        translate([t_wall, t_wall, L_body])
            cube([gap_d, gap_h, L_mouth]);
}
