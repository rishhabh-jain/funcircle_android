import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../models/game_model.dart';

/// Card displaying a game with key information
class GameCard extends StatelessWidget {
  final Game game;
  final VoidCallback onTap;
  final bool showJoinButton;
  final VoidCallback? onJoinTap;

  const GameCard({
    super.key,
    required this.game,
    required this.onTap,
    this.showJoinButton = true,
    this.onJoinTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Sport icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: _getSportColor().withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.sports,
                      color: _getSportColor(),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Game info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          game.autoTitle,
                          style: FlutterFlowTheme.of(context).titleMedium.override(
                                fontFamily: 'Readex Pro',
                                fontSize: 16,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          game.locationDisplay,
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  // Status badge
                  _buildStatusBadge(),
                ],
              ),
              const SizedBox(height: 16),

              // Details row
              Wrap(
                spacing: 16,
                runSpacing: 8,
                children: [
                  _buildDetailChip(
                    Icons.calendar_today,
                    game.formattedDate,
                  ),
                  _buildDetailChip(
                    Icons.access_time,
                    game.formattedTime,
                  ),
                  _buildDetailChip(
                    Icons.people,
                    '${game.currentPlayersCount}/${game.playersNeeded}',
                    color: game.isFull ? Colors.red : Colors.green,
                  ),
                  if (!game.isFree)
                    _buildDetailChip(
                      Icons.currency_rupee,
                      game.costDisplay,
                      color: Colors.orange,
                    ),
                ],
              ),

              // Join button
              if (showJoinButton && !game.isFull && game.status == 'open') ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: onJoinTap ?? onTap,
                    icon: Icon(
                      game.joinType == 'auto' ? Icons.group_add : Icons.send,
                      size: 18,
                    ),
                    label: Text(
                      game.joinType == 'auto' ? 'Join Game' : 'Request to Join',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: FlutterFlowTheme.of(context).primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge() {
    Color color;
    String text;
    IconData icon;

    switch (game.status) {
      case 'full':
        color = Colors.red;
        text = 'Full';
        icon = Icons.people;
        break;
      case 'in_progress':
        color = Colors.orange;
        text = 'In Progress';
        icon = Icons.play_arrow;
        break;
      case 'completed':
        color = Colors.grey;
        text = 'Completed';
        icon = Icons.check;
        break;
      case 'cancelled':
        color = Colors.grey;
        text = 'Cancelled';
        icon = Icons.cancel;
        break;
      default: // open
        color = Colors.green;
        text = '${game.slotsRemaining} slots';
        icon = Icons.group_add;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String text, {Color? color}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color ?? Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            color: color ?? Colors.grey[700],
            fontWeight: FontWeight.w500,
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
}
