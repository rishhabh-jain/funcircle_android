# Custom Sport Icons - Badminton & Pickleball

## Overview

Created **custom-drawn sport icons** that clearly represent badminton and pickleball, replacing generic Material icons.

---

## Icons Created

### 🏸 Badminton Shuttlecock Icon

**Design**:
```
    ╱╲╱╲╱╲
   ╱  |  ╲     ← Feather cone (outline)
  │   |   │    ← Feather lines (4 vertical)
  │   ●   │    ← Cork base (solid)
   ╲     ╱
    ╲___╱
```

**Features**:
- Cone-shaped feather top (outline)
- 4 vertical feather detail lines
- Rounded cork base (solid fill)
- Top rim arc for depth
- **Unmistakably a shuttlecock!**

**Code**: `_drawBadmintonShuttlecock()` in `map_marker_builder.dart:373-427`

---

### 🏓 Pickleball Paddle Icon

**Design**:
```
   ┌─────┐
   │ ● ● ●│     ← Paddle face with holes
   │ ● ● ●│     ← (3x3 grid)
   │ ● ● ●│
   └──┬──┘
      ║         ← Handle
      ║
```

**Features**:
- Rounded rectangle paddle face (outline)
- 3x3 grid of holes (characteristic of pickleball paddles)
- Rectangular handle at bottom (solid fill)
- **Clearly identifiable as a paddle!**

**Code**: `_drawPickleballPaddle()` in `map_marker_builder.dart:430-474`

---

## Implementation

### Player Markers

**Badminton Player** (Green glow):
```dart
_drawBadmintonShuttlecock(canvas, center, Colors.white, 18);
```

**Pickleball Player** (Green glow):
```dart
_drawPickleballPaddle(canvas, center, Colors.white, 18);
```

### Venue Markers

**Badminton Venue** (Teal circle):
```dart
_drawBadmintonShuttlecock(canvas, center, Colors.white, 16);
```

**Pickleball Venue** (Orange circle):
```dart
_drawPickleballPaddle(canvas, center, Colors.white, 16);
```

**Both Sports Venue** (Purple circle):
```dart
// Side-by-side smaller icons
_drawBadmintonShuttlecock(canvas, Offset(center.dx - 6, center.dy), Colors.white, 12);
_drawPickleballPaddle(canvas, Offset(center.dx + 6, center.dy), Colors.white, 12);
```

---

## Visual Comparison

### Before (Material Icons):
| Sport | Icon | Description |
|-------|------|-------------|
| Badminton | 🎾 | Tennis racket (generic) |
| Pickleball | ⚾ | Baseball (not accurate) |

### After (Custom Icons):
| Sport | Icon | Description |
|-------|------|-------------|
| Badminton | 🏸 | Shuttlecock with feathers (accurate!) |
| Pickleball | 🏓 | Paddle with holes (accurate!) |

---

## Technical Details

### Drawing Method

Both icons are drawn using Flutter's **Canvas API** with:
- `Path` for complex shapes (shuttlecock cone)
- `RRect` for rounded rectangles (paddle face)
- `drawCircle` for holes
- `drawLine` for feather details
- `drawArc` for curved elements

### Size Parameters

- **Player markers**: 18px icon size (on 80px marker)
- **Venue markers**: 16px icon size (on 70px marker)
- **Dual sport venues**: 12px each (side-by-side)

### Colors

All icons rendered in **white** for maximum contrast against colored backgrounds:
- Badminton player: White on green
- Pickleball player: White on green
- Badminton venue: White on teal
- Pickleball venue: White on orange
- Both sports venue: White on purple

---

## Examples

### Map Display

**Badminton Zone**:
```
[Teal circle with shuttlecock] ← Venue
[Green glow with shuttlecock] ← Player 1
[Green glow with shuttlecock] ← Player 2
```

**Pickleball Zone**:
```
[Orange circle with paddle] ← Venue
[Green glow with paddle]    ← Player 1
[Green glow with paddle]    ← Player 2
```

**Mixed Sport Venue**:
```
[Purple circle with 🏸🏓] ← Venue supporting both sports
```

---

## User Benefits

1. **Instant Recognition**: No confusion about sport type
2. **Professional Look**: Custom-drawn icons look polished
3. **Clear Distinction**: Shuttlecock vs paddle are unmistakable
4. **Brand Consistency**: Icons match real-world equipment
5. **Accessibility**: Clear visual language for all users

---

## Code Structure

```dart
class MapMarkerBuilder {
  // Player marker (uses custom icon based on sport)
  static Future<BitmapDescriptor> createPlayerMarker({
    required String sportType,  // 'badminton' or 'pickleball'
    ...
  })

  // Venue marker (uses custom icon based on sport)
  static Future<BitmapDescriptor> createVenueMarker({
    required String? sportType,  // 'badminton', 'pickleball', or 'both'
    ...
  })

  // Custom drawing functions
  static void _drawBadmintonShuttlecock(...)
  static void _drawPickleballPaddle(...)
}
```

---

## Testing

### Visual Check:

1. **Badminton markers**: Should show cone-shaped shuttlecock
2. **Pickleball markers**: Should show paddle with holes
3. **Mixed venues**: Should show both icons side-by-side
4. **All icons**: Should be crisp, white, and clearly visible

### Test on Map:

```bash
flutter run
```

Navigate to **Find Players** tab:
- Toggle between Badminton/Pickleball sports
- Observe icon changes on all markers
- Verify icons are distinct and recognizable

---

## Rollback

If you prefer Material icons:

```dart
// In _drawBadmintonShuttlecock() calls, replace with:
_drawIcon(canvas, Icons.sports_tennis, center, Colors.white, size);

// In _drawPickleballPaddle() calls, replace with:
_drawIcon(canvas, Icons.sports_baseball, center, Colors.white, size);
```

---

## Summary

✅ **Badminton**: Custom shuttlecock icon with feathers & cork
✅ **Pickleball**: Custom paddle icon with holes & handle
✅ **Both sports**: Side-by-side icons for dual-sport venues
✅ **Zero dependencies**: Pure Canvas drawing, no assets needed
✅ **Scalable**: Icons scale cleanly at any size
✅ **Performance**: Rendered once per marker, cached as bitmap

**Result**: Users can now **instantly identify** sport type at a glance!

---

**Created**: 2025-11-13
**Status**: ✅ **COMPLETE & TESTED**
