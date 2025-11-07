import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '../models/skill_level.dart';
import '../models/venue_marker_model.dart';
import '../services/map_service.dart';
import '../services/location_service.dart';

/// Bottom sheet for creating a new player request
class CreateRequestSheet extends StatefulWidget {
  final String currentUserId;
  final String currentSport;
  final List<VenueMarkerModel> venues;

  const CreateRequestSheet({
    super.key,
    required this.currentUserId,
    required this.currentSport,
    required this.venues,
  });

  @override
  State<CreateRequestSheet> createState() => _CreateRequestSheetState();
}

class _CreateRequestSheetState extends State<CreateRequestSheet> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _costController = TextEditingController();

  int _playersNeeded = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedSkillLevel;
  VenueMarkerModel? _selectedVenue;
  bool _useMyLocation = true;
  bool _isCreating = false;

  // Game-specific fields (shown when players >= 3)
  String _gameType = 'doubles';
  String _joinType = 'request';
  bool _isFree = true;
  bool _isWomenOnly = false;
  bool _isMixedOnly = false;
  bool _isVenueBooked = false;

  @override
  void initState() {
    super.initState();
    // Set time to nearest 30-minute mark
    final now = DateTime.now();
    _selectedTime = TimeOfDay(
      hour: now.hour + 2,
      minute: now.minute < 30 ? 30 : 0,
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _costController.dispose();
    super.dispose();
  }

  /// Check if creating organized game (3+ players) vs simple request (1-2 players)
  bool get _isCreatingGame => _playersNeeded >= 3;

  /// Get filtered venues based on current sport
  List<VenueMarkerModel> get _filteredVenues {
    return widget.venues.where((venue) {
      // Filter by sport type - show if venue supports current sport or both sports
      if (venue.sportType == null)
        return true; // Show venues without sport type
      if (venue.sportType == 'both')
        return true; // Show venues that support both sports
      if (venue.sportType == widget.currentSport)
        return true; // Show venues for current sport
      return false;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final maxHeight = screenHeight * 0.9; // 90% of screen height

    return Container(
      constraints: BoxConstraints(
        maxHeight: maxHeight,
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Form(
        key: _formKey,
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

              // Title with close button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isCreatingGame
                              ? 'Create Organized Game'
                              : 'Create Player Request',
                          style: FlutterFlowTheme.of(context).headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'for ${widget.currentSport}',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.grey,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    tooltip: 'Close',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Game mode indicator
              if (_isCreatingGame)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                        FlutterFlowTheme.of(context).primary.withValues(alpha: 0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sports,
                        color: FlutterFlowTheme.of(context).primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '3+ players! Creating an organized game with booking & payment options',
                          style: FlutterFlowTheme.of(context).bodySmall.override(
                                fontFamily: 'Readex Pro',
                                color: FlutterFlowTheme.of(context).primary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 24),

              // Players needed
              Text(
                'Players Needed',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  IconButton(
                    onPressed: _playersNeeded > 1
                        ? () => setState(() => _playersNeeded--)
                        : null,
                    icon: const Icon(Icons.remove_circle_outline),
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '$_playersNeeded',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: _playersNeeded < 10
                        ? () => setState(() => _playersNeeded++)
                        : null,
                    icon: const Icon(Icons.add_circle_outline),
                    color: FlutterFlowTheme.of(context).primary,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Date and Time
              Text(
                'When',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: _selectDate,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              DateFormat('MMM dd, yyyy').format(_selectedDate),
                              style: FlutterFlowTheme.of(context).bodyMedium,
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
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              _selectedTime.format(context),
                              style: FlutterFlowTheme.of(context).bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Location toggle
              Text(
                'Location',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('My Location'),
                      selected: _useMyLocation,
                      onSelected: (selected) {
                        setState(() => _useMyLocation = true);
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ChoiceChip(
                      label: const Text('Select Venue'),
                      selected: !_useMyLocation,
                      onSelected: (selected) {
                        setState(() => _useMyLocation = false);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Venue picker (if not using my location)
              if (!_useMyLocation)
                DropdownButtonFormField<VenueMarkerModel>(
                  value: _selectedVenue,
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text(
                    'Choose a venue',
                    overflow: TextOverflow.ellipsis,
                  ),
                  items: _filteredVenues.map((venue) {
                    return DropdownMenuItem(
                      value: venue,
                      child: Text(
                        venue.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() => _selectedVenue = value);
                  },
                ),
              const SizedBox(height: 20),

              // Skill level preference
              Text(
                'Skill Level Preference (Optional)',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: SkillLevel.values.map((level) {
                  return ChoiceChip(
                    label: Text(level.label),
                    selected: _selectedSkillLevel == level.value,
                    onSelected: (selected) {
                      setState(() {
                        _selectedSkillLevel = selected ? level.value : null;
                      });
                    },
                    selectedColor:
                        _hexToColor(level.hexColor).withValues(alpha: 0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                _isCreatingGame ? 'Game Details' : 'Description (Optional)',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: _isCreatingGame
                      ? 'Add details about the game (rules, level, etc.)'
                      : 'Add any details about the game...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 20),

              // ============ GAME-SPECIFIC OPTIONS (only for 3+ players) ============
              if (_isCreatingGame) ...[
                // Game Type
                Text(
                  'Game Type',
                  style: FlutterFlowTheme.of(context).labelMedium,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(
                      label: const Text('Singles'),
                      selected: _gameType == 'singles',
                      onSelected: (selected) {
                        setState(() => _gameType = 'singles');
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Doubles'),
                      selected: _gameType == 'doubles',
                      onSelected: (selected) {
                        setState(() => _gameType = 'doubles');
                      },
                    ),
                    ChoiceChip(
                      label: const Text('Mixed Doubles'),
                      selected: _gameType == 'mixed_doubles',
                      onSelected: (selected) {
                        setState(() => _gameType = 'mixed_doubles');
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Cost settings
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Free Game',
                        style: FlutterFlowTheme.of(context).labelMedium,
                      ),
                    ),
                    Switch(
                      value: _isFree,
                      onChanged: (value) {
                        setState(() => _isFree = value);
                      },
                      activeColor: FlutterFlowTheme.of(context).primary,
                    ),
                  ],
                ),
                if (!_isFree) ...[
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _costController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cost per Player',
                      prefixText: '₹ ',
                      hintText: '0.00',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    validator: (value) {
                      if (!_isFree && (value == null || value.isEmpty)) {
                        return 'Please enter cost per player';
                      }
                      return null;
                    },
                  ),
                ],
                const SizedBox(height: 20),

                // Join Type
                Text(
                  'Join Settings',
                  style: FlutterFlowTheme.of(context).labelMedium,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Request to Join'),
                        selected: _joinType == 'request',
                        onSelected: (selected) {
                          setState(() => _joinType = 'request');
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: const Text('Auto Join'),
                        selected: _joinType == 'auto',
                        onSelected: (selected) {
                          setState(() => _joinType = 'auto');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Gender filters
                Text(
                  'Player Preferences',
                  style: FlutterFlowTheme.of(context).labelMedium,
                ),
                const SizedBox(height: 8),
                CheckboxListTile(
                  title: const Text('Women Only'),
                  value: _isWomenOnly,
                  onChanged: (value) {
                    setState(() {
                      _isWomenOnly = value ?? false;
                      if (_isWomenOnly) _isMixedOnly = false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('Mixed Gender Only'),
                  value: _isMixedOnly,
                  onChanged: (value) {
                    setState(() {
                      _isMixedOnly = value ?? false;
                      if (_isMixedOnly) _isWomenOnly = false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                CheckboxListTile(
                  title: const Text('Venue Booked'),
                  subtitle: const Text('Court/venue is already reserved'),
                  value: _isVenueBooked,
                  onChanged: (value) {
                    setState(() {
                      _isVenueBooked = value ?? false;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.zero,
                ),
                const SizedBox(height: 4),
              ],
              // ============ END GAME-SPECIFIC OPTIONS ============

              // Create button
              FFButtonWidget(
                onPressed: _isCreating ? null : _handleCreate,
                text: _isCreating
                    ? 'Creating...'
                    : _isCreatingGame
                        ? 'Create Game'
                        : 'Post Request',
                icon: Icon(
                  _isCreatingGame ? Icons.sports : Icons.add,
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
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _selectTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _handleCreate() async {
    if (!_formKey.currentState!.validate()) return;

    // Validate venue selection if not using my location
    if (!_useMyLocation && _selectedVenue == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a venue')),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      // Get location
      double? latitude;
      double? longitude;
      int? venueId;

      if (_useMyLocation) {
        final location = await LocationService.getCurrentLocation();
        if (location == null) {
          throw Exception('Could not get your location');
        }
        latitude = location.latitude;
        longitude = location.longitude;
      } else {
        venueId = _selectedVenue!.id;
        latitude = _selectedVenue!.latitude;
        longitude = _selectedVenue!.longitude;
      }

      // Combine date and time
      final scheduledTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      String? resultId;

      if (_isCreatingGame) {
        // Create organized game (3+ players)
        final costPerPlayer = !_isFree && _costController.text.isNotEmpty
            ? double.tryParse(_costController.text)
            : null;

        resultId = await MapService.createGame(
          creatorId: widget.currentUserId,
          sportType: widget.currentSport.toLowerCase(),
          venueId: venueId,
          customLocation: _useMyLocation ? 'User Location' : null,
          playersNeeded: _playersNeeded,
          gameType: _gameType,
          scheduledTime: scheduledTime,
          skillLevel: _selectedSkillLevel,
          costPerPlayer: costPerPlayer,
          isFree: _isFree,
          joinType: _joinType,
          isWomenOnly: _isWomenOnly,
          isMixedOnly: _isMixedOnly,
          isVenueBooked: _isVenueBooked,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          latitude: latitude,
          longitude: longitude,
        );
      } else {
        // Create simple player request (1-2 players)
        resultId = await MapService.createPlayerRequest(
          userId: widget.currentUserId,
          sportType: widget.currentSport.toLowerCase(),
          venueId: venueId,
          latitude: latitude,
          longitude: longitude,
          playersNeeded: _playersNeeded,
          scheduledTime: scheduledTime,
          skillLevel: _selectedSkillLevel,
          description: _descriptionController.text.isNotEmpty
              ? _descriptionController.text
              : null,
          expiresAt: scheduledTime.add(const Duration(hours: 1)),
        );
      }

      if (mounted) {
        Navigator.pop(context, resultId != null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resultId != null
                  ? _isCreatingGame
                      ? 'Game created successfully!'
                      : 'Request posted successfully!'
                  : 'Failed to create. Please try again.',
            ),
            backgroundColor: resultId != null ? Colors.green : Colors.red,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isCreating = false);
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
