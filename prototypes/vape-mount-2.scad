// ============================================================
// Vape Holder – OpenSCAD parametric model
// Based on: vape-mount.md (Draft v1)
// Measurements: Lost Mary disposable vape (measurments.md)
// Scope: vape-holding cradle only (no bar mount, tether, magnets)
//
// The holder is a single C-channel extrusion with integral lips,
// end walls, and strap slots – one continuous solid body.
// ============================================================

/* ── 1. Measured from the vape (Lost Mary) ─────────────────────
   Orientation (per measurments.md):
     vape upright, logo forward, mouthpiece at top-left.

   Mapping to spec variables:
     spec L  → vape Height ≈ 85 mm
     spec H  → vape Width  ≈ 40 mm
     spec T  → vape Depth  ≈ 21 mm
*/

L       = 85.3;     // total length incl. mouthpiece (largest Height)
L_body  = 75.0;     // ⚠ ESTIMATE – verify where mouthpiece starts
L_mouth = 10.3;     // ⚠ ESTIMATE – L minus L_body
H       = 40.3;     // body height (largest Width)
T       = 21.2;     // body thickness (largest Depth)
R       = 3.0;      // corner radius (approx, cosmetic only for now)

/* ── 2. Design variables ───────────────────────────────────── */

c        = 1.0;     // clearance per axis
p        = 1.5;     // pad thickness (closed-cell foam / rubber)
t_wall   = 3.0;     // minimum wall / plate thickness
O_bottom = 3.5;     // bottom lip overhang over vape front face
O_top    = 3.5;     // top lip overhang over vape front face
L_top_lip = L_body * 0.50;   // top lip covers this much from non-mouthpiece end
strap_w  = 18;      // strap width
strap_t  = 3.0;     // strap thickness
r_fillet = 2.0;     // target fillet radius (cosmetic, see note)
end_stop_h = 3.0;   // end-stop wall height at mouthpiece end

/* NOTE – fillets: the spec calls for 2 mm inside fillets.
   Because some walls are only 3 mm, automatic offset-based
   fillets in 2D would destroy thin features.  Add fillets in
   your slicer or a post-processing CAD tool.                  */

/* ── 3. Derived dimensions ─────────────────────────────────── */

plate_T = t_wall;                     // back plate thickness (alias)

cav_L = L_body + c;                   // cavity length  (Z axis)
cav_H = H + c;                        // cavity height  (Y axis)
// Cavity depth includes pad: spec §5.4 says depth is measured
// "from the pad surface" and must equal T + c.
cav_T = p + T + c;                    // cavity depth   (X axis)

outer_D = plate_T + cav_T + t_wall;   // total depth    (X)
outer_H = cav_H + 2 * t_wall;         // total height   (Y)

// Strap slot dimensions (spec §5.5: +1.5 mm tolerance)
slot_w = strap_w + 1.5;               // slot width  (along Z)
slot_h = strap_t + 1.5;               // slot height (along Y)

// Mouthpiece clearance zone length (spec §5.6)
mouth_clear = L_mouth + c + 2;

$fn = 60;

/* ── 4. C-channel cross-section ────────────────────────────── 
   Defined in the XY plane and extruded along Z.

   Coordinate convention:
     X = depth    0 = back face of plate  →  outer_D = front of lips
     Y = height   0 = bottom of holder    →  outer_H = top
     Z = length   extrusion axis (non-mouthpiece = 0)

   Cross-section looking from the mouthpiece end (+Z):

           ┌──┐   ← top curl (only present over L_top_lip)
           │  │
      ┌────┘  │
      │ back  │   ← open front (vape inserts here)
      │ plate │
      │       │
      └────┐  │
           │  │
           └──┘   ← bottom curl (full length)
*/

module c_profile() {
    polygon(points = [
        [0,              0                          ],  //  0 back-bottom
        [outer_D,        0                          ],  //  1 front-bottom
        [outer_D,        t_wall + O_bottom          ],  //  2 bottom curl top (outer)
        [outer_D-t_wall, t_wall + O_bottom          ],  //  3 bottom curl top (inner)
        [outer_D-t_wall, t_wall                     ],  //  4 cavity floor @ front wall
        [plate_T,        t_wall                     ],  //  5 cavity floor @ back plate
        [plate_T,        outer_H - t_wall           ],  //  6 cavity ceiling @ back plate
        [outer_D-t_wall, outer_H - t_wall           ],  //  7 cavity ceiling @ front wall
        [outer_D-t_wall, outer_H - t_wall - O_top   ],  //  8 top curl bottom (inner)
        [outer_D,        outer_H - t_wall - O_top   ],  //  9 top curl bottom (outer)
        [outer_D,        outer_H                    ],  // 10 front-top
        [0,              outer_H                    ],  // 11 back-top
    ]);
}

/* ── 5. Rounded strap slot ─────────────────────────────────── 
   Stadium-shaped hole through the back plate.
   y_ctr   = Y centre of the slot
   z_start = Z position of the slot's near edge
   The strap threads: behind plate → bottom slot → over
   vape front face → top slot → behind plate → buckle.
*/

module strap_slot(y_ctr, z_start) {
    hull() {
        translate([-0.1, y_ctr, z_start + slot_h/2])
            rotate([0, 90, 0])
                cylinder(d = slot_h, h = plate_T + 0.2);
        translate([-0.1, y_ctr, z_start + slot_w - slot_h/2])
            rotate([0, 90, 0])
                cylinder(d = slot_h, h = plate_T + 0.2);
    }
}

/* ── 6. Main body ──────────────────────────────────────────── */

module vape_holder() {

    // ─ Strap slot Y positions (centres) ─
    bot_slot_y = t_wall + 3 + slot_h/2;            // 3 mm above cavity floor
    top_slot_y = t_wall + cav_H - 3 - slot_h/2;    // 3 mm below cavity ceiling

    // ─ Strap Z positions (two straps along the length) ─
    strap1_z = 8;                                    // near non-mouthpiece end
    strap2_z = cav_L - mouth_clear - slot_w - 3;     // near mouthpiece, outside clearance

    difference() {
        union() {

            // ── C-channel body (full cavity length) ─────────
            // This single extrusion forms the back plate, both
            // lips with their curls, and the open-front cavity
            // – all as one connected solid.
            linear_extrude(height = cav_L)
                c_profile();

            // ── Non-mouthpiece end wall ─────────────────────
            // Solid rectangle closes this end of the cavity.
            translate([0, 0, -t_wall])
                linear_extrude(height = t_wall + 0.01)
                    square([outer_D, outer_H]);

            // ── Mouthpiece end wall (low, clears mouthpiece) 
            // Only rises end_stop_h above the shelf so the
            // mouthpiece can pass freely above it.
            translate([0, 0, cav_L - 0.01]) {
                // floor continuation
                cube([outer_D, t_wall, t_wall + 0.02]);
                // bottom curl continuation
                translate([outer_D - t_wall, 0, 0])
                    cube([t_wall, t_wall + O_bottom, t_wall + 0.02]);
                // back plate (low)
                cube([plate_T, t_wall + end_stop_h, t_wall + 0.02]);
                // end stop across cavity
                translate([plate_T, t_wall, 0])
                    cube([cav_T, end_stop_h, t_wall + 0.02]);
            }
        }

        // ── Remove top lip beyond L_top_lip ─────────────────
        // Mouthpiece region: no ceiling, no top curl, so the
        // vape can be tilted in/out and the mouthpiece is clear.
        translate([plate_T - 0.01,
                   outer_H - t_wall - O_top - 0.01,
                   L_top_lip])
            cube([cav_T + t_wall + 0.02,
                  t_wall + O_top + 0.02,
                  cav_L - L_top_lip + t_wall + 0.02]);

        // ── Strap slots (2 per strap × 2 straps = 4 total) ─
        // Each strap needs a bottom slot and a top slot through
        // the back plate so it can loop behind the plate and
        // wrap over the vape's front face.
        for (sz = [strap1_z, strap2_z]) {
            strap_slot(bot_slot_y, sz);
            strap_slot(top_slot_y, sz);
        }
    }
}

/* ── 7. Render ─────────────────────────────────────────────── */

vape_holder();

/* ── 8. Ghost vape for fit-check ─────────────────────────────
   Uncomment the two lines below to show a translucent box
   representing the vape body sitting in the cavity.           */

%color("SteelBlue", 0.25)
    translate([plate_T + p, t_wall, 0])
    cube([T, H, L_body]);
