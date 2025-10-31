import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '../services/game_service.dart';

/// Bottom sheet showing pending join requests for a game
class JoinRequestsSheet extends StatefulWidget {
  final String gameId;
  final String creatorId;

  const JoinRequestsSheet({
    super.key,
    required this.gameId,
    required this.creatorId,
  });

  @override
  State<JoinRequestsSheet> createState() => _JoinRequestsSheetState();
}

class _JoinRequestsSheetState extends State<JoinRequestsSheet> {
  List<JoinRequest> _requests = [];
  bool _isLoading = true;
  final Set<String> _processingRequests = {};

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _isLoading = true);
    final requests = await GameService.getGameJoinRequests(widget.gameId);
    if (mounted) {
      setState(() {
        _requests = requests;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),

          // Header
          Text(
            'Join Requests',
            style: FlutterFlowTheme.of(context).headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            _requests.isEmpty
                ? 'No pending requests'
                : '${_requests.length} pending ${_requests.length == 1 ? 'request' : 'requests'}',
            style: FlutterFlowTheme.of(context).bodySmall.override(
                  fontFamily: 'Readex Pro',
                  color: Colors.grey,
                ),
          ),
          const SizedBox(height: 20),

          // Requests list
          if (_isLoading)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: CircularProgressIndicator(),
              ),
            )
          else if (_requests.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      Icons.inbox,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No join requests yet',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _requests.length,
                itemBuilder: (context, index) {
                  final request = _requests[index];
                  return _buildRequestCard(request);
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildRequestCard(JoinRequest request) {
    final isProcessing = _processingRequests.contains(request.id);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: request.userPhotoUrl != null
                      ? NetworkImage(request.userPhotoUrl!)
                      : null,
                  child: request.userPhotoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.userName ?? 'Unknown Player',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        _formatTimeAgo(request.createdAt),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Message
            if (request.message != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  request.message!,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            ],

            // Action buttons
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: isProcessing
                        ? null
                        : () => _handleDecline(request.id),
                    icon: const Icon(Icons.close, size: 18),
                    label: const Text('Decline'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: isProcessing
                        ? null
                        : () => _handleApprove(request.id),
                    icon: const Icon(Icons.check, size: 18),
                    label: const Text('Accept'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleApprove(String requestId) async {
    setState(() => _processingRequests.add(requestId));

    final success = await GameService.approveJoinRequest(
      requestId: requestId,
      gameId: widget.gameId,
      approverId: widget.creatorId,
    );

    if (mounted) {
      setState(() => _processingRequests.remove(requestId));

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Player approved!'),
            backgroundColor: Colors.green,
          ),
        );
        // Reload requests
        await _loadRequests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to approve. Game may be full.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDecline(String requestId) async {
    setState(() => _processingRequests.add(requestId));

    final success = await GameService.declineJoinRequest(
      requestId: requestId,
      gameId: widget.gameId,
      approverId: widget.creatorId,
    );

    if (mounted) {
      setState(() => _processingRequests.remove(requestId));

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request declined'),
            backgroundColor: Colors.orange,
          ),
        );
        // Reload requests
        await _loadRequests();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to decline request'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${(difference.inDays / 7).floor()}w ago';
    }
  }
}
