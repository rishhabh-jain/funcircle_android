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

  int _playersNeeded = 1;
  DateTime _selectedDate = DateTime.now().add(const Duration(hours: 2));
  TimeOfDay _selectedTime = TimeOfDay.now();
  int? _selectedSkillLevel;
  VenueMarkerModel? _selectedVenue;
  bool _useMyLocation = true;
  bool _isCreating = false;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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

              // Title
              Text(
                'Create Player Request',
                style: FlutterFlowTheme.of(context).headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'for ${widget.currentSport}',
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      fontFamily: 'Readex Pro',
                      color: Colors.grey,
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
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  hint: const Text('Choose a venue'),
                  items: widget.venues.map((venue) {
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
                    selectedColor: _hexToColor(level.hexColor).withOpacity(0.3),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),

              // Description
              Text(
                'Description (Optional)',
                style: FlutterFlowTheme.of(context).labelMedium,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Add any details about the game...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              ),
              const SizedBox(height: 24),

              // Create button
              FFButtonWidget(
                onPressed: _isCreating ? null : _handleCreate,
                text: _isCreating ? 'Creating...' : 'Create Request',
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

      // Create request
      final requestId = await MapService.createPlayerRequest(
        userId: widget.currentUserId,
        sportType: widget.currentSport,
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

      if (mounted) {
        Navigator.pop(context, requestId != null);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              requestId != null
                  ? 'Request created successfully!'
                  : 'Failed to create request. Please try again.',
            ),
            backgroundColor: requestId != null ? Colors.green : Colors.red,
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
