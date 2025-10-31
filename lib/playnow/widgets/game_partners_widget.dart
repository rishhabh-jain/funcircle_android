import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/backend/supabase/supabase.dart';
import '/auth/firebase_auth/auth_util.dart';

/// Widget showing user's frequent game partners
class GamePartnersWidget extends StatefulWidget {
  const GamePartnersWidget({super.key});

  @override
  State<GamePartnersWidget> createState() => _GamePartnersWidgetState();
}

class _GamePartnersWidgetState extends State<GamePartnersWidget> {
  List<GamePartner> _partners = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPartners();
  }

  Future<void> _loadPartners() async {
    try {
      // Get games user participated in
      final myGames = await SupaFlow.client
          .schema('playnow').from('game_participants')
          .select('game_id')
          .eq('user_id', currentUserUid)
          .eq('status', 'confirmed') as List;

      if (myGames.isEmpty) {
        setState(() => _isLoading = false);
        return;
      }

      final gameIds = myGames.map((g) => g['game_id'] as String).toList();

      // Get other participants from those games
      final otherParticipants = await SupaFlow.client
          .schema('playnow').from('game_participants')
          .select('user_id, users!game_participants_user_id_fkey(display_name, photo_url)')
          .inFilter('game_id', gameIds)
          .eq('status', 'confirmed')
          .neq('user_id', currentUserUid) as List;

      // Count frequency
      final partnerCounts = <String, GamePartner>{};

      for (final participant in otherParticipants) {
        final userId = participant['user_id'] as String;
        final userData = participant['users'] as Map<String, dynamic>?;

        if (partnerCounts.containsKey(userId)) {
          partnerCounts[userId]!.gamesPlayed++;
        } else {
          partnerCounts[userId] = GamePartner(
            userId: userId,
            displayName: userData?['display_name'] as String? ?? 'Unknown',
            photoUrl: userData?['photo_url'] as String?,
            gamesPlayed: 1,
          );
        }
      }

      // Sort by frequency and take top 10
      final sortedPartners = partnerCounts.values.toList()
        ..sort((a, b) => b.gamesPlayed.compareTo(a.gamesPlayed));

      if (mounted) {
        setState(() {
          _partners = sortedPartners.take(10).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading partners: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_partners.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.people_outline,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No game partners yet',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Play games to build your network!',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _partners.length,
      itemBuilder: (context, index) {
        final partner = _partners[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          child: ListTile(
            leading: CircleAvatar(
              radius: 24,
              backgroundImage: partner.photoUrl != null
                  ? NetworkImage(partner.photoUrl!)
                  : null,
              child: partner.photoUrl == null
                  ? const Icon(Icons.person)
                  : null,
            ),
            title: Text(
              partner.displayName,
              style: FlutterFlowTheme.of(context).titleSmall,
            ),
            subtitle: Text(
              '${partner.gamesPlayed} ${partner.gamesPlayed == 1 ? 'game' : 'games'} together',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
            trailing: IconButton(
              icon: const Icon(Icons.chat_bubble_outline),
              onPressed: () {
                // Navigate to chat with this user
                // Implementation depends on your chat system
              },
            ),
          ),
        );
      },
    );
  }
}

class GamePartner {
  final String userId;
  final String displayName;
  final String? photoUrl;
  int gamesPlayed;

  GamePartner({
    required this.userId,
    required this.displayName,
    this.photoUrl,
    required this.gamesPlayed,
  });
}
