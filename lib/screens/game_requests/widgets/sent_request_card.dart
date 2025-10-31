import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import '../../../models/game_request.dart';

class SentRequestCard extends StatelessWidget {
  final GameRequest request;
  final VoidCallback onCancel;

  const SentRequestCard({
    super.key,
    required this.request,
    required this.onCancel,
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
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
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
                                  color: Colors.blue.withValues(alpha: 0.2),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: CircleAvatar(
                              radius: 32,
                              backgroundColor: Colors.grey[800],
                              backgroundImage: request.receiverImage != null
                                  ? CachedNetworkImageProvider(request.receiverImage!)
                                  : null,
                              child: request.receiverImage == null
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
                                  request.receiverName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.3,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                if (request.receiverLevel != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.withValues(alpha: 0.2),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: Colors.blue.withValues(alpha: 0.3),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.star, size: 12, color: Colors.blue),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Level ${request.receiverLevel}',
                                          style: const TextStyle(
                                            color: Colors.blue,
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
                              color: Colors.blue,
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

                      // Time Info and Cancel Button
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
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

                          // Cancel Button (only for pending requests)
                          if (request.isPending)
                            GestureDetector(
                              onTap: onCancel,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.red.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.red.withValues(alpha: 0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.close,
                                      size: 16,
                                      color: Colors.red,
                                    ),
                                    const SizedBox(width: 4),
                                    const Text(
                                      'Cancel',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
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
    IconData? icon;

    switch (request.status.toLowerCase()) {
      case 'pending':
        chipColor = Colors.orange;
        icon = Icons.pending_outlined;
        break;
      case 'accepted':
        chipColor = Colors.green;
        icon = Icons.check_circle_outline;
        break;
      case 'rejected':
        chipColor = Colors.red;
        icon = Icons.cancel_outlined;
        break;
      case 'cancelled':
        chipColor = Colors.grey;
        icon = Icons.remove_circle_outline;
        break;
      default:
        chipColor = Colors.grey;
        icon = Icons.help_outline;
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            request.statusDisplay,
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ],
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

    // Draw diagonal lines (opposite direction from received card)
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(size.width, size.height * (i * 0.15)),
        Offset(size.width * (1 - i * 0.15), 0),
        paint,
      );
    }

    // Draw corner circle
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.blue.withValues(alpha: 0.05);

    canvas.drawCircle(
      Offset(30, 30),
      25,
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
