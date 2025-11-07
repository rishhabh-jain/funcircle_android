import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../../../models/room_invite.dart';
import '../../../services/room_invite_service.dart';
import '../../../backend/supabase/supabase.dart';
import '../../../auth/firebase_auth/auth_util.dart';

/// Bottom sheet for managing room invites
class RoomInviteSheet extends StatefulWidget {
  final String roomId;
  final String roomName;

  const RoomInviteSheet({
    Key? key,
    required this.roomId,
    required this.roomName,
  }) : super(key: key);

  @override
  State<RoomInviteSheet> createState() => _RoomInviteSheetState();
}

class _RoomInviteSheetState extends State<RoomInviteSheet> {
  late final RoomInviteService _inviteService;
  List<RoomInvite> _invites = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _inviteService = RoomInviteService(SupaFlow.client);
    _loadInvites();
  }

  Future<void> _loadInvites() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final invites = await _inviteService.getRoomInvites(widget.roomId);
      setState(() {
        _invites = invites;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _createNewInvite() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const CreateInviteDialog(),
    );

    if (result == null) return;

    try {
      final invite = await _inviteService.createInvite(
        roomId: widget.roomId,
        userId: currentUserUid!,
        maxUses: result['maxUses'],
        expiresInDays: result['expiresInDays'],
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invite link created!'),
          backgroundColor: Color(0xFF2A2A2A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );

      _loadInvites();

      // Optionally share immediately
      if (result['shareImmediately'] == true) {
        _shareInvite(invite);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create invite: $e'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  void _shareInvite(RoomInvite invite) {
    final message = '''
🎮 Join our ${widget.roomName} chat room!

Tap the link to join the conversation:
${invite.inviteLink}

${invite.maxUses != null ? '⚠️ Limited to ${invite.maxUses} uses' : ''}
${invite.expiresAt != null ? '⏰ Expires: ${invite.formattedExpiryDate}' : ''}
''';

    Share.share(message, subject: 'Join ${widget.roomName}');
  }

  void _copyInviteLink(RoomInvite invite) {
    Clipboard.setData(ClipboardData(text: invite.inviteLink));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite link copied to clipboard!'),
        backgroundColor: Color(0xFF2A2A2A),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Future<void> _deactivateInvite(RoomInvite invite) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        title: const Text('Deactivate Invite?', style: TextStyle(color: Colors.white)),
        content: Text(
            'This invite link will no longer work. This action cannot be undone.',
            style: TextStyle(color: Colors.grey[400]),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Deactivate',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _inviteService.deactivateInvite(invite.id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invite deactivated'),
          backgroundColor: Color(0xFF2A2A2A),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
      _loadInvites();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to deactivate: $e'),
          backgroundColor: Colors.red[900],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(0xFF1E1E1E).withValues(alpha: 0.95),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Invite Links',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Share these links to invite players to this room',
            style: TextStyle(color: Colors.grey[400]),
          ),
          const SizedBox(height: 16),

          // Create new invite button
          ElevatedButton.icon(
            onPressed: _createNewInvite,
            icon: const Icon(Icons.add_link, color: Colors.white),
            label: const Text('Create New Invite Link', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 12),
              backgroundColor: Color(0xFF6C63FF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Invites list
          if (_isLoading)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(color: Color(0xFF6C63FF)),
              ),
            )
          else if (_error != null)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(_error!, textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: _loadInvites,
                      child: const Text('Retry', style: TextStyle(color: Color(0xFF6C63FF))),
                    ),
                  ],
                ),
              ),
            )
          else if (_invites.isEmpty)
            Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(Icons.link_off, size: 48, color: Colors.grey[600]),
                    SizedBox(height: 16),
                    Text(
                      'No invite links yet',
                      style: TextStyle(color: Colors.grey[400], fontSize: 16),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Create one to invite players',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _invites.length,
                itemBuilder: (context, index) {
                  final invite = _invites[index];
                  return InviteCard(
                    invite: invite,
                    onShare: () => _shareInvite(invite),
                    onCopy: () => _copyInviteLink(invite),
                    onDeactivate: () => _deactivateInvite(invite),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

/// Dialog to create a new invite with options
class CreateInviteDialog extends StatefulWidget {
  const CreateInviteDialog({Key? key}) : super(key: key);

  @override
  State<CreateInviteDialog> createState() => _CreateInviteDialogState();
}

class _CreateInviteDialogState extends State<CreateInviteDialog> {
  bool _hasMaxUses = false;
  int _maxUses = 10;
  bool _hasExpiry = true;
  int _expiryDays = 7;
  bool _shareImmediately = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      title: const Text('Create Invite Link', style: TextStyle(color: Colors.white)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Max uses option
            SwitchListTile(
              title: const Text('Limit number of uses', style: TextStyle(color: Colors.white)),
              subtitle: _hasMaxUses
                  ? Text('Max uses: $_maxUses', style: TextStyle(color: Colors.grey[400]))
                  : Text('Unlimited uses', style: TextStyle(color: Colors.grey[400])),
              value: _hasMaxUses,
              activeColor: Color(0xFF6C63FF),
              onChanged: (value) => setState(() => _hasMaxUses = value),
            ),
            if (_hasMaxUses)
              Slider(
                value: _maxUses.toDouble(),
                min: 1,
                max: 100,
                divisions: 99,
                label: '$_maxUses uses',
                activeColor: Color(0xFF6C63FF),
                inactiveColor: Colors.grey[700],
                onChanged: (value) =>
                    setState(() => _maxUses = value.toInt()),
              ),
            const SizedBox(height: 8),

            // Expiry option
            SwitchListTile(
              title: const Text('Set expiration', style: TextStyle(color: Colors.white)),
              subtitle: _hasExpiry
                  ? Text('Expires in $_expiryDays days', style: TextStyle(color: Colors.grey[400]))
                  : Text('Never expires', style: TextStyle(color: Colors.grey[400])),
              value: _hasExpiry,
              activeColor: Color(0xFF6C63FF),
              onChanged: (value) => setState(() => _hasExpiry = value),
            ),
            if (_hasExpiry)
              Slider(
                value: _expiryDays.toDouble(),
                min: 1,
                max: 30,
                divisions: 29,
                label: '$_expiryDays days',
                activeColor: Color(0xFF6C63FF),
                inactiveColor: Colors.grey[700],
                onChanged: (value) =>
                    setState(() => _expiryDays = value.toInt()),
              ),
            const SizedBox(height: 8),

            // Share immediately option
            CheckboxListTile(
              title: const Text('Share immediately', style: TextStyle(color: Colors.white)),
              subtitle: Text('Open share dialog after creating', style: TextStyle(color: Colors.grey[400])),
              value: _shareImmediately,
              activeColor: Color(0xFF6C63FF),
              checkColor: Colors.white,
              onChanged: (value) =>
                  setState(() => _shareImmediately = value ?? true),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context, {
              'maxUses': _hasMaxUses ? _maxUses : null,
              'expiresInDays': _hasExpiry ? _expiryDays : null,
              'shareImmediately': _shareImmediately,
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF6C63FF),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Create', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}

/// Card displaying a single invite
class InviteCard extends StatelessWidget {
  final RoomInvite invite;
  final VoidCallback onShare;
  final VoidCallback onCopy;
  final VoidCallback onDeactivate;

  const InviteCard({
    Key? key,
    required this.invite,
    required this.onShare,
    required this.onCopy,
    required this.onDeactivate,
  }) : super(key: key);

  Color _getStatusColor() {
    switch (invite.status) {
      case 'active':
        return Colors.green;
      case 'expired':
        return Colors.orange;
      case 'maxed':
        return Colors.red;
      case 'inactive':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Color(0xFF2A2A2A),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Chip(
                  label: Text(invite.statusDisplay),
                  backgroundColor: _getStatusColor().withValues(alpha: 0.2),
                  labelStyle: TextStyle(
                    color: _getStatusColor(),
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                  padding: EdgeInsets.zero,
                ),
                Text(
                  invite.formattedCreatedDate,
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Invite code
            Row(
              children: [
                Icon(Icons.key, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  invite.inviteCode,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Usage info
            Row(
              children: [
                Icon(Icons.people, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  invite.usageDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
                const SizedBox(width: 16),
                Icon(Icons.schedule, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 8),
                Text(
                  invite.expiryDisplay,
                  style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (invite.isValid) ...[
                  TextButton.icon(
                    onPressed: onCopy,
                    icon: const Icon(Icons.copy, size: 16, color: Color(0xFF6C63FF)),
                    label: const Text('Copy', style: TextStyle(color: Color(0xFF6C63FF))),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onShare,
                    icon: const Icon(Icons.share, size: 16, color: Colors.white),
                    label: const Text('Share', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF6C63FF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                ],
                if (invite.isActive)
                  IconButton(
                    onPressed: onDeactivate,
                    icon: const Icon(Icons.block, color: Colors.red),
                    tooltip: 'Deactivate',
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
