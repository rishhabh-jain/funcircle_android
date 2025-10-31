import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:intl/intl.dart';
import '../../../models/play_friend.dart';

class PlayFriendCard extends StatelessWidget {
  final PlayFriend friend;
  final VoidCallback onToggleFavorite;
  final VoidCallback onViewProfile;
  final VoidCallback onSendMessage;

  const PlayFriendCard({
    super.key,
    required this.friend,
    required this.onToggleFavorite,
    required this.onViewProfile,
    required this.onSendMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
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
              borderRadius: BorderRadius.circular(24),
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
                    painter: _FriendCardPatternPainter(),
                  ),
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row - Avatar, Name, Favorite
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Avatar with glow and online indicator
                          _buildAvatar(),
                          const SizedBox(width: 16),

                          // Name and Level
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        friend.displayName,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.3,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    // Favorite Star
                                    GestureDetector(
                                      onTap: onToggleFavorite,
                                      child: Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          gradient: friend.isFavorite
                                              ? const LinearGradient(
                                                  colors: [Color(0xFFFFB300), Color(0xFFFFC107)],
                                                )
                                              : null,
                                          color: !friend.isFavorite
                                              ? Colors.white.withValues(alpha: 0.1)
                                              : null,
                                          shape: BoxShape.circle,
                                          boxShadow: friend.isFavorite
                                              ? [
                                                  BoxShadow(
                                                    color: Colors.amber.withValues(alpha: 0.5),
                                                    blurRadius: 12,
                                                    spreadRadius: 2,
                                                  ),
                                                ]
                                              : null,
                                        ),
                                        child: Icon(
                                          friend.isFavorite ? Icons.star : Icons.star_border,
                                          color: friend.isFavorite
                                              ? Colors.white
                                              : Colors.white.withValues(alpha: 0.6),
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),

                                // Level Badge
                                if (friend.friendLevel != null)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(
                                          Icons.auto_awesome,
                                          size: 14,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Level ${friend.friendLevel}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
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

                      const SizedBox(height: 20),

                      // Stats Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildStatChip(
                              Icons.sports_tennis,
                              '${friend.gamesPlayedTogether}',
                              'Games',
                              const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildStatChip(
                              Icons.calendar_today,
                              _getDaysSince(),
                              'Days',
                              const LinearGradient(
                                colors: [Color(0xFF2196F3), Color(0xFF64B5F6)],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Sports Played
                      if (friend.sportsPlayed.isNotEmpty) ...[
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: friend.sportsPlayed.map((sport) {
                            return Container(
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
                                  Icon(
                                    sport == 'Badminton'
                                        ? Icons.sports_tennis
                                        : Icons.sports_handball,
                                    size: 14,
                                    color: Colors.orange.withValues(alpha: 0.9),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    sport,
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Last Played Info
                      if (friend.lastPlayedAt != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
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
                                Icons.access_time,
                                size: 16,
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Last played ${_getLastPlayedText()}',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Action Buttons
                      Row(
                        children: [
                          // View Profile Button
                          Expanded(
                            child: GestureDetector(
                              onTap: onViewProfile,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.person_outline,
                                      size: 18,
                                      color: Colors.white.withValues(alpha: 0.9),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Profile',
                                      style: TextStyle(
                                        color: Colors.white.withValues(alpha: 0.9),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          // Message Button
                          Expanded(
                            child: GestureDetector(
                              onTap: onSendMessage,
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
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.message_outlined,
                                      size: 18,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Message',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
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

  Widget _buildAvatar() {
    return Stack(
      children: [
        // Glow effect
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.4),
                blurRadius: 20,
                spreadRadius: 5,
              ),
            ],
          ),
        ),
        // Avatar
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 3,
            ),
          ),
          child: CircleAvatar(
            radius: 35,
            backgroundColor: Colors.grey[800],
            backgroundImage: friend.friendImage != null
                ? CachedNetworkImageProvider(friend.friendImage!)
                : null,
            child: friend.friendImage == null
                ? const Icon(Icons.person, size: 35, color: Colors.white70)
                : null,
          ),
        ),
        // Online indicator (if recently active)
        if (friend.lastPlayedAt != null &&
            DateTime.now().difference(friend.lastPlayedAt!).inHours < 24)
          Positioned(
            right: 2,
            bottom: 2,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50),
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF121212),
                  width: 3,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.green.withValues(alpha: 0.5),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 18),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getDaysSince() {
    final days = DateTime.now().difference(friend.friendsSince).inDays;
    if (days < 30) return days.toString();
    if (days < 365) return '${(days / 30).floor()}M';
    return '${(days / 365).floor()}Y';
  }

  String _getLastPlayedText() {
    if (friend.lastPlayedAt == null) return 'Never';

    final difference = DateTime.now().difference(friend.lastPlayedAt!);

    if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()}w ago';
    } else {
      return DateFormat('MMM dd').format(friend.lastPlayedAt!);
    }
  }
}

class _FriendCardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.02);

    // Draw diagonal grid pattern
    for (int i = 0; i < 15; i++) {
      canvas.drawLine(
        Offset(size.width * (i * 0.1), 0),
        Offset(0, size.height * (i * 0.1)),
        paint,
      );
    }

    // Draw decorative circles
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.05);

    // Top right corner circle
    canvas.drawCircle(
      Offset(size.width - 40, 40),
      30,
      circlePaint,
    );

    // Bottom left corner circle
    canvas.drawCircle(
      Offset(40, size.height - 40),
      25,
      circlePaint,
    );

    // Subtle gradient overlay
    final gradientRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange.withValues(alpha: 0.03),
          Colors.transparent,
          Colors.blue.withValues(alpha: 0.02),
        ],
        stops: const [0.0, 0.5, 1.0],
      ).createShader(gradientRect);

    canvas.drawRect(gradientRect, gradientPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
