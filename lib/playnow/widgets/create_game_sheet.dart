import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:ui';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF121212),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, color: Colors.white),
                      tooltip: 'Close',
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Set up your game and invite players',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 14,
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Date',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat('MMM dd, yyyy').format(_gameDate),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: InkWell(
                      onTap: _selectTime,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.15),
                                width: 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Time',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _startTime.format(context),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                    icon: const Icon(Icons.remove_circle_outline, color: Colors.white),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        '$_playersNeeded players',
                        style: const TextStyle(
                          color: Colors.white,
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
                    icon: const Icon(Icons.add_circle_outline, color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Cost per player',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    prefixText: '₹',
                    prefixStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
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
                    child: CircularProgressIndicator(color: Color(0xFFFF6B35)),
                  ),
                )
              else
                DropdownButtonFormField<int>(
                  isExpanded: true,
                  dropdownColor: const Color(0xFF1E1E1E),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Select Venue',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    hintText: 'Choose a venue',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    prefixIcon: const Icon(Icons.location_on, color: Colors.white),
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
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Custom Location',
                    labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                    hintText: 'Enter custom location',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white.withValues(alpha: 0.08),
                    prefixIcon: const Icon(Icons.edit_location, color: Colors.white),
                  ),
                  onChanged: (value) => _customLocation = value,
                  initialValue: _customLocation,
                ),
              ] else if (_selectedVenue != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.withValues(alpha: 0.15),
                    border:
                        Border.all(color: Colors.green.withValues(alpha: 0.4), width: 1.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green[400], size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedVenue!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                            if (_selectedVenue!.address != null)
                              Text(
                                _selectedVenue!.address!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withValues(alpha: 0.6),
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
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  hintText: 'Add any additional details...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.15)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFFFF6B35), width: 2),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.08),
                ),
                maxLines: 3,
                onChanged: (value) => _description = value,
              ),
              const SizedBox(height: 20),

              // Advanced Options - Collapsible
              Theme(
                data: ThemeData.dark().copyWith(
                  dividerColor: Colors.transparent,
                ),
                child: ExpansionTile(
                  title: const Text(
                    'Advanced Options',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  iconColor: Colors.white,
                  collapsedIconColor: Colors.white,
                  initiallyExpanded: false,
                  children: [
                    CheckboxListTile(
                      title: const Text('Venue Booked', style: TextStyle(color: Colors.white)),
                      value: _isVenueBooked,
                      onChanged: (value) =>
                          setState(() => _isVenueBooked = value!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      activeColor: const Color(0xFFFF6B35),
                      checkColor: Colors.white,
                    ),
                    CheckboxListTile(
                      title: const Text('Women Only', style: TextStyle(color: Colors.white)),
                      value: _isWomenOnly,
                      onChanged: (value) => setState(() => _isWomenOnly = value!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      activeColor: const Color(0xFFFF6B35),
                      checkColor: Colors.white,
                    ),
                    CheckboxListTile(
                      title: const Text('Mixed Doubles Only', style: TextStyle(color: Colors.white)),
                      value: _isMixedOnly,
                      onChanged: (value) => setState(() => _isMixedOnly = value!),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      activeColor: const Color(0xFFFF6B35),
                      checkColor: Colors.white,
                    ),
                  ],
                ),
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
    ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildSportChip(String label, String value) {
    final isSelected = _sportType == value;
    return InkWell(
      onTap: () => setState(() => _sportType = value),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGameTypeChip(String label, String value, int defaultPlayers) {
    final isSelected = _gameType == value;
    return InkWell(
      onTap: () => setState(() {
        _gameType = value;
        _playersNeeded = defaultPlayers;
      }),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillLevelChip(String label, int? value) {
    final isSelected = _skillLevel == value;
    return InkWell(
      onTap: () => setState(() => _skillLevel = isSelected ? null : value),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCostChip(String label, bool isFree) {
    final isSelected = _isFree == isFree;
    return InkWell(
      onTap: () => setState(() => _isFree = isFree),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJoinTypeChip(String label, String value) {
    final isSelected = _joinType == value;
    return InkWell(
      onTap: () => setState(() => _joinType = value),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? const LinearGradient(
                      colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                    )
                  : null,
              color: isSelected ? null : Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B35),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _gameDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime,
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFFF6B35),
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogTheme: const DialogThemeData(
              backgroundColor: Color(0xFF1E1E1E),
            ),
          ),
          child: child!,
        );
      },
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
