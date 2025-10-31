import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/user_location_model.dart';
import '../models/skill_level.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

/// Bottom sheet showing player information
class PlayerInfoSheet extends StatefulWidget {
  final UserLocationModel player;
  final double? distanceKm;

  const PlayerInfoSheet({
    super.key,
    required this.player,
    this.distanceKm,
  });

  @override
  State<PlayerInfoSheet> createState() => _PlayerInfoSheetState();
}

class _PlayerInfoSheetState extends State<PlayerInfoSheet> {
  bool _isConnecting = false;

  @override
  Widget build(BuildContext context) {
    final skillLevel = widget.player.skillLevel != null
        ? SkillLevel.fromValue(widget.player.skillLevel!)
        : null;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Profile picture
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: skillLevel != null
                    ? _hexToColor(skillLevel.hexColor)
                    : Colors.grey,
                width: 4,
              ),
            ),
            child: ClipOval(
              child: widget.player.userProfilePicture != null
                  ? CachedNetworkImage(
                      imageUrl: widget.player.userProfilePicture!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.grey,
                      ),
                    )
                  : const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Player name
          Text(
            widget.player.userName ?? 'Unknown Player',
            style: FlutterFlowTheme.of(context).headlineSmall,
          ),
          const SizedBox(height: 8),

          // Distance
          if (widget.distanceKm != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_on, size: 16, color: Colors.grey),
                const SizedBox(width: 4),
                Text(
                  LocationService.formatDistance(widget.distanceKm!),
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        fontFamily: 'Readex Pro',
                        color: Colors.grey,
                      ),
                ),
              ],
            ),
          const SizedBox(height: 16),

          // Skill level
          if (skillLevel != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _hexToColor(skillLevel.hexColor).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: _hexToColor(skillLevel.hexColor),
                  width: 2,
                ),
              ),
              child: Text(
                skillLevel.label,
                style: TextStyle(
                  color: _hexToColor(skillLevel.hexColor),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          const SizedBox(height: 8),

          // Sport type
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  widget.player.sportType?.toLowerCase() == 'badminton'
                      ? Icons.sports_tennis
                      : Icons.sports_baseball,
                  size: 16,
                  color: FlutterFlowTheme.of(context).primary,
                ),
                const SizedBox(width: 8),
                Text(
                  widget.player.sportType ?? 'Unknown Sport',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Connect button
          FFButtonWidget(
            onPressed: _isConnecting ? null : _handleConnect,
            text: _isConnecting ? 'Connecting...' : 'Start Chat',
            icon: Icon(
              _isConnecting ? Icons.hourglass_empty : Icons.chat_bubble,
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
          ),
        ],
      ),
    );
  }

  Future<void> _handleConnect() async {
    final currentUserId = currentUserUid;
    if (currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to connect with players')),
      );
      return;
    }

    setState(() => _isConnecting = true);

    final roomId = await MapService.createOrGetChatRoom(
      userId1: currentUserId,
      userId2: widget.player.userId,
    );

    if (mounted) {
      setState(() => _isConnecting = false);
      Navigator.pop(context);

      if (roomId != null) {
        // Navigate to chat room
        context.pushNamed(
          'chat_room',
          queryParameters: {
            'roomId': roomId,
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create chat. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
