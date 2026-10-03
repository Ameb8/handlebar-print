// =============================================================================
// OpenSCAD Vape Holder Mount
// Based on specification: vape-mount.md & measurements.md
// Compatible with OpenSCAD 2021.01+ and 2026+ Customizer
// =============================================================================
//
// DESIGN SUMMARY:
// - A rigid back plate with a compliant foam/rubber pad (thickness 'p').
// - Full-length bottom lip shelf with front overhang ('O_bottom') to support weight.
// - Partial-length top lip shelf with front overhang ('O_top', length 'L_top_lip')
//   covering the end away from the mouthpiece.
// - Mouthpiece end is completely open so the vape can tilt in/out with one hand
//   and the mouthpiece is never touched or covered.
// - Dual strap slots (top and bottom) with fully radiused edges for 15-20mm straps.
// - Rear standoff rails to provide clearance for straps behind the back plate.
// - Configurable end stops: low wall (~3mm) at mouthpiece end, positive stop at far end.
// - Test piece modes: Section 8 Fit Coupon slice and Lip Test piece.
// =============================================================================

/* [Part Selector (Sec 8 Test Plan)] */
// Which part to render
part = "full"; // ["full": Full Vape Holder, "fit_coupon": Fit Coupon Slice (Sec 8.1), "lip_test": Lip & Strap Slot Test Piece (Sec 8.2), "vape_mockup": Vape Mockup Reference Only]

// Display translucent reference vape in preview mode ($preview)
show_vape_ghost = true;

// Thickness of the fit coupon slice (Sec 8.1: 5-10mm recommended)
coupon_thickness = 8.0; // [4:1:20]

// Print orientation for STL export
export_orientation = "as_modeled"; // ["as_modeled": Native upright, "lay_flat_back": Flat on back plate, "stand_on_end": Standing on far end (zero overhangs!)]

/* [Mount Orientation & Vape Presets] */
// Mount orientation on bike
mount_orientation = "horizontal"; // ["horizontal": Long axis along bar, "vertical": Upright vertical, "custom": Custom parameters]

/* [Vape Measurements (Calipers)] */
// Measurements from measurments.md (Lost Mary OS5000 / BM6000 series)
// Length of main body (excluding mouthpiece protrusion)
vape_body_length = 70.0; // [30:0.5:150]
// Height of body when mounted (top edge to bottom edge)
vape_body_height = 40.3; // [20:0.5:100]
// Thickness/depth of body (front-to-back at thickest point)
vape_body_thickness = 21.2; // [10:0.5:50]
// Corner radius of the vape body
vape_corner_radius = 5.0; // [0:0.5:15]
// Length of mouthpiece section that must stay uncovered (Sec 4.1 & 5.6)
vape_mouth_length = 15.3; // [0:0.5:40]
// Protrusion height of mouthpiece beyond body
vape_mouth_height = 15.0; // [0:0.5:30]
// Width of mouthpiece tube
vape_mouth_width = 16.0; // [5:0.5:30]

/* [Design Variables (Sec 4.2)] */
// Total clearance/slack taken up by pad (Sec 4.2)
c = 1.0; // [0.2:0.1:3.0]
// Closed-cell foam or rubber pad thickness on back plate (Sec 4.2)
p = 1.5; // [0:0.1:4.0]
// Minimum wall and plate thickness (Sec 4.2)
t_wall = 3.0; // [2.0:0.5:6.0]
// Bottom lip overhang curling over vape front face (Sec 4.2: 3-4mm)
O_bottom = 3.5; // [2.0:0.5:8.0]
// Top lip overhang curling over vape front face (Sec 4.2: 3-4mm)
O_top = 3.5; // [2.0:0.5:8.0]
// Ratio of top lip length relative to body length (Sec 4.2: ~50%)
top_lip_ratio = 0.50; // [0.20:0.05:0.80]
// Inside corner fillet radius (Sec 4.2: >= 2.0mm)
r_fillet = 2.0; // [1.0:0.5:5.0]

/* [Strap Configuration (Sec 5.5 & 6)] */
// Width of chosen strap (Sec 4.2: 15-20mm)
strap_w = 20.0; // [12:1:25]
// Thickness of chosen strap (Sec 4.2)
strap_t = 1.5; // [1.0:0.1:3.5]
// Enable rear standoff rails for strap clearance behind plate (Sec 5.1 & 10.2)
enable_rear_standoffs = true;
// Depth of rear strap clearance channel (mm)
rear_channel_depth = 2.5; // [1.5:0.5:5.0]

/* [End Stops (Sec 5.7)] */
// Far end stop (away from mouthpiece)
far_end_stop = "full"; // ["full": Full height end cap, "low": Low wall, "none": Open end]
far_end_stop_h = 8.0; // [4:1:30]
// Mouthpiece end stop (Sec 5.7: low wall ~3mm tall to clear mouthpiece)
mouth_end_stop = "low"; // ["low": Low wall, "none": Open end]
mouth_end_stop_h = 3.0; // [2:0.5:6]

/* [Optional Handlebar Mount Fasteners] */
// Optional fastener holes on back plate for mounting bracket
mount_holes = "none"; // ["none": None, "2_hole_m4": 2x M4 clearance holes, "2_hole_m5": 2x M5 clearance holes, "amps_pattern": 4-hole AMPS pattern (30x38mm)]
mount_hole_spacing = 30.0; // [15:1:60]

/* [Resolution] */
$fn = $preview ? 32 : 64;

// =============================================================================
// Calculated Dimensions
// =============================================================================
L_eff = (mount_orientation == "horizontal") ? vape_body_length :
        (mount_orientation == "vertical")   ? vape_body_height : vape_body_length;

H_eff = (mount_orientation == "horizontal") ? vape_body_height :
        (mount_orientation == "vertical")   ? vape_body_length : vape_body_height;

T_eff = vape_body_thickness;

// Cavity internal dimensions (Sec 5.4):
L_cavity = L_eff + c;           // Inner length
H_cavity = H_eff + c;           // Inner height between bottom & top shelves
Y_cavity = p + T_eff + c;       // Inner depth from back plate to front overhangs

// Top lip length (starts from far end, Sec 5.3)
L_top_lip = L_cavity * top_lip_ratio;
L_mouth_clearance = L_cavity - L_top_lip;

// Strap slot dimensions (Sec 5.5: strap_w + 1.5mm, strap_t + 1.5mm)
slot_length = strap_w + 1.5;
slot_height = strap_t + 1.5;

// Extrusion limits along X
x_start = (mouth_end_stop != "none") ? -t_wall : 0;
x_end   = (far_end_stop != "none")   ? L_cavity + t_wall : L_cavity;
L_total = x_end - x_start;

// Rear standoff offset
rear_standoff_y = enable_rear_standoffs ? -t_wall - rear_channel_depth : -t_wall;

// =============================================================================
// 2D Profiles (Extruded along X)
// =============================================================================

// J-Profile: Back Plate + Full-length Bottom Shelf + Bottom Overhang Lip
module j_profile_2d() {
    union() {
        // Outer box profile
        polygon(points=[
            [-t_wall, -t_wall],
            [Y_cavity + t_wall, -t_wall],
            [Y_cavity + t_wall, O_bottom],
            [Y_cavity, O_bottom],
            [Y_cavity, 0],
            [0, 0],
            [0, H_cavity],
            [-t_wall, H_cavity]
        ]);
        
        // Internal Fillet 1: between back plate (Y=0) and bottom shelf (Z=0)
        translate([r_fillet, r_fillet])
        difference() {
            translate([-r_fillet, -r_fillet]) square([r_fillet, r_fillet]);
            circle(r=r_fillet);
        }
        
        // Internal Fillet 2: between bottom shelf (Z=0) and bottom overhang (Y=Y_cavity)
        translate([Y_cavity - r_fillet, r_fillet])
        difference() {
            translate([0, -r_fillet]) square([r_fillet, r_fillet]);
            circle(r=r_fillet);
        }
    }
}

// Top Lip Profile: Top Shelf + Top Overhang Lip (runs along L_top_lip)
module top_lip_profile_2d() {
    union() {
        polygon(points=[
            [-t_wall, H_cavity],
            [0, H_cavity],
            [Y_cavity, H_cavity],
            [Y_cavity, H_cavity - O_top],
            [Y_cavity + t_wall, H_cavity - O_top],
            [Y_cavity + t_wall, H_cavity + t_wall],
            [-t_wall, H_cavity + t_wall]
        ]);
        
        // Internal Fillet 3: between back plate (Y=0) and top shelf (Z=H_cavity)
        translate([r_fillet, H_cavity - r_fillet])
        difference() {
            translate([-r_fillet, 0]) square([r_fillet, r_fillet]);
            circle(r=r_fillet);
        }
        
        // Internal Fillet 4: between top shelf (Z=H_cavity) and top overhang (Y=Y_cavity)
        translate([Y_cavity - r_fillet, H_cavity - r_fillet])
        difference() {
            square([r_fillet, r_fillet]);
            circle(r=r_fillet);
        }
    }
}

// Helper to extrude 2D profile along X-axis
module extrude_profile_x(len) {
    rotate([90, 0, 90])
    linear_extrude(height=len)
    children();
}

// =============================================================================
// 3D Components
// =============================================================================

// Main Solid Body
module holder_solid() {
    union() {
        // 1. Full-length J-profile (back plate + bottom shelf + bottom lip)
        translate([x_start, 0, 0])
            extrude_profile_x(L_total)
            j_profile_2d();
        
        // 2. Partial top lip & shelf (starts from far end, Sec 5.3)
        x_top_start = L_cavity - L_top_lip;
        translate([x_top_start, 0, 0])
            extrude_profile_x(x_end - x_top_start)
            top_lip_profile_2d();
        
        // 3. Top lip lead-in chamfer (helps vape slide and tilt in smoothly)
        lead_in = min(3.0, L_top_lip / 4);
        translate([x_top_start, 0, H_cavity - O_top])
        polyhedron(
            points=[
                [0, Y_cavity, 0],
                [0, Y_cavity + t_wall, 0],
                [0, Y_cavity + t_wall, O_top + t_wall],
                [0, 0, O_top + t_wall],
                [lead_in, Y_cavity, 0],
                [lead_in, Y_cavity + t_wall, 0],
                [lead_in, Y_cavity + t_wall, O_top + t_wall],
                [lead_in, 0, O_top + t_wall]
            ],
            faces=[
                [0,1,2,3], [4,7,6,5],
                [0,4,5,1], [1,5,6,2],
                [2,6,7,3], [3,7,4,0]
            ]
        );
        
        // 4. Far End Stop (Sec 5.7)
        if (far_end_stop == "full") {
            translate([L_cavity, -t_wall, -t_wall])
                cube([t_wall, Y_cavity + 2 * t_wall, H_cavity + 2 * t_wall]);
        } else if (far_end_stop == "low") {
            translate([L_cavity, -t_wall, -t_wall])
                cube([t_wall, Y_cavity + 2 * t_wall, far_end_stop_h + t_wall]);
        }
        
        // 5. Mouthpiece End Stop (Sec 5.7: low wall ~3mm tall to clear mouthpiece)
        if (mouth_end_stop == "low") {
            translate([-t_wall, -t_wall, -t_wall])
                cube([t_wall, Y_cavity + 2 * t_wall, mouth_end_stop_h + t_wall]);
        }
        
        // 6. Rear Standoff Pads (Sec 5.1 & 10.2: clearance for straps behind plate)
        if (enable_rear_standoffs) {
            standoff_w = 8.0;
            pad_h = H_cavity + 2 * t_wall;
            pad_d = rear_channel_depth + 0.01;
            
            // Left pad
            translate([x_start, rear_standoff_y, -t_wall])
                cube([standoff_w, pad_d, pad_h]);
            
            // Middle divider pad
            mid_x = (L_cavity - standoff_w) / 2;
            translate([mid_x, rear_standoff_y, -t_wall])
                cube([standoff_w, pad_d, pad_h]);
            
            // Right pad
            translate([x_end - standoff_w, rear_standoff_y, -t_wall])
                cube([standoff_w, pad_d, pad_h]);
        }
    }
}

// Strap Slots Cutouts (Sec 5.5: fully rounded edges to prevent fraying)
module strap_slots_cutout() {
    // Two strap positions along X (outside mouthpiece clearance)
    strap1_x = max(L_mouth_clearance + slot_length/2 + 2, L_cavity * 0.28);
    strap2_x = min(L_cavity - slot_length/2 - 4, L_cavity * 0.75);
    
    // Narrow bodies use a single centered strap
    strap_xs = (L_cavity < 50) ? [L_cavity / 2] : [strap1_x, strap2_x];
    
    // Slot Z positions near bottom and top of back plate
    slot_z_bot = r_fillet + slot_height/2 + 1.2;
    slot_z_top = H_cavity - r_fillet - slot_height/2 - 1.2;
    
    cut_depth = t_wall + rear_channel_depth + 4;
    
    for (sx = strap_xs) {
        for (sz = [slot_z_bot, slot_z_top]) {
            translate([sx, -t_wall - rear_channel_depth - 2, sz])
                rotate([-90, 0, 0])
                linear_extrude(height=cut_depth)
                hull() {
                    r = slot_height / 2;
                    translate([-slot_length/2 + r, 0]) circle(r=r);
                    translate([ slot_length/2 - r, 0]) circle(r=r);
                }
        }
    }
}

// Optional Mounting Holes on Back Plate
module mount_holes_cutout() {
    cut_depth = t_wall + rear_channel_depth + 4;
    
    if (mount_holes == "2_hole_m4") {
        cx = L_cavity / 2;
        for (dz = [-mount_hole_spacing/2, mount_hole_spacing/2]) {
            translate([cx, -t_wall - rear_channel_depth - 2, H_cavity/2 + dz])
                rotate([-90, 0, 0])
                cylinder(d=4.5, h=cut_depth);
        }
    } else if (mount_holes == "2_hole_m5") {
        cx = L_cavity / 2;
        for (dz = [-mount_hole_spacing/2, mount_hole_spacing/2]) {
            translate([cx, -t_wall - rear_channel_depth - 2, H_cavity/2 + dz])
                rotate([-90, 0, 0])
                cylinder(d=5.5, h=cut_depth);
        }
    } else if (mount_holes == "amps_pattern") {
        cx = L_cavity / 2;
        cz = H_cavity / 2;
        for (dx = [-15, 15], dz = [-19, 19]) {
            translate([cx + dx, -t_wall - rear_channel_depth - 2, cz + dz])
                rotate([-90, 0, 0])
                cylinder(d=4.5, h=cut_depth);
        }
    }
}

// Complete Finished Vape Holder
module vape_holder_complete() {
    difference() {
        holder_solid();
        strap_slots_cutout();
        mount_holes_cutout();
    }
}

// =============================================================================
// Test Pieces (Section 8 Fit & Test Plan)
// =============================================================================

// Sec 8.1: Fit Coupon (5-10mm cross-section slice of back plate, both lips, and gap)
module fit_coupon() {
    extrude_profile_x(coupon_thickness) {
        j_profile_2d();
        top_lip_profile_2d();
    }
}

// Sec 8.2: Lip & Strap Slot Test Piece
module lip_test_piece() {
    test_len = strap_w + 16.0;
    test_x = L_cavity - test_len;
    intersection() {
        vape_holder_complete();
        translate([test_x, -t_wall * 3, -t_wall * 3])
            cube([test_len, Y_cavity + 6 * t_wall, H_cavity + 6 * t_wall]);
    }
}

// =============================================================================
// Vape Reference Mockup (Based on Caliper Measurements)
// =============================================================================
module rounded_box(size, r) {
    w = size[0];
    d = size[1];
    h = size[2];
    cr = min(r, min(w/2, min(d/2, h/2)));
    hull() {
        translate([cr, cr, cr]) sphere(r=cr);
        translate([w-cr, cr, cr]) sphere(r=cr);
        translate([w-cr, d-cr, cr]) sphere(r=cr);
        translate([cr, d-cr, cr]) sphere(r=cr);
        translate([cr, cr, h-cr]) sphere(r=cr);
        translate([w-cr, cr, h-cr]) sphere(r=cr);
        translate([w-cr, d-cr, h-cr]) sphere(r=cr);
        translate([cr, d-cr, h-cr]) sphere(r=cr);
    }
}

module vape_mockup_body() {
    color([0.2, 0.6, 0.9, 0.65]) {
        translate([c/2, p, c/2]) {
            // Main body
            rounded_box([L_eff, T_eff, H_eff], vape_corner_radius);
            
            // Mouthpiece protrusion (measurments.md)
            if (mount_orientation == "horizontal") {
                // Mouthpiece sticks out to the left (-X)
                translate([-vape_mouth_height, (T_eff - vape_mouth_width)/2, (H_eff - vape_mouth_width)/2])
                    rounded_box([vape_mouth_height, vape_mouth_width, vape_mouth_width], 3.0);
            } else {
                // Mouthpiece sits on top left (+Z)
                translate([4.0, (T_eff - vape_mouth_width)/2, H_eff])
                    rounded_box([vape_mouth_width, vape_mouth_width, vape_mouth_height], 3.0);
            }
        }
    }
}

// =============================================================================
// Output Pipeline & Orientation
// =============================================================================
module oriented_output() {
    if (export_orientation == "lay_flat_back") {
        // Lay flat on back plate (Z=0 on bed)
        translate([0, 0, t_wall + (enable_rear_standoffs ? rear_channel_depth : 0)])
            rotate([-90, 0, 0])
            children();
    } else if (export_orientation == "stand_on_end") {
        // Stand upright on far end stop (Z=0 on bed, prints 100% support-free!)
        translate([0, 0, x_end])
            rotate([0, -90, 0])
            children();
    } else {
        // As modeled
        children();
    }
}

// Render execution
oriented_output() {
    if (part == "full") {
        vape_holder_complete();
        if (show_vape_ghost && $preview) {
            %vape_mockup_body();
        }
    } else if (part == "fit_coupon") {
        fit_coupon();
        if (show_vape_ghost && $preview) {
            %vape_mockup_body();
        }
    } else if (part == "lip_test") {
        lip_test_piece();
    } else if (part == "vape_mockup") {
        vape_mockup_body();
    }
}
