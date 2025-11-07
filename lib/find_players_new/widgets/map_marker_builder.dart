import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/skill_level.dart';

/// Utility class for building custom map markers
class MapMarkerBuilder {
  /// Create marker for available player with name, time, and level
  static Future<BitmapDescriptor> createPlayerMarker({
    required String? profilePictureUrl,
    required int? skillLevel,
    required String userName,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const markerSize = 100.0;
    const labelPadding = 8.0;

    // Get skill level info
    final skillLevelEnum =
        skillLevel != null ? SkillLevel.fromValue(skillLevel) : null;
    final skillText = skillLevelEnum?.label ?? 'New';

    // Create multi-line label with name, time, and level
    final namePainter = TextPainter(
      text: TextSpan(
        text: userName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    namePainter.layout();

    final timePainter = TextPainter(
      text: const TextSpan(
        text: 'Online now',
        style: TextStyle(
          color: Colors.white70,
          fontSize: 10,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    timePainter.layout();

    final levelPainter = TextPainter(
      text: TextSpan(
        text: 'Level: $skillText',
        style: TextStyle(
          color: skillLevelEnum != null
              ? _hexToColor(skillLevelEnum.hexColor)
              : Colors.grey,
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    levelPainter.layout();

    final maxWidth = [namePainter.width, timePainter.width, levelPainter.width]
        .reduce((a, b) => a > b ? a : b);
    final totalWidth = markerSize + labelPadding + maxWidth + 20;
    final totalHeight = markerSize + 15;

    // Draw shadow for 3D effect
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(
        const Offset(markerSize / 2 + 3, markerSize / 2 + 4), 38, shadowPaint);

    // Draw skill level color ring
    if (skillLevel != null) {
      final skillLevelEnum = SkillLevel.fromValue(skillLevel);
      final ringPaint = Paint()
        ..color = _hexToColor(skillLevelEnum.hexColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5.0;

      canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2),
        38,
        ringPaint,
      );
    }

    // Draw white background circle
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2), 34, bgPaint);

    // Draw profile picture or placeholder
    if (profilePictureUrl != null && profilePictureUrl.isNotEmpty) {
      try {
        final imageBytes = await _getImageBytes(profilePictureUrl);
        final codec = await ui.instantiateImageCodec(
          imageBytes,
          targetWidth: 60,
          targetHeight: 60,
        );
        final frame = await codec.getNextFrame();
        final image = frame.image;

        // Clip to circle and draw image
        canvas.save();
        final clipPath = Path()
          ..addOval(
            Rect.fromCircle(
                center: const Offset(markerSize / 2, markerSize / 2),
                radius: 32),
          );
        canvas.clipPath(clipPath);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromCircle(
              center: const Offset(markerSize / 2, markerSize / 2), radius: 32),
          Paint(),
        );
        canvas.restore();
      } catch (e) {
        print('Error loading profile image: $e');
        _drawPlaceholderIcon(canvas, markerSize);
      }
    } else {
      _drawPlaceholderIcon(canvas, markerSize);
    }

    // Draw 3D pointer at bottom with shadow
    final pointerShadowPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 24)
      ..lineTo(markerSize / 2 + 2, markerSize + 8)
      ..lineTo(markerSize / 2 + 12, markerSize - 24)
      ..close();
    canvas.drawPath(pointerShadowPath,
        Paint()..color = Colors.black.withValues(alpha: 0.2));

    final pointerPath = Path()
      ..moveTo(markerSize / 2 - 10, markerSize - 24)
      ..lineTo(markerSize / 2, markerSize + 3)
      ..lineTo(markerSize / 2 + 10, markerSize - 24)
      ..close();

    final pointerPaint = Paint()
      ..color = skillLevel != null
          ? _hexToColor(SkillLevel.fromValue(skillLevel).hexColor)
          : Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawPath(pointerPath, pointerPaint);

    // Draw text label to the right of marker with multiple lines
    final labelBg = Paint()
      ..color = Colors.black.withValues(alpha: 0.75)
      ..style = PaintingStyle.fill;
    final labelHeight = 48.0;
    final labelRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        markerSize + labelPadding,
        markerSize / 2 - labelHeight / 2,
        maxWidth + 16,
        labelHeight,
      ),
      const Radius.circular(10),
    );
    canvas.drawRRect(labelRect, labelBg);

    // Draw name
    namePainter.paint(
      canvas,
      Offset(
          markerSize + labelPadding + 8, markerSize / 2 - labelHeight / 2 + 6),
    );

    // Draw time
    timePainter.paint(
      canvas,
      Offset(
          markerSize + labelPadding + 8, markerSize / 2 - labelHeight / 2 + 22),
    );

    // Draw level
    levelPainter.paint(
      canvas,
      Offset(
          markerSize + labelPadding + 8, markerSize / 2 - labelHeight / 2 + 34),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(totalWidth.toInt(), totalHeight.toInt());
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

  /// Create 3D marker for venue with label and sport-specific styling
  static Future<BitmapDescriptor> createVenueMarker({
    required String venueName,
    required String? sportType,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const markerSize = 85.0;
    const labelPadding = 8.0;

    // Determine color and icon based on sport type
    Color pinColor;
    Color labelColor;
    IconData iconData;

    switch (sportType?.toLowerCase()) {
      case 'badminton':
        pinColor = const Color(0xFF00BFA5); // Teal/cyan for badminton
        labelColor = const Color(0xFF00BFA5);
        iconData = Icons.sports_tennis; // Racquet sports icon
        break;
      case 'pickleball':
        pinColor = const Color(0xFFFF9800); // Orange for pickleball
        labelColor = const Color(0xFFFF9800);
        iconData = Icons.sports_baseball; // Paddle sports icon
        break;
      case 'both':
        pinColor = const Color(0xFF9C27B0); // Purple for both sports
        labelColor = const Color(0xFF9C27B0);
        iconData = Icons.sports; // General sports icon
        break;
      default:
        pinColor = Colors.blue; // Default blue
        labelColor = Colors.blue;
        iconData = Icons.location_city;
    }

    // Create label text
    final labelPainter = TextPainter(
      text: TextSpan(
        text: venueName,
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
      maxLines: 1,
      ellipsis: '...',
    );
    labelPainter.layout(maxWidth: 150); // Limit width

    final totalWidth = markerSize + labelPadding + labelPainter.width + 20;
    final totalHeight = markerSize + 5;

    // Draw shadow for 3D effect
    final shadowPath = Path()
      ..addOval(Rect.fromCircle(
          center: const Offset(markerSize / 2 + 3, markerSize / 2.5 + 3),
          radius: 26))
      ..moveTo(markerSize / 2 - 10, markerSize / 1.8)
      ..lineTo(markerSize / 2 + 2, markerSize - 2)
      ..lineTo(markerSize / 2 + 12, markerSize / 1.8)
      ..close();
    canvas.drawPath(
        shadowPath,
        Paint()
          ..color = Colors.black.withValues(alpha: 0.3)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5));

    // Draw location pin shape with sport-specific color
    final pinPath = Path()
      ..addOval(Rect.fromCircle(
          center: const Offset(markerSize / 2, markerSize / 2.5), radius: 26))
      ..moveTo(markerSize / 2 - 10, markerSize / 1.8)
      ..lineTo(markerSize / 2, markerSize - 5)
      ..lineTo(markerSize / 2 + 10, markerSize / 1.8)
      ..close();

    final pinPaint = Paint()
      ..color = pinColor
      ..style = PaintingStyle.fill;
    canvas.drawPath(pinPath, pinPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(
        const Offset(markerSize / 2, markerSize / 2.5), 26, borderPaint);

    // Draw sport-specific icon in center
    _drawIcon(canvas, iconData, const Offset(markerSize / 2, markerSize / 2.5),
        Colors.white, 26);

    // Draw text label to the right of marker with sport-specific color
    final labelBg = Paint()
      ..color = labelColor.withValues(alpha: 0.9)
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

  /// Helper: Draw placeholder icon for missing profile picture
  static void _drawPlaceholderIcon(Canvas canvas, double size) {
    _drawIcon(
        canvas, Icons.person, Offset(size / 2, size / 2), Colors.grey, 40);
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

  /// Helper: Convert hex color to Color
  static Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Helper: Get image bytes from URL
  static Future<Uint8List> _getImageBytes(String url) async {
    try {
      final provider = CachedNetworkImageProvider(url);
      final imageStream = provider.resolve(const ImageConfiguration());
      final completer = Completer<ui.Image>();
      final listener = ImageStreamListener((ImageInfo info, bool _) {
        completer.complete(info.image);
      });
      imageStream.addListener(listener);
      final image = await completer.future;
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      return byteData!.buffer.asUint8List();
    } catch (e) {
      // If network image fails, return a placeholder
      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);
      const size = 60.0;
      final paint = Paint()..color = Colors.grey;
      canvas.drawCircle(const Offset(size / 2, size / 2), size / 2, paint);
      final picture = recorder.endRecording();
      final img = await picture.toImage(size.toInt(), size.toInt());
      final bytes = await img.toByteData(format: ui.ImageByteFormat.png);
      return bytes!.buffer.asUint8List();
    }
  }
}
