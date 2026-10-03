# Spec: Vape Holder (Handlebar Attachment)

**Status:** Draft v1
**Scope:** The vape-holding part only. The bar mount, tether and magnets are out of scope and covered separately.
**Use case:** Hold a curved, rectangular-box disposable vape securely on a mountain bike (high speed, bumps, vibration) and let it be removed quickly with one hand.

---

## 1. Design goals

1. **Secure under vibration and impacts.** The vape must not rattle, creep or shake loose on rough trails.
2. **No accurate CAD model of the vape.** The design uses only caliper measurements of the bounding box. Fit is corrected by a compliant pad and strap tension, not by matching the vape's curves.
3. **Printable and repairable.** One part in Tough PLA, with simple geometry and no fragile snap features.
4. **Mouthpiece stays clear.** Nothing covers or touches the mouthpiece end.

---

## 2. Design summary

A rigid back plate holds the vape flat against it. The vape is captured top and bottom by lips and pressed against the back plate by straps that run over its front face. A foam pad takes up shape and tolerance mismatch.


---

## 3. Agreed design decisions

| # | Decision |
|---|----------|
| 1 | The retention system is **strap-based**, not snap-fit or latch-based. |
| 2 | Straps run **over the front of the vape from the back**, wrapping around the vape and the holder. |
| 3 | A **bottom lip runs the full horizontal length** of the vape. |
| 4 | A **smaller top lip covers only part of the length**, leaving room for the mouthpiece. |
| 5 | A **foam or rubber pad** lines the contact surfaces to absorb tolerance and vibration. |
| 6 | The holder is printed in **Tough PLA** (available at the CWU Multimodal Education Center). |

---

## 4. Parameters

Measure these on the vape with calipers and enter them as **named variables** in CAD, so any change is a one-number edit.

### 4.1 Measured from the vape

| Variable | Meaning | Value |
|----------|---------|-------|
| `L` | Overall length along the long axis (including the mouthpiece if it protrudes) | ___ mm |
| `L_body` | Length of the main body without the mouthpiece | ___ mm |
| `L_mouth` | Length of the mouthpiece section that must stay uncovered | ___ mm |
| `H` | Height of the body when mounted (top edge to bottom edge) | ___ mm |
| `T` | Thickness of the body (front-to-back), at its thickest point | ___ mm |
| `R` | Corner radius of the body (approximate) | ___ mm |

Measure `H` and `T` at several points along the length and use the **largest** value.

### 4.2 Design variables

| Variable | Default | Notes |
|----------|---------|-------|
| `c` (clearance) | 1.0 mm | Total slack per axis, taken up by the pad |
| `p` (pad thickness) | 1.5 mm | Closed-cell foam or rubber sheet, on the back plate and lip contact faces |
| `t_wall` | 3.0 mm | Minimum wall and plate thickness |
| `O_bottom` | 3-4 mm | How far the bottom lip curls over the front face of the vape |
| `O_top` | 3-4 mm | How far the top lip curls over the front face of the vape |
| `L_top_lip` | ~50% of `L_body` | Top lip length, starting from the end away from the mouthpiece |
| `strap_w` | 15-20 mm | Width of the chosen strap |
| `strap_t` | per strap | Thickness of the chosen strap |
| `r_fillet` | 2.0 mm minimum | Applies to all inside corners |

---

## 5. Features

### 5.1 Back plate
- Flat plate, `t_wall` thick, covering the vape's full length (`L_body` + `c`) and height (`H` + `c`).
- Pad `p` is stuck to its front face, where the vape rests.
- The back of the plate interfaces with the bar mount (out of scope). It must leave **clearance behind the plate for the strap to pass**. This depends on the mount design.

### 5.2 Bottom lip (full length)
- Runs the full length of the plate, as a shelf that supports the vape's bottom edge.
- The front edge curls up and over the vape's front face by `O_bottom`.
- Carries the weight of the vape and resists downward bumps.

### 5.3 Top lip (partial length)
- Overhangs the vape's top edge by `O_top`, over the length `L_top_lip` only.
- It starts from the end **away from the mouthpiece**. The mouthpiece end is left open so nothing covers or presses on it, and so the vape can be tilted in or out.
- Resists lifting and prying out on bumps.

### 5.4 Inside gap between lips
- Inner height between the bottom lip's upper face and the top lip's underside = `H` + `c`.
- Inner depth from the pad surface to the front edge of the lips' overhang = `T` + `c`, so the vape seats with a firm push against the pad.
- The gap should be tight enough that the vape cannot shift by more than about 1 mm in any direction before the strap is tightened.

### 5.5 Strap slots
- Two sets of slots, one per strap, placed along the length of the plate (one near each end, outside the mouthpiece clearance).
- Slot size: `strap_w` + 1.5 mm wide by `strap_t` + 1.5 mm thick, with fully rounded edges so the strap does not fray.
- At least `t_wall` of material around each slot. Add local thickening if needed.
- Straps pass through the slots behind the plate and wrap over the front of the vape, pressing it into the pad and against the plate.

### 5.6 Mouthpiece clearance
- No part of the holder, strap or pad may cover the mouthpiece (`L_mouth`).
- Leave `c` + 2 mm of free space around the mouthpiece.

### 5.7 End stops (proposed, not yet confirmed)
- Low walls (about 3 mm tall) at the two short ends of the tray to stop the vape from sliding along its length. The mouthpiece end stop is kept low so it clears the mouthpiece.
- Without end stops, the straps and pad friction alone prevent lengthwise sliding.

---

## 6. Straps

- **Recommended:** rubberized nylon strap with a metal cam buckle (Voile style), 15-20 mm wide, one strap near each end of the vape.
- Backup: rubberized hook-and-loop strap with at least 3-4 cm of overlap.
- Avoid elastic bungee as the only retention, because it stretches over time and lets the vape bounce.
- Keep the loose tail tidy with an elastic keeper so it cannot flap or snag.
- Straps must not cross the mouthpiece, any button or airflow opening.
- Do not over-tighten. The vape contains a lithium battery, so firm but not crushing pressure is enough.

---

## 7. Materials and printing

| Item | Spec |
|------|------|
| Material | Tough PLA (regular PLA is more brittle and softens with heat) |
| Walls / perimeters | 4 or more |
| Infill | 30-40% |
| Inside corners | Filleted, `r_fillet` of 2 mm or more |
| Orientation | Orient so the lip-to-plate junction is not a weak layer interface, meaning the lips should not peel apart along layer lines under load. Confirm in the slicer. |
| Pad | Closed-cell foam or rubber sheet, `p` thick, self-adhesive |

---

## 8. Fit and test plan

1. **Fit coupon:** print a 5-10 mm thick slice of the cross-section (back plate, both lips, and the gap). Check that the vape seats with a firm push and cannot lift out.
2. **Lip test piece:** print a short section including the lip root and end, to check lip overlap and strap slot fit.
3. **Adjust in CAD:** change the variables, not the geometry. If the fit is loose, thicken the pad before reprinting.
4. **Full print:** assemble with the pad and straps.
5. **Shake test:** shake the bike hard by hand, then slam the bars onto the front wheel a few times.
6. **Ride test:** low-speed rough ground first, checking for strap creep, vape movement and cracks in the slots or lips. Recheck after the first few rides, then periodically.

---

## 9. Acceptance criteria

- The vape does not move more than about 1 mm when shaken by hand with the strap tightened.
- The vape stays seated through a rough-ground ride with no strap loosening.
- Removing the vape takes one hand and a few seconds.
- No cracks or whitening in the lips or strap slots after a test ride.
- The mouthpiece remains uncovered and uncontacted.

---

## 10. Open questions

1. Which way does the vape sit on the bike (long axis along the bar, or pointing forward or up)? This affects which direction bumps push it and which lip takes the load.
2. Exactly how the straps are routed behind the plate depends on the bar mount you buy, because the strap needs a gap behind the plate or slots through it.
3. Whether end stops are needed once the straps and pad are tested.
4. Strap width and type, which sets the slot dimensions.
