import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';
import '/find_players_new/services/map_service.dart';
import '/find_players_new/models/venue_marker_model.dart';

/// Bottom sheet for creating a new game
class CreateGameSheet extends StatefulWidget {
  final String? initialSportType;
  final int? initialVenueId;
  final void Function()? onGameCreated;

  const CreateGameSheet({
    super.key,
    this.initialSportType,
    this.initialVenueId,
    this.onGameCreated,
  });

  @override
  State<CreateGameSheet> createState() => _CreateGameSheetState();
}

class _CreateGameSheetState extends State<CreateGameSheet> {
  final _formKey = GlobalKey<FormState>();
  bool _isCreating = false;
  bool _isLoadingVenues = false;

  // Form fields
  String _sportType = 'badminton';
  DateTime _gameDate = DateTime.now();
  TimeOfDay _startTime = TimeOfDay.now();
  String _gameType = 'doubles';
  int _playersNeeded = 4;
  int? _skillLevel;
  bool _isFree = true;
  double? _costPerPlayer;
  String _joinType = 'auto';
  bool _isVenueBooked = false;
  bool _isWomenOnly = false;
  bool _isMixedOnly = false;
  String? _description;
  int? _venueId;
  String? _customLocation;

  // Venues
  List<VenueMarkerModel> _allVenues = [];
  VenueMarkerModel? _selectedVenue;

  @override
  void initState() {
    super.initState();
    if (widget.initialSportType != null) {
      _sportType = widget.initialSportType!;
    }
    if (widget.initialVenueId != null) {
      _venueId = widget.initialVenueId;
    }
    _loadVenues();
  }

  Future<void> _loadVenues() async {
    setState(() => _isLoadingVenues = true);
    try {
      final venues = await MapService.getVenues();
      if (mounted) {
        setState(() {
          _allVenues = venues;
          _isLoadingVenues = false;

          // If initialVenueId was provided, select that venue
          if (widget.initialVenueId != null) {
            _selectedVenue = _allVenues.firstWhere(
              (v) => v.id == widget.initialVenueId,
              orElse: () => _allVenues.first,
            );
            _venueId = _selectedVenue?.id;
          }
        });
      }
    } catch (e) {
      print('Error loading venues: $e');
      if (mounted) {
        setState(() => _isLoadingVenues = false);
      }
    }
  }

  List<VenueMarkerModel> get _filteredVenues {
    return _allVenues.where((venue) {
      if (venue.sportType == null) return true;
      return venue.sportType == _sportType || venue.sportType == 'both';
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with close button
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Create a Game',
                      style: FlutterFlowTheme.of(context).headlineMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Set up your game and invite players',
                style: FlutterFlowTheme.of(context).bodySmall.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.grey,
                    ),
              ),
              const SizedBox(height: 24),

              // Sport Type
              _buildSectionTitle('Sport'),
              Row(
                children: [
                  Expanded(
                    child: _buildSportChip('Badminton', 'badminton'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildSportChip('Pickleball', 'pickleball'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date and Time
              _buildSectionTitle('When'),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Date',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              DateFormat('MMM dd, yyyy').format(_gameDate),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Time',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _startTime.format(context),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Game Type
              _buildSectionTitle('Game Type'),
              Row(
                children: [
                  Expanded(
                    child: _buildGameTypeChip('Singles', 'singles', 2),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildGameTypeChip('Doubles', 'doubles', 4),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildGameTypeChip('Mixed', 'mixed_doubles', 4),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Players Needed
              _buildSectionTitle('Players Needed'),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      if (_playersNeeded > 2) {
                        setState(() => _playersNeeded--);
                      }
                    },
                    icon: const Icon(Icons.remove_circle_outline),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$_playersNeeded players',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (_playersNeeded < 10) {
                        setState(() => _playersNeeded++);
                      }
                    },
                    icon: const Icon(Icons.add_circle_outline),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Skill Level
              _buildSectionTitle('Skill Level (Optional)'),
              Wrap(
                spacing: 8,
                children: [
                  _buildSkillLevelChip('Any', null),
                  _buildSkillLevelChip('1', 1),
                  _buildSkillLevelChip('2', 2),
                  _buildSkillLevelChip('3', 3),
                  _buildSkillLevelChip('4', 4),
                  _buildSkillLevelChip('5', 5),
                ],
              ),
              const SizedBox(height: 20),

              // Cost
              _buildSectionTitle('Cost'),
              Row(
                children: [
                  Expanded(
                    child: _buildCostChip('Free', true),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildCostChip('Paid', false),
                  ),
                ],
              ),
              if (!_isFree) ...[
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Cost per player',
                    prefixText: '₹',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _costPerPlayer = double.tryParse(value);
                  },
                  validator: (value) {
                    if (!_isFree && (value == null || value.isEmpty)) {
                      return 'Please enter cost';
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 20),

              // Join Type
              _buildSectionTitle('Join Type'),
              Row(
                children: [
                  Expanded(
                    child: _buildJoinTypeChip('Auto Join', 'auto'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildJoinTypeChip('Request', 'request'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Location (venue selector with auto-population)
              _buildSectionTitle('Location'),
              if (_isLoadingVenues)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: CircularProgressIndicator(),
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'Select Venue',
                    hintText: 'Choose a venue',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.location_on),
                  ),
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text('Custom Location'),
                    ),
                    ..._filteredVenues.map((venue) {
                      return DropdownMenuItem<int>(
                        value: venue.id,
                        child: Text(
                          venue.name,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _venueId = value;
                      if (value != null) {
                        // Find the selected venue
                        _selectedVenue = _filteredVenues.firstWhere(
                          (v) => v.id == value,
                        );
                        // Clear custom location when venue is selected
                        _customLocation = null;
                      } else {
                        _selectedVenue = null;
                        _customLocation = null;
                      }
                    });
                  },
                ),
              // Custom location field (only shown if no venue selected)
              if (_venueId == null) ...[
                const SizedBox(height: 12),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Custom Location',
                    hintText: 'Enter custom location',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.edit_location),
                  ),
                  onChanged: (value) => _customLocation = value,
                  initialValue: _customLocation,
                ),
              ] else if (_selectedVenue != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.1),
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.3)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedVenue!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (_selectedVenue!.address != null)
                              Text(
                                _selectedVenue!.address!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Description
              _buildSectionTitle('Description (Optional)'),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description',
                  hintText: 'Add any additional details...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
              ),
              const SizedBox(height: 20),

              // Advanced Options - Collapsible
              ExpansionTile(
                title: Text(
                  'Advanced Options',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                initiallyExpanded: false,
                children: [
                  CheckboxListTile(
                    title: const Text('Venue Booked'),
                    value: _isVenueBooked,
                    onChanged: (value) =>
                        setState(() => _isVenueBooked = value!),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  CheckboxListTile(
                    title: const Text('Women Only'),
                    value: _isWomenOnly,
                    onChanged: (value) => setState(() => _isWomenOnly = value!),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                  CheckboxListTile(
                    title: const Text('Mixed Doubles Only'),
                    value: _isMixedOnly,
                    onChanged: (value) => setState(() => _isMixedOnly = value!),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Create Button
              FFButtonWidget(
                onPressed: _isCreating ? null : _handleCreateGame,
                text: _isCreating ? 'Creating...' : 'Create Game',
                icon: const Icon(Icons.add, size: 20),
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
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSportChip(String label, String value) {
    final isSelected = _sportType == value;
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return InkWell(
      onTap: () => setState(() => _sportType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
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

  Widget _buildGameTypeChip(String label, String value, int defaultPlayers) {
    final isSelected = _gameType == value;
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return InkWell(
      onTap: () => setState(() {
        _gameType = value;
        _playersNeeded = defaultPlayers;
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillLevelChip(String label, int? value) {
    final isSelected = _skillLevel == value;
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() => _skillLevel = selected ? value : null);
      },
      selectedColor: primaryColor,
      labelStyle: TextStyle(
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }

  Widget _buildCostChip(String label, bool isFree) {
    final isSelected = _isFree == isFree;
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return InkWell(
      onTap: () => setState(() => _isFree = isFree),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
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

  Widget _buildJoinTypeChip(String label, String value) {
    final isSelected = _joinType == value;
    final primaryColor = FlutterFlowTheme.of(context).primary;
    return InkWell(
      onTap: () => setState(() => _joinType = value),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? primaryColor : Colors.grey[300]!,
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

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _gameDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null) {
      setState(() => _gameDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
    );
    if (picked != null) {
      // Check if selected time is in the past for today's date
      final now = DateTime.now();
      final isToday = _gameDate.year == now.year &&
          _gameDate.month == now.month &&
          _gameDate.day == now.day;

      if (isToday) {
        final selectedDateTime = DateTime(
          now.year,
          now.month,
          now.day,
          picked.hour,
          picked.minute,
        );

        if (selectedDateTime.isBefore(now)) {
          // Show error for past time
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Cannot select a time in the past'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }
      }

      setState(() => _startTime = picked);
    }
  }

  Future<void> _handleCreateGame() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCreating = true);

    final request = CreateGameRequest(
      userId: currentUserUid,
      sportType: _sportType,
      gameDate: _gameDate,
      startTime:
          '${_startTime.hour.toString().padLeft(2, '0')}:${_startTime.minute.toString().padLeft(2, '0')}',
      venueId: _venueId,
      customLocation: _customLocation,
      playersNeeded: _playersNeeded,
      gameType: _gameType,
      skillLevel: _skillLevel,
      costPerPlayer: _costPerPlayer,
      isFree: _isFree,
      joinType: _joinType,
      isVenueBooked: _isVenueBooked,
      isWomenOnly: _isWomenOnly,
      isMixedOnly: _isMixedOnly,
      description: _description,
    );

    try {
      print('=== CREATING GAME ===');
      print('Sport: $_sportType');
      print('Date: $_gameDate');
      print('Time: ${_startTime.hour}:${_startTime.minute}');
      print('Players needed: $_playersNeeded');
      print('Game type: $_gameType');

      final game = await GameService.createGame(request);

      if (mounted) {
        setState(() => _isCreating = false);

        if (game != null) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          widget.onGameCreated?.call();
        } else {
          // Don't close the sheet so user can see their data
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Failed to create game. Check console for details.'),
              backgroundColor: Colors.red,
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
    } catch (e) {
      print('=== ERROR IN HANDLE CREATE GAME ===');
      print('Error: $e');
      if (mounted) {
        setState(() => _isCreating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }
}
