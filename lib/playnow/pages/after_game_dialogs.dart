import 'package:flutter/material.dart';
import 'dart:ui';
import '../models/game_model.dart';
import '../services/after_game_service.dart';
import 'game_details_model.dart';

/// Dialog for recording game scores (3 sets)
class RecordScoresDialog extends StatefulWidget {
  final Game game;
  final List<GameParticipant> participants;
  final String currentUserId;

  const RecordScoresDialog({
    super.key,
    required this.game,
    required this.participants,
    required this.currentUserId,
  });

  @override
  State<RecordScoresDialog> createState() => _RecordScoresDialogState();
}

class _RecordScoresDialogState extends State<RecordScoresDialog> {
  final _set1Team1Controller = TextEditingController();
  final _set1Team2Controller = TextEditingController();
  final _set2Team1Controller = TextEditingController();
  final _set2Team2Controller = TextEditingController();
  final _set3Team1Controller = TextEditingController();
  final _set3Team2Controller = TextEditingController();

  List<String> _team1Players = [];
  List<String> _team2Players = [];
  bool _isSubmitting = false;

  @override
  void dispose() {
    _set1Team1Controller.dispose();
    _set1Team2Controller.dispose();
    _set2Team1Controller.dispose();
    _set2Team2Controller.dispose();
    _set3Team1Controller.dispose();
    _set3Team2Controller.dispose();
    super.dispose();
  }

  Future<void> _submitScores() async {
    // Validation
    if (_team1Players.isEmpty || _team2Players.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select players for both teams')),
      );
      return;
    }

    if (_set1Team1Controller.text.isEmpty ||
        _set1Team2Controller.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter scores for Set 1')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final result = await AfterGameService.recordGameScores(
      gameId: widget.game.id,
      submittedBy: widget.currentUserId,
      team1Players: _team1Players,
      team2Players: _team2Players,
      set1Team1Score: int.parse(_set1Team1Controller.text),
      set1Team2Score: int.parse(_set1Team2Controller.text),
      set2Team1Score: _set2Team1Controller.text.isNotEmpty
          ? int.parse(_set2Team1Controller.text)
          : null,
      set2Team2Score: _set2Team2Controller.text.isNotEmpty
          ? int.parse(_set2Team2Controller.text)
          : null,
      set3Team1Score: _set3Team1Controller.text.isNotEmpty
          ? int.parse(_set3Team1Controller.text)
          : null,
      set3Team2Score: _set3Team2Controller.text.isNotEmpty
          ? int.parse(_set3Team2Controller.text)
          : null,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.green : Colors.red,
        ),
      );

      if (result['success']) {
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A1A).withValues(alpha: 0.95),
                  Color(0xFF0D0D0D).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.withValues(alpha: 0.3),
                        Colors.green.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.scoreboard_rounded,
                          color: Colors.green, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Record Scores',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Team selection
                        Text(
                          'Select Teams',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 12),
                        _buildTeamSelector('Team 1', _team1Players, (selected) {
                          setState(() => _team1Players = selected);
                        }),
                        SizedBox(height: 12),
                        _buildTeamSelector('Team 2', _team2Players, (selected) {
                          setState(() => _team2Players = selected);
                        }),

                        SizedBox(height: 20),
                        Divider(color: Colors.white.withValues(alpha: 0.2)),
                        SizedBox(height: 20),

                        // Set 1
                        Text(
                          'Set 1 *',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildScoreField(
                                  'Team 1', _set1Team1Controller),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildScoreField(
                                  'Team 2', _set1Team2Controller),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Set 2
                        Text(
                          'Set 2 (Optional)',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildScoreField(
                                  'Team 1', _set2Team1Controller),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildScoreField(
                                  'Team 2', _set2Team2Controller),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Set 3
                        Text(
                          'Set 3 (Optional)',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: _buildScoreField(
                                  'Team 1', _set3Team1Controller),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildScoreField(
                                  'Team 2', _set3Team2Controller),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitScores,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              'Submit Scores',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeamSelector(String label, List<String> selectedPlayers,
      Function(List<String>) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
        ),
        SizedBox(height: 6),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.participants.map((participant) {
            final isSelected = selectedPlayers.contains(participant.userId);
            final isInOtherTeam = (label == 'Team 1' &&
                    _team2Players.contains(participant.userId)) ||
                (label == 'Team 2' &&
                    _team1Players.contains(participant.userId));

            return FilterChip(
              label: Text(participant.firstName ?? 'Player'),
              selected: isSelected,
              onSelected: isInOtherTeam
                  ? null
                  : (selected) {
                      final newSelection = List<String>.from(selectedPlayers);
                      if (selected) {
                        newSelection.add(participant.userId);
                      } else {
                        newSelection.remove(participant.userId);
                      }
                      onChanged(newSelection);
                    },
              backgroundColor: Colors.white.withValues(alpha: 0.1),
              selectedColor: Colors.green.withValues(alpha: 0.3),
              checkmarkColor: Colors.white,
              labelStyle: TextStyle(
                color: isInOtherTeam
                    ? Colors.white.withValues(alpha: 0.3)
                    : Colors.white,
                fontSize: 12,
              ),
              side: BorderSide(
                color: isSelected
                    ? Colors.green
                    : Colors.white.withValues(alpha: 0.2),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildScoreField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(color: Colors.white, fontSize: 16),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.green),
        ),
      ),
    );
  }
}

/// Dialog for rating players
class RatePlayersDialog extends StatefulWidget {
  final String gameId;
  final List<GameParticipant> players;
  final String currentUserId;

  const RatePlayersDialog({
    super.key,
    required this.gameId,
    required this.players,
    required this.currentUserId,
  });

  @override
  State<RatePlayersDialog> createState() => _RatePlayersDialogState();
}

class _RatePlayersDialogState extends State<RatePlayersDialog> {
  int _selectedPlayerIndex = 0;
  double _overallRating = 3.0;
  double _skillRating = 3.0;
  double _sportsmanshipRating = 3.0;
  final _commentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    setState(() => _isSubmitting = true);

    final player = widget.players[_selectedPlayerIndex];

    final result = await AfterGameService.ratePlayer(
      gameId: widget.gameId,
      ratedUserId: player.userId,
      ratedByUserId: widget.currentUserId,
      rating: _overallRating.round(),
      skillRating: _skillRating.round(),
      sportsmanshipRating: _sportsmanshipRating.round(),
      comment:
          _commentController.text.isNotEmpty ? _commentController.text : null,
    );

    if (mounted) {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message']),
          backgroundColor: result['success'] ? Colors.orange : Colors.red,
        ),
      );

      if (result['success']) {
        // Move to next player or close
        if (_selectedPlayerIndex < widget.players.length - 1) {
          setState(() {
            _selectedPlayerIndex++;
            _overallRating = 3.0;
            _skillRating = 3.0;
            _sportsmanshipRating = 3.0;
            _commentController.clear();
          });
        } else {
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[_selectedPlayerIndex];

    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A1A).withValues(alpha: 0.95),
                  Color(0xFF0D0D0D).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.orange.withValues(alpha: 0.3),
                        Colors.orange.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star_rounded, color: Colors.orange, size: 24),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rate Player',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '${_selectedPlayerIndex + 1} of ${widget.players.length}',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Player name
                        Center(
                          child: Text(
                            player.firstName ?? 'Player',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 24),

                        // Overall rating
                        _buildRatingSlider(
                          'Overall Rating',
                          _overallRating,
                          (value) => setState(() => _overallRating = value),
                          Colors.orange,
                        ),
                        SizedBox(height: 16),

                        // Skill rating
                        _buildRatingSlider(
                          'Skill Level',
                          _skillRating,
                          (value) => setState(() => _skillRating = value),
                          Colors.blue,
                        ),
                        SizedBox(height: 16),

                        // Sportsmanship rating
                        _buildRatingSlider(
                          'Sportsmanship',
                          _sportsmanshipRating,
                          (value) =>
                              setState(() => _sportsmanshipRating = value),
                          Colors.green,
                        ),
                        SizedBox(height: 20),

                        // Comment
                        TextField(
                          controller: _commentController,
                          maxLines: 3,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Comment (Optional)',
                            labelStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6)),
                            hintText: 'Add a comment...',
                            hintStyle: TextStyle(
                                color: Colors.white.withValues(alpha: 0.3)),
                            filled: true,
                            fillColor: Colors.white.withValues(alpha: 0.05),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.2)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Submit button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (_selectedPlayerIndex > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              setState(() {
                                _selectedPlayerIndex--;
                                _overallRating = 3.0;
                                _skillRating = 3.0;
                                _sportsmanshipRating = 3.0;
                                _commentController.clear();
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3)),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: Text('Previous',
                                style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      if (_selectedPlayerIndex > 0) SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submitRating,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation(Colors.white),
                                    ),
                                  )
                                : Text(
                                    _selectedPlayerIndex <
                                            widget.players.length - 1
                                        ? 'Rate & Next'
                                        : 'Submit',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSlider(
      String label, double value, ValueChanged<double> onChanged, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600),
            ),
            Row(
              children: List.generate(5, (index) {
                return Icon(
                  index < value.round() ? Icons.star : Icons.star_border,
                  color: color,
                  size: 20,
                );
              }),
            ),
          ],
        ),
        Slider(
          value: value,
          min: 1,
          max: 5,
          divisions: 4,
          activeColor: color,
          inactiveColor: color.withValues(alpha: 0.3),
          onChanged: onChanged,
        ),
      ],
    );
  }
}

/// Dialog for tagging players
class TagPlayersDialog extends StatefulWidget {
  final String gameId;
  final List<GameParticipant> players;
  final String currentUserId;

  const TagPlayersDialog({
    super.key,
    required this.gameId,
    required this.players,
    required this.currentUserId,
  });

  @override
  State<TagPlayersDialog> createState() => _TagPlayersDialogState();
}

class _TagPlayersDialogState extends State<TagPlayersDialog> {
  final List<String> _predefinedTags = [
    'Great Partner',
    'Consistent Player',
    'Team Player',
    'Strategic',
    'Fast Reflexes',
    'Good Attitude',
    'Respectful',
    'Fun to Play With',
  ];

  final Map<String, Set<String>> _selectedTags = {};
  bool _isSubmitting = false;

  Future<void> _submitTags() async {
    if (_selectedTags.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one player and tag')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    int successCount = 0;

    for (final entry in _selectedTags.entries) {
      for (final tag in entry.value) {
        final result = await AfterGameService.tagPlayer(
          gameId: widget.gameId,
          taggedUserId: entry.key,
          taggedByUserId: widget.currentUserId,
          tag: tag,
        );

        if (result['success']) {
          successCount++;
        }
      }
    }

    if (mounted) {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $successCount tags successfully'),
          backgroundColor: Colors.blue,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A1A).withValues(alpha: 0.95),
                  Color(0xFF0D0D0D).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue.withValues(alpha: 0.3),
                        Colors.blue.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.label_rounded, color: Colors.blue, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Tag Players',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player = widget.players[index];
                      final playerTags = _selectedTags[player.userId] ?? {};

                      return Container(
                        margin: EdgeInsets.only(bottom: 16),
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              player.firstName ?? 'Player',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: _predefinedTags.map((tag) {
                                final isSelected = playerTags.contains(tag);
                                return FilterChip(
                                  label: Text(tag),
                                  selected: isSelected,
                                  onSelected: (selected) {
                                    setState(() {
                                      if (selected) {
                                        _selectedTags
                                            .putIfAbsent(
                                                player.userId, () => {})
                                            .add(tag);
                                      } else {
                                        _selectedTags[player.userId]
                                            ?.remove(tag);
                                        if (_selectedTags[player.userId]
                                                ?.isEmpty ??
                                            false) {
                                          _selectedTags.remove(player.userId);
                                        }
                                      }
                                    });
                                  },
                                  backgroundColor:
                                      Colors.white.withValues(alpha: 0.1),
                                  selectedColor:
                                      Colors.blue.withValues(alpha: 0.3),
                                  checkmarkColor: Colors.white,
                                  labelStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                  ),
                                  side: BorderSide(
                                    color: isSelected
                                        ? Colors.blue
                                        : Colors.white.withValues(alpha: 0.2),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Submit button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitTags,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              'Submit Tags',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Dialog for adding play pals
class AddPlayPalsDialog extends StatefulWidget {
  final String sportType;
  final List<GameParticipant> players;
  final String currentUserId;

  const AddPlayPalsDialog({
    super.key,
    required this.sportType,
    required this.players,
    required this.currentUserId,
  });

  @override
  State<AddPlayPalsDialog> createState() => _AddPlayPalsDialogState();
}

class _AddPlayPalsDialogState extends State<AddPlayPalsDialog> {
  final Set<String> _selectedPlayers = {};
  final Set<String> _favoriteMarks = {};
  bool _isSubmitting = false;

  Future<void> _submitPlayPals() async {
    if (_selectedPlayers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one player')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    int successCount = 0;

    for (final playerId in _selectedPlayers) {
      final result = await AfterGameService.addPlayPal(
        userId: widget.currentUserId,
        partnerId: playerId,
        sportType: widget.sportType,
        isFavorite: _favoriteMarks.contains(playerId),
      );

      if (result['success']) {
        successCount++;
      }
    }

    if (mounted) {
      setState(() => _isSubmitting = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Added $successCount play pals successfully'),
          backgroundColor: Colors.pink,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF1A1A1A).withValues(alpha: 0.95),
                  Color(0xFF0D0D0D).withValues(alpha: 0.95),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.2), width: 1.5),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.pink.withValues(alpha: 0.3),
                        Colors.pink.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.group_add_rounded,
                          color: Colors.pink, size: 24),
                      SizedBox(width: 12),
                      Text(
                        'Add Play Pals',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Spacer(),
                      IconButton(
                        icon: Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                ),

                // Content
                Flexible(
                  child: ListView.builder(
                    padding: EdgeInsets.all(16),
                    itemCount: widget.players.length,
                    itemBuilder: (context, index) {
                      final player = widget.players[index];
                      final isSelected =
                          _selectedPlayers.contains(player.userId);
                      final isFavorite = _favoriteMarks.contains(player.userId);

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white
                              .withValues(alpha: isSelected ? 0.1 : 0.05),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.pink.withValues(alpha: 0.5)
                                : Colors.white.withValues(alpha: 0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: CheckboxListTile(
                          value: isSelected,
                          onChanged: (value) {
                            setState(() {
                              if (value == true) {
                                _selectedPlayers.add(player.userId);
                              } else {
                                _selectedPlayers.remove(player.userId);
                                _favoriteMarks.remove(player.userId);
                              }
                            });
                          },
                          title: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  player.firstName ?? 'Player',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                IconButton(
                                  icon: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isFavorite
                                        ? Colors.red
                                        : Colors.white.withValues(alpha: 0.5),
                                    size: 20,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      if (isFavorite) {
                                        _favoriteMarks.remove(player.userId);
                                      } else {
                                        _favoriteMarks.add(player.userId);
                                      }
                                    });
                                  },
                                ),
                            ],
                          ),
                          subtitle: player.skillLevelBadminton != null ||
                                  player.skillLevelPickleball != null
                              ? Text(
                                  'Level ${widget.sportType == 'badminton' ? player.skillLevelBadminton : player.skillLevelPickleball}',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                )
                              : null,
                          activeColor: Colors.pink,
                          checkColor: Colors.white,
                        ),
                      );
                    },
                  ),
                ),

                // Submit button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitPlayPals,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      child: _isSubmitting
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor:
                                    AlwaysStoppedAnimation(Colors.white),
                              ),
                            )
                          : Text(
                              'Add Play Pals',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
