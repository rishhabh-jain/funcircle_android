import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/skill_level.dart';

/// Utility class for building custom map markers
class MapMarkerBuilder {
  /// Create marker for available player
  static Future<BitmapDescriptor> createPlayerMarker({
    required String? profilePictureUrl,
    required int? skillLevel,
    required String userName,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 120.0;

    // Draw skill level color ring
    if (skillLevel != null) {
      final skillLevelEnum = SkillLevel.fromValue(skillLevel);
      final ringPaint = Paint()
        ..color = _hexToColor(skillLevelEnum.hexColor)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.0;

      canvas.drawCircle(
        const Offset(size / 2, size / 2),
        40,
        ringPaint,
      );
    }

    // Draw white background circle
    final bgPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), 35, bgPaint);

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
                center: const Offset(size / 2, size / 2), radius: 33),
          );
        canvas.clipPath(clipPath);
        canvas.drawImageRect(
          image,
          Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
          Rect.fromCircle(center: const Offset(size / 2, size / 2), radius: 33),
          Paint(),
        );
        canvas.restore();
      } catch (e) {
        print('Error loading profile image: $e');
        _drawPlaceholderIcon(canvas, size);
      }
    } else {
      _drawPlaceholderIcon(canvas, size);
    }

    // Draw pointer at bottom
    final pointerPath = Path()
      ..moveTo(size / 2 - 10, size - 25)
      ..lineTo(size / 2, size)
      ..lineTo(size / 2 + 10, size - 25)
      ..close();

    final pointerPaint = Paint()
      ..color = skillLevel != null
          ? _hexToColor(SkillLevel.fromValue(skillLevel).hexColor)
          : Colors.green
      ..style = PaintingStyle.fill;
    canvas.drawPath(pointerPath, pointerPaint);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), (size + 5).toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create marker for player request
  static Future<BitmapDescriptor> createRequestMarker({
    required int playersNeeded,
    required int? skillLevel,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 100.0;

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.orange
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), 40, bgPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(const Offset(size / 2, size / 2), 40, borderPaint);

    // Draw text (players needed)
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Need\n$playersNeeded',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
          height: 1.2,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );

    // Draw pointer
    final pointerPath = Path()
      ..moveTo(size / 2 - 10, size - 20)
      ..lineTo(size / 2, size)
      ..lineTo(size / 2 + 10, size - 20)
      ..close();
    canvas.drawPath(pointerPath, Paint()..color = Colors.orange);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), (size + 5).toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create marker for venue
  static Future<BitmapDescriptor> createVenueMarker() async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 80.0;

    // Draw location pin shape
    final pinPath = Path()
      ..addOval(
          Rect.fromCircle(center: const Offset(size / 2, size / 3), radius: 25))
      ..moveTo(size / 2 - 10, size / 2)
      ..lineTo(size / 2, size - 5)
      ..lineTo(size / 2 + 10, size / 2)
      ..close();

    final pinPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;
    canvas.drawPath(pinPath, pinPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0;
    canvas.drawCircle(const Offset(size / 2, size / 3), 25, borderPaint);

    // Draw icon in center
    _drawIcon(canvas, Icons.location_city, const Offset(size / 2, size / 3),
        Colors.white);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Create marker for game session
  static Future<BitmapDescriptor> createSessionMarker({
    required int currentPlayers,
    required int maxPlayers,
    required List<String?> playerPictures,
  }) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 120.0;

    // Draw background circle
    final bgPaint = Paint()
      ..color = Colors.purple
      ..style = PaintingStyle.fill;
    canvas.drawCircle(const Offset(size / 2, size / 2), 45, bgPaint);

    // Draw white border
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    canvas.drawCircle(const Offset(size / 2, size / 2), 45, borderPaint);

    // Draw session info text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Session\n$currentPlayers/$maxPlayers',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
          height: 1.3,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        size / 2 - textPainter.width / 2,
        size / 2 - textPainter.height / 2,
      ),
    );

    // Draw pointer
    final pointerPath = Path()
      ..moveTo(size / 2 - 12, size - 25)
      ..lineTo(size / 2, size)
      ..lineTo(size / 2 + 12, size - 25)
      ..close();
    canvas.drawPath(pointerPath, Paint()..color = Colors.purple);

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), (size + 5).toInt());
    final bytes = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(bytes!.buffer.asUint8List());
  }

  /// Helper: Draw placeholder icon for missing profile picture
  static void _drawPlaceholderIcon(Canvas canvas, double size) {
    _drawIcon(canvas, Icons.person, Offset(size / 2, size / 2), Colors.grey);
  }

  /// Helper: Draw icon on canvas
  static void _drawIcon(
      Canvas canvas, IconData icon, Offset center, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: String.fromCharCode(icon.codePoint),
        style: TextStyle(
          fontSize: 30,
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
