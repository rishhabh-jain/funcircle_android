import 'package:flutter/material.dart';
import '../../models/room_invite.dart';
import '../../services/room_invite_service.dart';
import '../../backend/supabase/supabase.dart';
import '../../auth/firebase_auth/auth_util.dart';
import '../../flutter_flow/flutter_flow_theme.dart';
import '../../flutter_flow/flutter_flow_util.dart';

/// Screen shown when user clicks an invite link
class JoinRoomScreen extends StatefulWidget {
  final String inviteCode;

  const JoinRoomScreen({
    Key? key,
    required this.inviteCode,
  }) : super(key: key);

  @override
  State<JoinRoomScreen> createState() => _JoinRoomScreenState();
}

class _JoinRoomScreenState extends State<JoinRoomScreen> {
  late final RoomInviteService _inviteService;
  RoomInviteDetails? _inviteDetails;
  bool _isLoading = true;
  bool _isJoining = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _inviteService = RoomInviteService(SupaFlow.client);
    _loadInviteDetails();
  }

  Future<void> _loadInviteDetails() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final details = await _inviteService.getInviteDetails(widget.inviteCode);

      if (details == null) {
        setState(() {
          _error = 'Invalid invite code';
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _inviteDetails = details;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load invite details: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _joinRoom() async {
    if (_inviteDetails == null || !_inviteDetails!.isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid or expired invite')),
      );
      return;
    }

    setState(() => _isJoining = true);

    try {
      final roomId = await _inviteService.joinRoomViaInvite(
        inviteCode: widget.inviteCode,
        userId: currentUserUid!,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Joined ${_inviteDetails!.roomName} successfully!')),
      );

      // Navigate to the chat room
      // Update this to match your routing
      context.pushNamed(
        'ChatRoom',
        queryParameters: {
          'roomId': roomId,
        },
      );
    } catch (e) {
      if (!mounted) return;

      setState(() => _isJoining = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to join: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      appBar: AppBar(
        title: const Text('Join Chat Room'),
        backgroundColor: FlutterFlowTheme.of(context).primary,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? _buildErrorView()
              : _inviteDetails != null
                  ? _buildInviteDetailsView()
                  : const SizedBox.shrink(),
    );
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 24),
            Text(
              _error!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInviteDetailsView() {
    final details = _inviteDetails!;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Room avatar/icon
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).primary,
                shape: BoxShape.circle,
              ),
              child: details.avatarUrl != null
                  ? ClipOval(
                      child: Image.network(
                        details.avatarUrl!,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      details.roomType == 'group'
                          ? Icons.group
                          : Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // Room name
          Text(
            details.roomName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

          // Sport type badge
          if (details.sportType != null)
            Center(
              child: Chip(
                label: Text(details.sportType!.toUpperCase()),
                backgroundColor:
                    FlutterFlowTheme.of(context).primary.withOpacity(0.2),
              ),
            ),
          const SizedBox(height: 24),

          // Room details card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Room Details',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow(
                    Icons.people,
                    'Members',
                    details.memberCountDisplay,
                  ),
                  _buildDetailRow(
                    Icons.person,
                    'Invited by',
                    details.createdByName,
                  ),
                  _buildDetailRow(
                    Icons.category,
                    'Type',
                    details.roomType == 'group' ? 'Group Chat' : 'Direct Chat',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Validation messages
          if (!details.isValid)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red),
              ),
              child: Row(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      details.isFull
                          ? 'This room is full'
                          : 'This invite is no longer valid',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ],
              ),
            )
          else
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'This invite is valid and ready to use!',
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 32),

          // Join button
          ElevatedButton(
            onPressed: details.isValid && !_isJoining ? _joinRoom : null,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: FlutterFlowTheme.of(context).primary,
              disabledBackgroundColor: Colors.grey,
            ),
            child: _isJoining
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(
                    details.isValid ? 'Join Room' : 'Cannot Join',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
          const SizedBox(height: 16),

          // Cancel button
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
