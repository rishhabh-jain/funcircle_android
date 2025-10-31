import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../../models/game_request.dart';

class ReceivedRequestCard extends StatelessWidget {
  final GameRequest request;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const ReceivedRequestCard({
    super.key,
    required this.request,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
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
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Stack(
              children: [
                // Decorative pattern overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: _CardPatternPainter(),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User Info Row
                      Row(
                        children: [
                          // Avatar with glow effect
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.orange.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey[800],
                              backgroundImage: request.senderImage != null
                                  ? CachedNetworkImageProvider(request.senderImage!)
                                  : null,
                              child: request.senderImage == null
                                  ? const Icon(Icons.person, size: 32, color: Colors.white70)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Name and Level
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.senderName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (request.senderLevel != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, size: 12, color: Colors.white),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Level ${request.senderLevel}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),

                          // Status Chip
                          _buildStatusChip(),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Sport Type Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.sports_tennis,
                              size: 16,
                              color: Colors.orange,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              request.sportType,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Message
                      if (request.message != null && request.message!.isNotEmpty) ...[
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.chat_bubble_outline,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  request.message!,
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontSize: 14,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Venue and Time Info
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          if (request.venueName != null) ...[
                            Icon(
                              Icons.location_on_outlined,
                              size: 16,
                              color: Colors.white.withValues(alpha: 0.6),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                request.venueName!,
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Icon(
                            Icons.access_time_outlined,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            request.timeAgo,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.7),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      // Action Buttons (only for pending requests)
                      if (request.isPending) ...[
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            // Reject Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onReject,
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.red.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Accept Button
                            Expanded(
                              child: GestureDetector(
                                onTap: onAccept,
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.orange.withValues(alpha: 0.4),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color chipColor;
    switch (request.status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        break;
      case 'accepted':
        chipColor = Colors.green;
        break;
      case 'rejected':
        chipColor = Colors.red;
        break;
      case 'cancelled':
        chipColor = Colors.grey;
        break;
      default:
        chipColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: chipColor.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
      child: Text(
        request.statusDisplay,
        style: TextStyle(
          color: chipColor,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.02);

    // Draw diagonal lines
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(size.width * (i * 0.15), 0),
        Offset(0, size.height * (i * 0.15)),
        paint,
      );
    }

    // Draw corner circle
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.05);

    canvas.drawCircle(
      Offset(size.width - 30, 30),
      25,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
