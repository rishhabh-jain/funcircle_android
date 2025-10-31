import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import '../../models/booking.dart';
import '../../flutter_flow/flutter_flow_util.dart';

class BookingDetailScreen extends StatelessWidget {
  final Booking booking;

  const BookingDetailScreen({
    super.key,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPatternPainter(),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(context),

                  // Content
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      child: Column(
                        children: [
                          // Main Ticket Card
                          _buildTicketCard(),

                          const SizedBox(height: 24),

                          // Action Buttons
                          if (booking.canCancel)
                            _buildCancelButton(context),

                          if (booking.canRate)
                            _buildRateButton(context),

                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 8,
        left: 8,
        right: 20,
        bottom: 16,
      ),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          // Title
          const Text(
            'Booking Details',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard() {
    Color statusColor = _getStatusColor();

    return Stack(
      children: [
        // Main ticket container
        ClipPath(
          clipper: TicketClipper(),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.15),
                      Colors.white.withValues(alpha: 0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.2),
                    width: 1.5,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Stack(
                  children: [
                    // Decorative pattern overlay
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _TicketPatternPainter(),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header with status
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Game icon
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.orange.withValues(alpha: 0.3),
                                      Colors.orange.withValues(alpha: 0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.orange.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.sports_tennis,
                                  color: Colors.orange,
                                  size: 32,
                                ),
                              ),

                              // Status badge
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: statusColor.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: statusColor.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: statusColor,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      booking.statusDisplay.toUpperCase(),
                                      style: TextStyle(
                                        color: statusColor,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Game Title
                          Text(
                            booking.gameTitle,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),

                          const SizedBox(height: 8),

                          // Sport Type Badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              booking.gameSport.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),

                          // Dashed separator
                          _buildDashedLine(),

                          const SizedBox(height: 24),

                          // Details Grid
                          _buildDetailRow(
                            Icons.location_on,
                            'VENUE',
                            booking.venueName,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.place,
                            'LOCATION',
                            booking.venueLocation,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.calendar_today,
                            'DATE',
                            booking.formattedDate,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.access_time,
                            'TIME',
                            booking.formattedTime,
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow(
                            Icons.confirmation_number,
                            'TICKETS',
                            '${booking.totalTickets} ${booking.totalTickets == 1 ? "Ticket" : "Tickets"}',
                          ),

                          const SizedBox(height: 32),

                          // Dashed separator
                          _buildDashedLine(),

                          const SizedBox(height: 24),

                          // Amount section
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TOTAL AMOUNT',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.2,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.green.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(6),
                                      border: Border.all(
                                        color: Colors.green.withValues(alpha: 0.4),
                                      ),
                                    ),
                                    child: const Text(
                                      'PAID',
                                      style: TextStyle(
                                        color: Colors.green,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ShaderMask(
                                shaderCallback: (bounds) => const LinearGradient(
                                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                                ).createShader(bounds),
                                child: Text(
                                  '₹${booking.totalAmount.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 48,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // Booking ID
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'BOOKING ID',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Text(
                                  '#${booking.orderId}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    fontFamily: 'monospace',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Circular cutouts for ticket perforation effect
        Positioned(
          left: -10,
          top: 220,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -10,
          top: 220,
          child: Container(
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Color(0xFF121212),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor() {
    switch (booking.bookingStatus.toLowerCase()) {
      case 'confirmed':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      case 'completed':
        return const Color(0xFF4A9EFF);
      default:
        return Colors.grey;
    }
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.orange.withValues(alpha: 0.7),
          size: 20,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDashedLine() {
    return Row(
      children: List.generate(
        40,
        (index) => Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 2),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          // TODO: Implement cancel booking
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cancel booking feature coming soon'),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red.withValues(alpha: 0.2),
          foregroundColor: Colors.red,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.red.withValues(alpha: 0.5),
              width: 2,
            ),
          ),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.cancel_outlined),
            SizedBox(width: 8),
            Text(
              'Cancel Booking',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRateButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            // TODO: Implement rate booking
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Rate booking feature coming soon'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.star_outline),
              SizedBox(width: 8),
              Text(
                'Rate Game',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.03);

    // Draw circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * (0.2 + i * 0.2)),
        30 + i * 10,
        paint,
      );
    }

    // Draw lines
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i * 0.125)),
        Offset(size.width * 0.3, size.height * (i * 0.125)),
        paint,
      );
    }

    // Gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.orange.withValues(alpha: 0.02),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Ticket pattern overlay painter
class _TicketPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.05);

    // Draw diagonal lines
    for (int i = 0; i < 20; i++) {
      canvas.drawLine(
        Offset(size.width * (i * 0.1), 0),
        Offset(0, size.height * (i * 0.1)),
        paint,
      );
    }

    // Draw circles in corners
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.orange.withValues(alpha: 0.05);

    canvas.drawCircle(Offset(size.width - 50, 50), 30, circlePaint);
    canvas.drawCircle(Offset(50, size.height - 50), 40, circlePaint);
    canvas.drawCircle(Offset(size.width - 40, size.height - 60), 35, circlePaint);

    // Draw small dots pattern
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.03);

    for (int i = 0; i < 10; i++) {
      for (int j = 0; j < 15; j++) {
        canvas.drawCircle(
          Offset(size.width * (i * 0.12) + 20, size.height * (j * 0.08) + 20),
          2,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom clipper for ticket shape (optional, can be removed if not needed)
class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Start from top-left
    path.moveTo(0, 0);

    // Top edge
    path.lineTo(size.width, 0);

    // Right edge
    path.lineTo(size.width, size.height);

    // Bottom edge
    path.lineTo(0, size.height);

    // Left edge back to start
    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
