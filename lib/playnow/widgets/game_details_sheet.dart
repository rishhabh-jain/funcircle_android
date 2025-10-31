import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';

/// Bottom sheet showing full game details with join functionality
class GameDetailsSheet extends StatefulWidget {
  final Game game;
  final VoidCallback? onGameUpdated;

  const GameDetailsSheet({
    super.key,
    required this.game,
    this.onGameUpdated,
  });

  @override
  State<GameDetailsSheet> createState() => _GameDetailsSheetState();
}

class _GameDetailsSheetState extends State<GameDetailsSheet> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final isCreator = widget.game.createdBy == currentUserUid;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: _getSportColor().withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: _getSportColor(), width: 2),
                  ),
                  child: Icon(
                    Icons.sports,
                    color: _getSportColor(),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.game.autoTitle,
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      if (isCreator)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'Your Game',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                // Share button
                IconButton(
                  onPressed: _handleShareGame,
                  icon: const Icon(Icons.share),
                  color: FlutterFlowTheme.of(context).primary,
                  tooltip: 'Share Game',
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Players status badge
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.game.isFull
                      ? Colors.red.withValues(alpha: 0.1)
                      : Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.game.isFull ? Colors.red : Colors.green,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.game.isFull ? Icons.people : Icons.group_add,
                      color: widget.game.isFull ? Colors.red : Colors.green,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.game.currentPlayersCount}/${widget.game.playersNeeded} Players',
                      style: TextStyle(
                        color: widget.game.isFull ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!widget.game.isFull) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.game.slotsRemaining} slots left)',
                        style: TextStyle(
                          color: Colors.green.withValues(alpha: 0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Details
            _buildInfoRow(
              Icons.calendar_today,
              'Date',
              widget.game.formattedDate,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.access_time,
              'Time',
              widget.game.formattedTime,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.location_on,
              'Location',
              widget.game.locationDisplay,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.sports,
              'Sport',
              widget.game.sportType == 'badminton' ? 'Badminton' : 'Pickleball',
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.groups,
              'Game Type',
              _getGameTypeLabel(widget.game.gameType),
            ),
            const SizedBox(height: 12),

            if (widget.game.skillLevel != null)
              _buildInfoRow(
                Icons.emoji_events,
                'Skill Level',
                'Level ${widget.game.skillLevel}',
                valueColor: Colors.orange,
              ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.currency_rupee,
              'Cost',
              widget.game.costDisplay,
              valueColor: widget.game.isFree ? Colors.green : Colors.orange,
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.how_to_reg,
              'Join Type',
              widget.game.joinType == 'auto' ? 'Auto Join' : 'Request to Join',
            ),

            // Special badges
            if (widget.game.isVenueBooked ||
                widget.game.isWomenOnly ||
                widget.game.isMixedOnly) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  if (widget.game.isVenueBooked)
                    _buildBadge('Venue Booked', Icons.check_circle, Colors.green),
                  if (widget.game.isWomenOnly)
                    _buildBadge('Women Only', Icons.female, Colors.pink),
                  if (widget.game.isMixedOnly)
                    _buildBadge('Mixed Only', Icons.people, Colors.blue),
                ],
              ),
            ],

            // Description
            if (widget.game.description != null) ...[
              const SizedBox(height: 20),
              Text(
                'Description',
                style: FlutterFlowTheme.of(context).titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                widget.game.description!,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],

            const SizedBox(height: 24),

            // Chat button for participants
            if (widget.game.chatRoomId != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    context.pushNamed(
                      'ChatRoomWidget',
                      queryParameters: {
                        'roomId': widget.game.chatRoomId!,
                      },
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Game Chat'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: FlutterFlowTheme.of(context).primary,
                    side: BorderSide(
                      color: FlutterFlowTheme.of(context).primary,
                      width: 2,
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                ),
              ),

            // Action buttons
            if (!isCreator && widget.game.status == 'open' && !widget.game.isFull)
              FFButtonWidget(
                onPressed: _isLoading ? null : _handleJoinGame,
                text: _isLoading
                    ? 'Loading...'
                    : widget.game.joinType == 'auto'
                        ? 'Join Game'
                        : 'Request to Join',
                icon: Icon(
                  widget.game.joinType == 'auto' ? Icons.group_add : Icons.send,
                  size: 20,
                ),
                options: FFButtonOptions(
                  width: double.infinity,
                  height: 50,
                  color: FlutterFlowTheme.of(context).primary,
                  textStyle: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                      ),
                  elevation: 2,
                  borderRadius: BorderRadius.circular(25),
                  disabledColor: Colors.grey,
                ),
              )
            else if (widget.game.isFull)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'Game Full',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    IconData icon,
    String label,
    String value, {
    Color? valueColor,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.grey),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: Colors.grey,
            fontSize: 14,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
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

  String _getGameTypeLabel(String gameType) {
    switch (gameType) {
      case 'singles':
        return 'Singles';
      case 'doubles':
        return 'Doubles';
      case 'mixed_doubles':
        return 'Mixed Doubles';
      default:
        return gameType;
    }
  }

  Color _getSportColor() {
    switch (widget.game.sportType) {
      case 'badminton':
        return Colors.purple;
      case 'pickleball':
        return Colors.teal;
      default:
        return Colors.blue;
    }
  }

  Future<void> _handleJoinGame() async {
    if (widget.game.joinType == 'request') {
      // Show message input dialog
      await _showRequestDialog();
    } else {
      // Auto join
      await _joinGame(null);
    }
  }

  Future<void> _showRequestDialog() async {
    final messageController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Request to Join'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send a message to the game creator:'),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              decoration: const InputDecoration(
                hintText: 'Optional message...',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Send Request'),
          ),
        ],
      ),
    );

    if (result == true) {
      await _joinGame(messageController.text.isEmpty ? null : messageController.text);
    }
  }

  Future<void> _joinGame(String? message) async {
    setState(() => _isLoading = true);

    final result = await GameService.joinGame(
      gameId: widget.game.id,
      userId: currentUserUid,
      message: message,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
        ),
      );

      if (result.success) {
        widget.onGameUpdated?.call();
      }
    }
  }

  Future<void> _handleShareGame() async {
    // Create deep link URL
    final gameUrl = 'https://funcircle.page.link/?link=https://funcircle.com/game/${widget.game.id}&apn=com.funcircle.app&ibi=com.funcircle.app';

    // Create share text
    final shareText = '''
🎮 Join my ${widget.game.sportType == 'badminton' ? 'Badminton' : 'Pickleball'} game!

${widget.game.autoTitle}

📍 ${widget.game.locationDisplay}
📅 ${widget.game.formattedDate}
⏰ ${widget.game.formattedTime}
👥 ${widget.game.currentPlayersCount}/${widget.game.playersNeeded} players
${widget.game.isFree ? '💵 Free' : '💵 ${widget.game.costDisplay}'}

Tap the link to join: $gameUrl
''';

    try {
      await Share.share(
        shareText,
        subject: 'Join my game on FunCircle',
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to share game'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
