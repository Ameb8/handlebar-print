# Handlebar Holder: Spec & Build Plan

A 3D-printed cradle that mounts to a bike handlebar for quick one-handed access to a disposable vape.

## 1. Decisions

| Area | Decision |
|---|---|
| Print material | PLA (Tough PLA if the MEC offers it and the color is acceptable) |
| Printer | CWU Multimodal Education Center (Ultimaker 2+ / Makerbot Replicator 2X) |
| Mount base | Pre-bought handlebar mount (bike light, phone, or accessory mount), metal preferred |
| Printed part | Cradle/holder only. The clamp is not printed. |
| Retention | Physical stop (shelf and lip) plus a small magnet to keep the device seated |
| Grip lining | Thin self-adhesive foam or silicone strip inside the cradle |
| Tether | None by default. If added, use a breakaway or retractable badge-reel style only. |
| Resin | Not used for structural parts |

## 2. Open Questions (resolve before modeling)

- [ ] **Handlebar type and diameter:** flat/riser (22.2 mm), drop, or other. Measure with calipers.
- [ ] **Vape model:** exact length, width, thickness, and body material (metal or plastic). Measure with calipers.
- [ ] **Mount base:** which product, and what attachment interface it offers (e.g., GoPro-style, M5 bolt pattern, flat plate, quarter-turn).
- [ ] **Placement:** just inside the grip or near the stem, clear of brake levers, cables, and shifters.
- [ ] **Current MEC offerings:** the page I reviewed references Fall 2019. Confirm materials, colors, and pricing by email.

## 3. Requirements

**Functional**
- Device can be removed one-handed without looking down.
- Device stays seated over bumps, potholes, and vibration.
- No part of the holder or device interferes with brake lever travel, shifting, or steering lock.
- Device is enclosed enough not to be crushed or ejected in a fall.

**Durability**
- Cradle wall thickness of 3 mm or more, with 4+ perimeters and 40-60% infill (100% around bolt or magnet areas).
- Print orientation puts layer lines perpendicular to the main load.
- Avoid heat exposure above about 50°C (no hot cars, no direct summer sun when parked).
- Metal fasteners only. No threading directly into plastic where it carries load.

**Fit tolerances**
- Starting clearance of 0.3 mm per side around the device, tested at 0.2, 0.3, and 0.4 mm.
- Magnet pockets about 0.1-0.2 mm oversize for a press fit plus CA glue.

## 4. Design Concept

- **Interface plate:** a printed adapter that matches the pre-bought mount's attachment pattern.
- **Cradle:** a partial sleeve with a back shelf (bump stop), side walls, and an open front/top for pull-out. The pull-out direction differs from the direction bumps push.
- **Magnets:** one or two 8x3 mm neodymium discs in the cradle, matched to a magnet in or on a thin sleeve around the device (so it doesn't depend on the device's own body). Verify polarity before gluing.
- **Lining:** foam or silicone strip adhered inside the cradle walls for friction and rattle damping.
- **Optional:** a small lanyard hole for a breakaway tether, located so a falling cord can't reach the wheel or levers.

## 5. Bill of Materials

| Item | Notes |
|---|---|
| Pre-bought handlebar mount | Metal clamp, correct bar diameter |
| PLA filament (printed by MEC) | About $0.05/gram; the cradle should be a small print |
| Neodymium magnets, 8x3 mm | Buy a pack of 10+ to allow mistakes |
| Self-adhesive foam or silicone strip | About 1-2 mm thick |
| CA (super) glue | For magnets |
| Fasteners | Match the mount's interface (M4/M5 bolts, nuts, washers) |
| Optional: breakaway lanyard or badge reel | Only if a tether is wanted |
| Calipers | Essential for the measurements below |
| Sandpaper, 220 grit | Post-print cleanup |

## 6. Build Steps

### Phase 1: Measure and source
1. Measure bar diameter, available space, and brake/shifter clearance on the actual bike.
2. Measure the vape (length, width, thickness) at several points. Disposables often taper.
3. Choose and order the handlebar mount. Measure its attachment interface once it arrives.
4. Order magnets, foam strip, and fasteners.
5. Email mec@cwu.edu to confirm current materials, colors, pricing, and any content restrictions.

### Phase 2: Design (Fusion 360 or Blender)
1. Model the vape as a reference body with real dimensions.
2. Model the interface plate to match the mount's bolt pattern or slot.
3. Build the cradle around the vape with the shelf, side walls, and open pull-out side.
4. Add magnet pockets, foam relief, and (optionally) the lanyard hole.
5. Create a test sheet: several cradle versions with 0.2 / 0.3 / 0.4 mm clearance on one plate.
6. Export STL files and note the dimension along at least one axis, which the MEC requires.

### Phase 3: Prototype print
1. Submit the STL (attached, not linked) with material, color, dimensions, and quantity.
2. Describe it plainly: "handlebar-mounted holder for a cylindrical/rectangular device."
3. Expect 72 business hours minimum, up to two weeks. Confirm the quote before they start.

### Phase 4: Fit and test
1. Pick the clearance that holds snugly but releases easily.
2. Dry-fit on the mount and bike. Check reach, lever travel, full steering lock, and cable clearance.
3. Glue magnets (check polarity first) and apply the foam lining.
4. Shake test off the bike, then a slow-speed rough-surface test.

### Phase 5: Revise and final print
1. Adjust the model from test results: clearance, pull-out angle, magnet strength, placement.
2. Print final version(s) in Tough PLA if available. Order a spare.
3. Light sanding on contact edges only. Do not sand mating surfaces.

### Phase 6: Install and maintain
1. Mount with a metal fastener, snug but not over-tightened (PLA can crack).
2. Inspect for cracks, loose magnets, and fastener tightness every couple of weeks.
3. Don't park the bike in direct sun or a hot car.
4. Replace the printed part if you see stress whitening or layer separation.

## 7. Safety Notes

- Use the device only on flat, straight, traffic-free stretches, with a hand ready on the brakes.
- Keep the device enclosed in the cradle: a lithium cell shouldn't be crushed, heated, or left loose.
- Avoid loose cords near levers and wheels. Any tether must release under load.

## 8. Fallbacks

- **MEC declines or has delays:** Yakima Maker Space, an online print service (PETG or nylon available), or a budget printer of your own.
- **Magnet retention too weak or too strong:** change magnet size or stack, or add a small friction lip.
- **PLA cradle warps or cracks:** thicken walls, move to Tough PLA, or print in PETG elsewhere.
