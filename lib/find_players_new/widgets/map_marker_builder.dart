import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Utility class for building custom map markers
class MapMarkerBuilder {
  // Cached badminton icon image
  static ui.Image? _badmintonIconImage;

  /// Load and cache the badminton icon from assets
  static Future<ui.Image?> _loadBadmintonIcon() async {
    if (_badmintonIconImage != null) return _badmintonIconImage;

    try {
      final ByteData data = await rootBundle.load('assets/images/badminton_icon.png');
      final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
      final frame = await codec.getNextFrame();
      _badmintonIconImage = frame.image;
      return _badmintonIconImage;
    } catch (e) {
      print('Error loading badminton icon: $e');
      return null;
    }
  }
  /// Create marker for available player with sport icon and green glow
  /// REDESIGNED: Simple, small, with green glowing circle and sport icon only
  static Future<BitmapDescriptor> createPlayerMarker({
    required String? profilePictureUrl,
    required int? skillLevel,
    required String userName,
    String sportType = 'badminton',
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 80.0; // Smaller size
    const center = Offset(size / 2, size / 2);

    // Draw green glowing effect (multiple layers for glow)
    for (int i = 3; i > 0; i--) {
      final glowPaint = Paint()
        ..color = const Color(0xFF4CAF50).withValues(alpha: 0.15 * i)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 8.0 * i);
      canvas.drawCircle(center, 20 + (i * 4), glowPaint);
    }

    // Draw outer green circle (bright green)
    final outerCirclePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 24, outerCirclePaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, 24, borderPaint);

    // Draw inner circle (slightly darker green)
    final innerCirclePaint = Paint()
      ..color = const Color(0xFF2E7D32)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 21, innerCirclePaint);

    // Draw custom sport icon in center
    if (sportType.toLowerCase() == 'pickleball') {
      _drawPickleballPaddle(canvas, center, Colors.white, 18);
    } else {
      _drawBadmintonShuttlecock(canvas, center, Colors.white, 18);
    }

    // Draw pulsing indicator dot (small dot at bottom right for "online" status)
    final indicatorPaint = Paint()
      ..color = const Color(0xFF00FF00) // Bright lime green
      ..style = PaintingStyle.fill
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(center.dx + 16, center.dy + 16), 5, indicatorPaint);

    // Add white border to indicator
    final indicatorBorderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;
    canvas.drawCircle(
        Offset(center.dx + 16, center.dy + 16), 5, indicatorBorderPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Create marker for player request with label
  static Future<BitmapDescriptor> createRequestMarker({
    required int playersNeeded,
    required int? skillLevel,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const markerSize = 90.0;
    const labelPadding = 8.0;

    // Create label text
    final labelText = 'Need $playersNeeded';
    final labelPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 3,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    final totalWidth = markerSize + labelPadding + labelPainter.width + 20;
    final totalHeight = markerSize + 12;

    // Draw shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(
        const Offset(markerSize / 2 + 3, markerSize / 2 + 4), 36, shadowPaint);

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2), 34, bgPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2), 34, borderPaint);

    // Draw icon in center
    _drawIcon(canvas, Icons.group_add,
        const Offset(markerSize / 2, markerSize / 2), Colors.white, 28);

    // Draw 3D pointer with shadow
    final pointerShadowPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 22)
      ..lineTo(markerSize / 2 + 2, markerSize + 8)
      ..lineTo(markerSize / 2 + 12, markerSize - 22)
      ..close();
    canvas.drawPath(pointerShadowPath,
        Paint()..color = Colors.black.withValues(alpha: 0.2));

    final pointerPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 22)
      ..lineTo(markerSize / 2, markerSize + 3)
      ..lineTo(markerSize / 2 + 10, markerSize - 22)
      ..close();
    canvas.drawPath(pointerPath, Paint()..color = Colors.orange);

    // Draw text label to the right of marker
    final labelBg = Paint()
      ..color = Colors.orange.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        markerSize + labelPadding,
        markerSize / 2 - 12,
        labelPainter.width + 12,
        24,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(labelRect, labelBg);

    labelPainter.paint(
      canvas,
      Offset(markerSize + labelPadding + 6,
          markerSize / 2 - labelPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Create circular marker for venue - small, simple, no label, properly anchored
  /// REDESIGNED: Small circular marker that stays in place when map moves
  static Future<BitmapDescriptor> createVenueMarker({
    required String venueName,
    required String? sportType,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 70.0; // Small size
    const center = Offset(size / 2, size / 2);

    // Determine color based on sport type
    Color pinColor;
    String sportTypeForIcon;

    switch (sportType?.toLowerCase()) {
      case 'badminton':
        pinColor = const Color(0xFF00BFA5); // Teal for badminton
        sportTypeForIcon = 'badminton';
        break;
      case 'pickleball':
        pinColor = const Color(0xFFFF9800); // Orange for pickleball
        sportTypeForIcon = 'pickleball';
        break;
      case 'both':
        pinColor = const Color(0xFF9C27B0); // Purple for both
        sportTypeForIcon = 'both';
        break;
      default:
        pinColor = const Color(0xFF2196F3); // Blue default
        sportTypeForIcon = 'badminton'; // default to badminton
    }

    // Draw shadow
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(center.dx + 2, center.dy + 2), 22, shadowPaint);

    // Draw outer circle with sport color
    final outerPaint = Paint()
      ..color = pinColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, 20, outerPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(center, 20, borderPaint);

    // Draw custom sport icon in center
    final badmintonIcon = await _loadBadmintonIcon();

    if (sportTypeForIcon == 'both') {
      // For venues with both sports, draw both icons smaller and side by side
      if (badmintonIcon != null) {
        _drawBadmintonIcon(canvas, Offset(center.dx - 6, center.dy), badmintonIcon, 12);
      } else {
        _drawBadmintonShuttlecock(canvas, Offset(center.dx - 6, center.dy), Colors.white, 12);
      }
      _drawPickleballPaddle(canvas, Offset(center.dx + 6, center.dy), Colors.white, 12);
    } else if (sportTypeForIcon == 'pickleball') {
      _drawPickleballPaddle(canvas, center, Colors.white, 16);
    } else {
      if (badmintonIcon != null) {
        _drawBadmintonIcon(canvas, center, badmintonIcon, 16);
      } else {
        _drawBadmintonShuttlecock(canvas, center, Colors.white, 16);
      }
    }

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Create 3D marker for game session with label
  static Future<BitmapDescriptor> createSessionMarker({
    required int currentPlayers,
    required int maxPlayers,
    required List<String?> playerPictures,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const markerSize = 95.0;
    const labelPadding = 8.0;

    // Create label text
    final labelText = 'Session $currentPlayers/$maxPlayers';
    final labelPainter = TextPainter(
      text: TextSpan(
        text: labelText,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              offset: Offset(1, 1),
              blurRadius: 3,
              color: Color.fromARGB(150, 0, 0, 0),
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    labelPainter.layout();

    final totalWidth = markerSize + labelPadding + labelPainter.width + 20;
    final totalHeight = markerSize + 12;

    // Draw shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(
        const Offset(markerSize / 2 + 3, markerSize / 2 + 4), 38, shadowPaint);

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2), 36, bgPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2), 36, borderPaint);

    // Draw icon in center
    _drawIcon(canvas, Icons.sports,
        const Offset(markerSize / 2, markerSize / 2), Colors.white, 30);

    // Draw 3D pointer with shadow
    final pointerShadowPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 23)
      ..lineTo(markerSize / 2 + 2, markerSize + 8)
      ..lineTo(markerSize / 2 + 12, markerSize - 23)
      ..close();
    canvas.drawPath(pointerShadowPath,
        Paint()..color = Colors.black.withValues(alpha: 0.2));

    final pointerPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 23)
      ..lineTo(markerSize / 2, markerSize + 3)
      ..lineTo(markerSize / 2 + 10, markerSize - 23)
      ..close();
    canvas.drawPath(pointerPath, Paint()..color = Colors.purple);

    // Draw text label to the right of marker
    final labelBg = Paint()
      ..color = Colors.purple.withValues(alpha: 0.9)
      ..style = PaintingStyle.fill;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        markerSize + labelPadding,
        markerSize / 2 - 12,
        labelPainter.width + 12,
        24,
      ),
      const Radius.circular(12),
    );
    canvas.drawRRect(labelRect, labelBg);

    labelPainter.paint(
      canvas,
      Offset(markerSize + labelPadding + 6,
          markerSize / 2 - labelPainter.height / 2),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.bytes(bytes!.buffer.asUint8List());
  }

  /// Helper: Draw icon on canvas
  static void _drawIcon(
      Canvas canvas, IconData icon, Offset center, Color color,
      [double iconSize = 30]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: iconSize,
          fontFamily: icon.fontFamily,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(center.dx - textPainter.width / 2,
          center.dy - textPainter.height / 2),
    );
  }

  /// Draw badminton icon from loaded image with white color
  static void _drawBadmintonIcon(
      Canvas canvas, Offset center, ui.Image image, double size) {
    // Calculate the destination rect (centered)
    final destRect = Rect.fromCenter(
      center: center,
      width: size * 2,
      height: size * 2,
    );

    // Source rect (full image)
    final srcRect = Rect.fromLTWH(
      0,
      0,
      image.width.toDouble(),
      image.height.toDouble(),
    );

    // Paint with white color blend to make the black icon white
    final paint = Paint()
      ..colorFilter = const ColorFilter.mode(
        Colors.white,
        BlendMode.srcIn,
      );

    canvas.drawImageRect(image, srcRect, destRect, paint);
  }

  /// Draw custom badminton shuttlecock icon - REDESIGNED for clarity (fallback)
  static void _drawBadmintonShuttlecock(
      Canvas canvas, Offset center, Color color, double size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // IMPROVED DESIGN: Simple, bold, instantly recognizable

    // Draw cork/rubber base (solid circle at bottom - more prominent)
    canvas.drawCircle(
      Offset(center.dx, center.dy + size * 0.35),
      size * 0.25,
      paint,
    );

    // Draw feather cone (wider, more distinct triangle)
    final featherPath = Path()
      ..moveTo(center.dx - size * 0.5, center.dy - size * 0.25) // Left point
      ..lineTo(center.dx, center.dy + size * 0.3) // Bottom center
      ..lineTo(center.dx + size * 0.5, center.dy - size * 0.25) // Right point
      ..close();
    canvas.drawPath(featherPath, strokePaint);

    // Fill the cone slightly for better visibility
    canvas.drawPath(
      featherPath,
      Paint()
        ..color = color.withValues(alpha: 0.3)
        ..style = PaintingStyle.fill,
    );

    // Draw bold center line (shuttlecock seam)
    canvas.drawLine(
      Offset(center.dx, center.dy - size * 0.25),
      Offset(center.dx, center.dy + size * 0.3),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    // Draw 2 angled lines on each side for feather detail (simplified, bolder)
    final featherStroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Left feathers
    canvas.drawLine(
      Offset(center.dx - size * 0.35, center.dy - size * 0.15),
      Offset(center.dx - size * 0.1, center.dy + size * 0.2),
      featherStroke,
    );

    // Right feathers
    canvas.drawLine(
      Offset(center.dx + size * 0.35, center.dy - size * 0.15),
      Offset(center.dx + size * 0.1, center.dy + size * 0.2),
      featherStroke,
    );
  }

  /// Draw custom pickleball paddle icon
  static void _drawPickleballPaddle(
      Canvas canvas, Offset center, Color color, double size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // Draw paddle face (rounded rectangle)
    final paddleFace = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, center.dy - size * 0.15),
        width: size * 0.8,
        height: size * 0.9,
      ),
      Radius.circular(size * 0.25),
    );
    canvas.drawRRect(paddleFace, strokePaint);

    // Draw handle
    final handleRect = Rect.fromCenter(
      center: Offset(center.dx, center.dy + size * 0.45),
      width: size * 0.3,
      height: size * 0.35,
    );
    canvas.drawRect(handleRect, paint);

    // Draw holes on paddle face (pickleball paddles have holes)
    final holeRadius = size * 0.08;
    final holePaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    // 3x3 grid of holes
    for (int row = 0; row < 3; row++) {
      for (int col = 0; col < 3; col++) {
        final holeX = center.dx - size * 0.25 + (col * size * 0.25);
        final holeY = center.dy - size * 0.35 + (row * size * 0.25);
        canvas.drawCircle(Offset(holeX, holeY), holeRadius, holePaint);
      }
    }
  }
}
