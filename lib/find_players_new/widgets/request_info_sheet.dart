import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/player_request_model.dart';
import '../models/skill_level.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';
import '../services/quick_match_service.dart';
import 'edit_request_dialog.dart';

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
  bool _hasAlreadyResponded = false;
  bool _isCheckingResponse = true;
  List<Map<String, dynamic>> _interestedUsers = [];
  bool _isLoadingInterestedUsers = false;

  @override
  void initState() {
    super.initState();
    if (widget.request.userId == widget.currentUserId) {
      // User is the creator, load interested users
      _loadInterestedUsers();
    } else {
      // User is not the creator, check if they already responded
      _checkIfAlreadyResponded();
    }
  }

  Future<void> _loadInterestedUsers() async {
    setState(() => _isLoadingInterestedUsers = true);

    final users = await MapService.getInterestedUsers(
      requestId: widget.request.id,
    );

    if (mounted) {
      setState(() {
        _interestedUsers = users;
        _isLoadingInterestedUsers = false;
        _isCheckingResponse = false;
      });
    }
  }

  Future<void> _checkIfAlreadyResponded() async {
    final hasResponded = await MapService.hasUserRespondedToRequest(
      requestId: widget.request.id,
      userId: widget.currentUserId,
    );

    if (mounted) {
      setState(() {
        _hasAlreadyResponded = hasResponded;
        _isCheckingResponse = false;
      });
    }
  }

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
                        widget.request.userId == widget.currentUserId
                            ? 'Your Request'
                            : 'Looking for players',
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: widget.request.userId == widget.currentUserId
                                  ? Colors.orange
                                  : Colors.grey,
                            ),
                      ),
                    ],
                  ),
                ),
                // Edit and Cancel buttons for creator
                if (widget.request.userId == widget.currentUserId &&
                    widget.request.status != 'fulfilled' &&
                    widget.request.status != 'expired' &&
                    widget.request.status != 'cancelled') ...[
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    onPressed: _showEditRequestDialog,
                    color: Colors.blue,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.blue.withValues(alpha: 0.1),
                    ),
                  ),
                  const SizedBox(width: 4),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 20),
                    onPressed: _showCancelRequestDialog,
                    color: Colors.red,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.red.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 20),

            // Players needed badge
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
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

            // Interested users section (for creator only)
            if (widget.request.userId == widget.currentUserId) ...[
              Text(
                'Interested Players (${_interestedUsers.length})',
                style: FlutterFlowTheme.of(context).titleSmall,
              ),
              const SizedBox(height: 12),
              if (_isLoadingInterestedUsers)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_interestedUsers.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Colors.grey,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'No one has shown interest yet',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: 'Readex Pro',
                                color: Colors.grey,
                              ),
                        ),
                      ),
                    ],
                  ),
                )
              else
                ...(_interestedUsers.map((user) => _buildInterestedUserCard(user))),
              const SizedBox(height: 20),
            ],

            // Action button or status
            if (widget.request.userId != widget.currentUserId)
              _isCheckingResponse
                  ? Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(),
                    )
                  : _hasAlreadyResponded
                      ? Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(
                              color: Colors.green,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 24,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Already Responded',
                                style: FlutterFlowTheme.of(context)
                                    .titleSmall
                                    .override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.green,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        )
                      : FFButtonWidget(
                          onPressed: _isResponding ? null : _handleInterested,
                          text: 'I\'m Interested',
                          icon: const Icon(Icons.thumb_up, size: 20),
                          options: FFButtonOptions(
                            width: double.infinity,
                            height: 50,
                            color: FlutterFlowTheme.of(context).primary,
                            textStyle: FlutterFlowTheme.of(context)
                                .titleSmall
                                .override(
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
      setState(() {
        _isResponding = false;
        if (success) {
          _hasAlreadyResponded = true; // Update state after successful response
        }
      });

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

  Future<void> _showCancelRequestDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Request?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to cancel this request? Users who showed interest will be notified.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.2),
            ),
            child: const Text('Yes, Cancel', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final success = await QuickMatchService.cancelRequest(
          requestId: widget.request.id,
          userId: widget.currentUserId,
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Request cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pop(context); // Close the bottom sheet
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel request: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showEditRequestDialog() async {
    await showDialog(
      context: context,
      builder: (context) => EditRequestDialog(
        request: widget.request,
        onSuccess: () {
          // Close the bottom sheet after successful edit
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _buildInterestedUserCard(Map<String, dynamic> user) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.blue.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue, width: 2),
            ),
            child: ClipOval(
              child: user['profile_picture'] != null
                  ? CachedNetworkImage(
                      imageUrl: user['profile_picture'],
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.person, size: 24),
                    )
                  : const Icon(Icons.person, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user['first_name'] ?? 'Unknown',
                  style: FlutterFlowTheme.of(context).bodyLarge.override(
                        fontFamily: 'Readex Pro',
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  user['message'] ?? 'Interested',
                  style: FlutterFlowTheme.of(context).bodySmall.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.grey,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Chat button
          InkWell(
            onTap: () => _openChatWithUser(user['user_id']),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.chat_bubble_outline,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openChatWithUser(String otherUserId) async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Find or create chat room
      final roomId = await MapService.findOrCreateChatRoom(
        userId1: widget.currentUserId,
        userId2: otherUserId,
      );

      // Close loading dialog
      if (mounted) {
        Navigator.pop(context);
      }

      if (roomId != null && mounted) {
        // Close the bottom sheet
        Navigator.pop(context);

        // Navigate to chat room
        context.pushNamed(
          'ChatRoom',
          queryParameters: {'roomId': roomId},
        );
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to open chat. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      // Close loading dialog if still open
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
