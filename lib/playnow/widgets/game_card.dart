import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/game_model.dart';
import '../pages/game_details_page.dart';

/// Card displaying a game with key information
class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback? onTap;

  const GameCard({
    super.key,
    required this.game,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GameDetailsPage(gameId: game.id),
              ),
            );
          },
      borderRadius: BorderRadius.circular(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Fun Circle Badge - Full width at top
                if (game.isFunCircleOrganized)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.greenAccent.shade400.withValues(alpha: 0.9),
                          Colors.greenAccent.shade200.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.verified_rounded,
                          size: 15,
                          color: Colors.black87,
                        ),
                        const SizedBox(width: 7),
                        Text(
                          'FunCircle PlayTime',
                          style: TextStyle(
                            color: Colors.black87,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header row - Sport icon + Title + Arrow
                      Row(
                        children: [
                          // Sport icon
                          Icon(
                            _getSportIcon(),
                            color: _getSportColor(),
                            size: 20,
                          ),
                          const SizedBox(width: 10),

                          // Game title
                          Expanded(
                            child: Text(
                              game.autoTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),

                          // Arrow icon
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                  // Players count
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: game.isFull ? Colors.red : Colors.green,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '${game.currentPlayersCount} joined',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        ' • ${game.playersNeeded} needed',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                      // Organized by
                      Row(
                        children: [
                          Icon(
                            Icons.person_outline,
                            size: 16,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Organized by ',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            game.organizerName ?? 'Player',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),

                      // Divider
                      Container(
                        height: 1,
                        color: Colors.white.withValues(alpha: 0.1),
                      ),
                      const SizedBox(height: 14),

                      // Details grid
                      Row(
                        children: [
                          // Date & Time
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(Icons.calendar_today, game.formattedDate),
                                const SizedBox(height: 8),
                                _buildInfoRow(Icons.access_time, game.formattedTime),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Location & Level
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildInfoRow(Icons.location_on, game.locationDisplay),
                                const SizedBox(height: 8),
                                _buildInfoRow(
                                  Icons.bar_chart,
                                  game.skillLevel != null ? 'Level ${game.skillLevel}' : 'Open',
                                  textColor: _getLevelColor(game.skillLevel),
                                ),
                              ],
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

  Widget _buildInfoRow(IconData icon, String text, {Color? textColor}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: Colors.white.withValues(alpha: 0.5),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 13,
              color: textColor ?? Colors.white.withValues(alpha: 0.7),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Color _getSportColor() {
    switch (game.sportType) {
      case 'badminton':
        return Colors.purple;
      case 'pickleball':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  IconData _getSportIcon() {
    switch (game.sportType) {
      case 'badminton':
        return Icons.sports_tennis; // Badminton racket
      case 'pickleball':
        return Icons.sports_baseball; // Pickleball paddle
      default:
        return Icons.sports;
    }
  }

  Color _getLevelColor(int? level) {
    if (level == null) return Colors.white.withValues(alpha: 0.7);
    if (level <= 2) return Colors.green.shade300;
    if (level == 3) return Colors.yellow.shade400;
    return Colors.orange.shade400; // levels 4-5
  }
}
