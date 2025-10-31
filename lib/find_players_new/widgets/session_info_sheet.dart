import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/game_session_model.dart';
import '../models/skill_level.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

/// Bottom sheet showing game session information
class SessionInfoSheet extends StatefulWidget {
  final GameSessionModel session;
  final double? distanceKm;
  final String currentUserId;

  const SessionInfoSheet({
    super.key,
    required this.session,
    this.distanceKm,
    required this.currentUserId,
  });

  @override
  State<SessionInfoSheet> createState() => _SessionInfoSheetState();
}

class _SessionInfoSheetState extends State<SessionInfoSheet> {
  bool _isJoining = false;

  @override
  Widget build(BuildContext context) {
    final skillLevel = widget.session.skillLevelRequired != null
        ? SkillLevel.fromValue(widget.session.skillLevelRequired!)
        : null;

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

            // Session header
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.purple, width: 2),
                  ),
                  child: const Icon(
                    Icons.sports,
                    color: Colors.purple,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.session.sessionType.toUpperCase()} Game Session',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      Text(
                        'by ${widget.session.creatorName ?? 'Unknown'}',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Players status badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.session.isFull
                      ? Colors.red.withOpacity(0.1)
                      : Colors.purple.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: widget.session.isFull ? Colors.red : Colors.purple,
                    width: 2,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      widget.session.isFull ? Icons.people : Icons.group_add,
                      color: widget.session.isFull ? Colors.red : Colors.purple,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${widget.session.joinedPlayersCount}/${widget.session.maxPlayers} Players',
                      style: TextStyle(
                        color:
                            widget.session.isFull ? Colors.red : Colors.purple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    if (!widget.session.isFull) ...[
                      const SizedBox(width: 8),
                      Text(
                        '(${widget.session.slotsRemaining} slots left)',
                        style: TextStyle(
                          color: Colors.purple.withOpacity(0.7),
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
              'When',
              DateFormat('MMM dd, yyyy • hh:mm a')
                  .format(widget.session.scheduledTime),
            ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.access_time,
              'Duration',
              '${widget.session.durationMinutes} minutes',
            ),
            const SizedBox(height: 12),

            if (widget.distanceKm != null)
              _buildInfoRow(
                Icons.location_on,
                'Distance',
                LocationService.formatDistance(widget.distanceKm!),
              ),
            const SizedBox(height: 12),

            _buildInfoRow(
              Icons.sports,
              'Sport',
              widget.session.sportType,
            ),
            const SizedBox(height: 12),

            if (skillLevel != null)
              _buildInfoRow(
                Icons.emoji_events,
                'Skill Level',
                skillLevel.label,
                valueColor: _hexToColor(skillLevel.hexColor),
              ),
            const SizedBox(height: 12),

            if (widget.session.costPerPlayer != null)
              _buildInfoRow(
                Icons.currency_rupee,
                'Cost',
                '₹${widget.session.costPerPlayer!.toStringAsFixed(0)} per player',
                valueColor: Colors.green,
              ),

            // Notes
            if (widget.session.notes != null) ...[
              const SizedBox(height: 20),
              Text(
                'Notes',
                style: FlutterFlowTheme.of(context).titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                widget.session.notes!,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],

            const SizedBox(height: 24),

            // Action button
            if (widget.session.creatorId != widget.currentUserId &&
                widget.session.isOpen)
              FFButtonWidget(
                onPressed: _isJoining ? null : _handleJoinSession,
                text: _isJoining ? 'Joining...' : 'Join Session',
                icon: const Icon(Icons.group_add, size: 20),
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
            else if (widget.session.isFull)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: const Text(
                  'Session Full',
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

  Future<void> _handleJoinSession() async {
    setState(() => _isJoining = true);

    final success = await MapService.joinGameSession(
      sessionId: widget.session.id,
      userId: widget.currentUserId,
    );

    if (mounted) {
      setState(() => _isJoining = false);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Successfully joined the session!'
                : 'Failed to join session. It may be full or closed.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
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
          style: TextStyle(
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

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
