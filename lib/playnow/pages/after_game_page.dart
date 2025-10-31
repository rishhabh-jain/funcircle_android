import 'package:flutter/material.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/game_model.dart';
import '../models/game_completion_model.dart';
import '../services/game_completion_service.dart';

/// After game screen for rating and feedback
class AfterGamePage extends StatefulWidget {
  final Game game;

  const AfterGamePage({
    super.key,
    required this.game,
  });

  @override
  State<AfterGamePage> createState() => _AfterGamePageState();
}

class _AfterGamePageState extends State<AfterGamePage> {
  int _gameRating = 0;
  String? _result;
  final _feedbackController = TextEditingController();
  List<RatablePlayer> _players = [];
  bool _isLoading = true;
  bool _isSubmitting = false;

  final Map<String, int> _skillRatings = {};
  final Map<String, int> _sportsmanshipRatings = {};

  @override
  void initState() {
    super.initState();
    _loadPlayers();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _loadPlayers() async {
    final players = await GameCompletionService.getPlayersToRate(
      gameId: widget.game.id,
      currentUserId: currentUserUid,
    );

    if (mounted) {
      setState(() {
        _players = players;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).primary,
        title: const Text('Game Completed!'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Game info card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.game.autoTitle,
                            style: FlutterFlowTheme.of(context).titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                widget.game.locationDisplay,
                                style: FlutterFlowTheme.of(context).bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Rate the game
                  Text(
                    'How was the game?',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 12),
                  _buildStarRating(
                    rating: _gameRating,
                    onRatingChanged: (rating) {
                      setState(() => _gameRating = rating);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Match result
                  Text(
                    'Match Result',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildResultChip('Won', 'won'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildResultChip('Draw', 'draw'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildResultChip('Lost', 'lost'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Feedback
                  Text(
                    'Any feedback? (Optional)',
                    style: FlutterFlowTheme.of(context).titleMedium,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _feedbackController,
                    decoration: InputDecoration(
                      hintText: 'Share your thoughts about the game...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 24),

                  // Rate other players
                  if (_players.isNotEmpty) ...[
                    Text(
                      'Rate Other Players',
                      style: FlutterFlowTheme.of(context).titleMedium,
                    ),
                    const SizedBox(height: 12),
                    ..._players.map((player) => _buildPlayerRatingCard(player)),
                  ],

                  const SizedBox(height: 32),

                  // Submit button
                  FFButtonWidget(
                    onPressed: _isSubmitting ? null : _handleSubmit,
                    text: _isSubmitting ? 'Submitting...' : 'Submit Feedback',
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
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }

  Widget _buildStarRating({
    required int rating,
    required Function(int) onRatingChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => onRatingChanged(index + 1),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: 40,
            color: Colors.amber,
          ),
        );
      }),
    );
  }

  Widget _buildResultChip(String label, String value) {
    final isSelected = _result == value;
    return InkWell(
      onTap: () => setState(() => _result = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? FlutterFlowTheme.of(context).primary : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? FlutterFlowTheme.of(context).primary
                : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerRatingCard(RatablePlayer player) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundImage: player.photoUrl != null
                      ? NetworkImage(player.photoUrl!)
                      : null,
                  child: player.photoUrl == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    player.displayName,
                    style: FlutterFlowTheme.of(context).titleSmall,
                  ),
                ),
                if (player.isRated)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Rated',
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),

            // Skill rating
            Text(
              'Skill Level',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
            _buildMiniStarRating(
              rating: _skillRatings[player.userId] ?? 0,
              onRatingChanged: (rating) {
                setState(() => _skillRatings[player.userId] = rating);
              },
            ),
            const SizedBox(height: 12),

            // Sportsmanship rating
            Text(
              'Sportsmanship',
              style: FlutterFlowTheme.of(context).bodySmall,
            ),
            _buildMiniStarRating(
              rating: _sportsmanshipRatings[player.userId] ?? 0,
              onRatingChanged: (rating) {
                setState(() => _sportsmanshipRatings[player.userId] = rating);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStarRating({
    required int rating,
    required Function(int) onRatingChanged,
  }) {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          onPressed: () => onRatingChanged(index + 1),
          icon: Icon(
            index < rating ? Icons.star : Icons.star_border,
            size: 24,
            color: Colors.amber,
          ),
        );
      }),
    );
  }

  Future<void> _handleSubmit() async {
    if (_gameRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please rate the game'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Submit game completion
    final completed = await GameCompletionService.completeGame(
      gameId: widget.game.id,
      userId: currentUserUid,
      result: _result,
      rating: _gameRating,
      feedback: _feedbackController.text.isEmpty ? null : _feedbackController.text,
    );

    if (!completed) {
      if (mounted) {
        setState(() => _isSubmitting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit feedback'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    // Submit player ratings
    for (final player in _players) {
      final skillRating = _skillRatings[player.userId];
      final sportsmanshipRating = _sportsmanshipRatings[player.userId];

      if (skillRating != null && sportsmanshipRating != null) {
        await GameCompletionService.ratePlayer(
          gameId: widget.game.id,
          raterUserId: currentUserUid,
          ratedUserId: player.userId,
          skillRating: skillRating,
          sportsmanshipRating: sportsmanshipRating,
        );
      }
    }

    if (mounted) {
      setState(() => _isSubmitting = false);
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your feedback!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
