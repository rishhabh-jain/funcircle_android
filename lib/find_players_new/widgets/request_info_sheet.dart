import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/player_request_model.dart';
import '../models/skill_level.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

/// Bottom sheet showing player request information
class RequestInfoSheet extends StatefulWidget {
  final PlayerRequestModel request;
  final double? distanceKm;
  final String currentUserId;

  const RequestInfoSheet({
    super.key,
    required this.request,
    this.distanceKm,
    required this.currentUserId,
  });

  @override
  State<RequestInfoSheet> createState() => _RequestInfoSheetState();
}

class _RequestInfoSheetState extends State<RequestInfoSheet> {
  bool _isResponding = false;

  @override
  Widget build(BuildContext context) {
    final skillLevel = widget.request.skillLevel != null
        ? SkillLevel.fromValue(widget.request.skillLevel!)
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

            // Request header with creator info
            Row(
              children: [
                // Creator profile picture
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.orange, width: 2),
                  ),
                  child: ClipOval(
                    child: widget.request.userProfilePicture != null
                        ? CachedNetworkImage(
                            imageUrl: widget.request.userProfilePicture!,
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.person),
                          )
                        : const Icon(Icons.person, size: 30),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.request.userName ?? 'Unknown Player',
                        style: FlutterFlowTheme.of(context).titleMedium,
                      ),
                      Text(
                        'Looking for players',
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

            // Players needed badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.orange, width: 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.people, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Need ${widget.request.playersNeeded} Player${widget.request.playersNeeded > 1 ? 's' : ''}',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
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
                  .format(widget.request.scheduledTime),
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
              widget.request.sportType,
            ),
            const SizedBox(height: 12),

            if (skillLevel != null)
              _buildInfoRow(
                Icons.emoji_events,
                'Skill Level',
                skillLevel.label,
                valueColor: _hexToColor(skillLevel.hexColor),
              ),

            // Description
            if (widget.request.description != null) ...[
              const SizedBox(height: 20),
              Text(
                'Details',
                style: FlutterFlowTheme.of(context).titleSmall,
              ),
              const SizedBox(height: 8),
              Text(
                widget.request.description!,
                style: FlutterFlowTheme.of(context).bodyMedium,
              ),
            ],

            const SizedBox(height: 24),

            // Action button
            if (widget.request.userId != widget.currentUserId)
              FFButtonWidget(
                onPressed: _isResponding ? null : _handleInterested,
                text: 'I\'m Interested',
                icon: const Icon(Icons.thumb_up, size: 20),
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
          style: FlutterFlowTheme.of(context).bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: Colors.grey,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  color: valueColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
      ],
    );
  }

  Future<void> _handleInterested() async {
    setState(() => _isResponding = true);

    final success = await MapService.respondToRequest(
      requestId: widget.request.id,
      responderId: widget.currentUserId,
      message: 'I\'m interested in joining!',
    );

    if (mounted) {
      setState(() => _isResponding = false);
      Navigator.pop(context);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Response sent! The player will be notified.'
                : 'Failed to send response. Please try again.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
