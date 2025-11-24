import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/game_organizer_model.dart';

/// Application form page for becoming a game organizer
class OrganizerApplicationPage extends StatefulWidget {
  const OrganizerApplicationPage({super.key});

  static const String routeName = 'organizerApplication';
  static const String routePath = '/organizerApplication';

  @override
  State<OrganizerApplicationPage> createState() =>
      _OrganizerApplicationPageState();
}

class _OrganizerApplicationPageState extends State<OrganizerApplicationPage> {
  final _formKey = GlobalKey<FormState>();
  final _mobileController = TextEditingController();
  final _bioController = TextEditingController();
  final _experienceController = TextEditingController();

  // Form fields
  String? selectedSport;
  int skillLevel = 3;
  int? selectedVenueId;
  String? selectedVenueName;
  Set<String> selectedDays = {};
  List<TimeSlotModel> timeSlots = [];
  bool _agreedToTerms = false;

  bool isSubmitting = false;
  bool isLoadingVenues = true;
  bool isLoadingExisting = true;
  bool isEditMode = false;
  String? existingApplicationId;
  String? existingApplicationStatus;
  List<Map<String, dynamic>> venues = [];

  @override
  void initState() {
    super.initState();
    _checkExistingApplication();
  }

  @override
  void dispose() {
    _mobileController.dispose();
    _bioController.dispose();
    _experienceController.dispose();
    super.dispose();
  }

  Future<void> _checkExistingApplication() async {
    try {
      final response = await SupaFlow.client
          .schema('playnow')
          .from('game_organizers')
          .select()
          .eq('user_id', currentUserUid)
          .maybeSingle();

      if (response != null) {
        // User already has an application
        setState(() {
          isEditMode = true;
          existingApplicationId = response['id'] as String;
          existingApplicationStatus = response['status'] as String;
          selectedSport = response['sport_type'] as String;
          selectedVenueId = response['venue_id'] as int;
          skillLevel = response['skill_level'] as int;
          _mobileController.text = response['mobile_number'] as String;
          _bioController.text = response['bio'] as String? ?? '';
          _experienceController.text = response['experience'] as String? ?? '';

          // Parse days
          if (response['available_days'] is List) {
            selectedDays = (response['available_days'] as List).cast<String>().toSet();
          }

          // Parse time slots
          if (response['available_time_slots'] is List) {
            timeSlots = (response['available_time_slots'] as List)
                .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
                .toList();
          }

          _agreedToTerms = true; // Already agreed when first submitted
        });
      }

      setState(() {
        isLoadingExisting = false;
      });

      // Load venues after checking existing application
      _loadVenues();
    } catch (e) {
      setState(() {
        isLoadingExisting = false;
      });
      _loadVenues();
    }
  }

  Future<void> _loadVenues() async {
    if (selectedSport == null) {
      setState(() {
        venues = [];
        isLoadingVenues = false;
      });
      return;
    }

    setState(() {
      isLoadingVenues = true;
    });

    try {
      // Load all venues and filter on client side (matching create_game_sheet behavior)
      final response = await SupaFlow.client
          .from('venues')
          .select('id, venue_name, sport_type, city')
          .order('venue_name');

      final allVenues = (response as List).cast<Map<String, dynamic>>();

      // Filter venues: match selected sport OR 'both'
      final filteredVenues = allVenues.where((venue) {
        final sportType = venue['sport_type'] as String?;
        if (sportType == null) return true;
        return sportType == selectedSport || sportType == 'both';
      }).toList();

      setState(() {
        venues = filteredVenues;
        isLoadingVenues = false;
        // Reset selected venue if it doesn't match the new sport
        if (selectedVenueId != null) {
          final venueExists = venues.any((v) => v['id'] == selectedVenueId);
          if (!venueExists) {
            selectedVenueId = null;
            selectedVenueName = null;
          }
        }
      });
    } catch (e) {
      setState(() => isLoadingVenues = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading venues: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // If application is approved or suspended, show read-only view
    if (isEditMode &&
        existingApplicationStatus != null &&
        (existingApplicationStatus == 'approved' || existingApplicationStatus == 'suspended')) {
      return _buildReadOnlyView();
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              isEditMode ? 'Edit Application' : 'Organizer Application',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            if (isEditMode && existingApplicationStatus != null)
              Text(
                'Status: ${existingApplicationStatus!.toUpperCase()}',
                style: TextStyle(
                  color: _getStatusColor(existingApplicationStatus!),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Sport Type
            const Text(
              'Sport',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              initialValue: selectedSport,
              dropdownColor: const Color(0xFF1E1E1E),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                hintText: 'Select sport',
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              style: const TextStyle(color: Colors.white),
              items: const [
                DropdownMenuItem(
                    value: 'badminton', child: Text('🏸 Badminton')),
                DropdownMenuItem(
                    value: 'pickleball', child: Text('🎾 Pickleball')),
              ],
              onChanged: (value) {
                setState(() {
                  selectedSport = value;
                });
                _loadVenues();
              },
              validator: (value) =>
                  value == null ? 'Please select a sport' : null,
            ),

            const SizedBox(height: 24),

            // Skill Level
            const Text(
              'Your Skill Level',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildSkillLevelSlider(),

            const SizedBox(height: 24),

            // Venue Selection
            const Text(
              'Venue',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildVenueDropdown(),

            const SizedBox(height: 24),

            // Mobile Number
            const Text(
              'Mobile Number',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _mobileController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                prefixIcon: const Icon(Icons.phone, color: Colors.white),
              ),
              keyboardType: TextInputType.phone,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9+\s]')),
              ],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mobile number';
                }
                if (value.replaceAll(RegExp(r'[^0-9]'), '').length < 10) {
                  return 'Please enter valid mobile number';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Available Days
            const Text(
              'Available Days',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Select at least 2 days',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 8),
            _buildDaySelector(),

            const SizedBox(height: 24),

            // Time Slots
            const Text(
              'Available Time Slots',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            _buildTimeSlotSelector(),

            const SizedBox(height: 24),

            // Bio
            const Text(
              'Why do you want to organize games?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Minimum 50 characters',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _bioController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                hintText: 'Tell us about your motivation...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              maxLines: 4,
              maxLength: 500,
              validator: (value) {
                if (value == null || value.length < 50) {
                  return 'Please write at least 50 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Experience
            const Text(
              'Your playing experience',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Minimum 30 characters',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _experienceController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E1E1E),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                hintText: 'Share your badminton/pickleball journey...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
              ),
              maxLines: 3,
              maxLength: 300,
              validator: (value) {
                if (value == null || value.length < 30) {
                  return 'Please write at least 30 characters';
                }
                return null;
              },
            ),

            const SizedBox(height: 24),

            // Game Format Info
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade400.withValues(alpha: 0.15),
                    Colors.blue.shade600.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.blue.shade400.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.blue.shade400, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Games will be organized in Mixed Doubles format',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Terms & Conditions
            InkWell(
              onTap: () {
                setState(() {
                  _agreedToTerms = !_agreedToTerms;
                });
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _agreedToTerms,
                    onChanged: (value) {
                      setState(() {
                        _agreedToTerms = value ?? false;
                      });
                    },
                    activeColor: Colors.greenAccent.shade700,
                    checkColor: Colors.white,
                    side: BorderSide(
                      color: Colors.white.withValues(alpha: 0.5),
                      width: 2,
                    ),
                    fillColor: WidgetStateProperty.resolveWith<Color>((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.greenAccent.shade700;
                      }
                      return Colors.transparent;
                    }),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Text(
                        'I agree to arrive 10 minutes early, commit to minimum 2 days/week, not cancel games, be point of contact for players, capture videos, and ensure smooth gameplay',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent.shade700,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: isSubmitting ? null : _submitApplication,
                child: isSubmitting
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        isEditMode ? 'Update Application' : 'Submit Application',
                        style: const TextStyle(fontSize: 16, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSkillLevelSlider() {
    final labels = [
      'Beginner',
      'Beginner-Intermediate',
      'Intermediate',
      'Upper Intermediate',
      'Advanced',
    ];

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Level',
                    style: TextStyle(color: Colors.white),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getSkillLevelColor(skillLevel),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$skillLevel - ${labels[skillLevel - 1]}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: skillLevel.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: _getSkillLevelColor(skillLevel),
                onChanged: (value) {
                  setState(() => skillLevel = value.toInt());
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getSkillLevelColor(int level) {
    switch (level) {
      case 1:
        return Colors.green.shade300;
      case 2:
        return Colors.lightGreen.shade300;
      case 3:
        return Colors.yellow.shade600;
      case 4:
        return Colors.orange.shade400;
      case 5:
        return Colors.deepOrange.shade400;
      default:
        return Colors.grey;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  Widget _buildVenueDropdown() {
    if (selectedSport == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Colors.grey.shade400, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                'Please select a sport first',
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ),
          ],
        ),
      );
    }

    if (isLoadingVenues) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return DropdownButtonFormField<int>(
      initialValue: selectedVenueId,
      isExpanded: true,
      dropdownColor: const Color(0xFF1E1E1E),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        hintText: 'Select venue',
        hintStyle: TextStyle(color: Colors.grey.shade400),
        prefixIcon: const Icon(Icons.location_on, color: Colors.white),
      ),
      style: const TextStyle(color: Colors.white),
      items: venues.map((venue) {
        return DropdownMenuItem<int>(
          value: venue['id'] as int,
          child: Text(
            '${venue['venue_name']} ${venue['city'] != null ? '(${venue['city']})' : ''}',
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          selectedVenueId = value;
          final venue = venues.firstWhere((v) => v['id'] == value);
          selectedVenueName = venue['venue_name'] as String?;
        });
      },
      validator: (value) => value == null ? 'Please select a venue' : null,
    );
  }

  Widget _buildDaySelector() {
    final days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: days.map((day) {
        final isSelected = selectedDays.contains(day.toLowerCase());
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                selectedDays.remove(day.toLowerCase());
              } else {
                selectedDays.add(day.toLowerCase());
              }
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        Colors.greenAccent.shade400,
                        Colors.greenAccent.shade700,
                      ],
                    )
                  : null,
              color: isSelected ? null : const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? Colors.greenAccent.shade400
                    : Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: Text(
              day.substring(0, 3).toUpperCase(),
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey.shade400,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTimeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Display existing slots
        if (timeSlots.isNotEmpty)
          ...timeSlots.asMap().entries.map((entry) {
            final index = entry.key;
            final slot = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    slot.format(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const Spacer(),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade700,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      slot.getTimeSlotLabel(),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => timeSlots.removeAt(index));
                    },
                  ),
                ],
              ),
            );
          }),

        const SizedBox(height: 8),

        // Add slot button
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.greenAccent.shade400),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: Icon(Icons.add, color: Colors.greenAccent.shade400),
          label: Text(
            'Add Time Slot',
            style: TextStyle(color: Colors.greenAccent.shade400),
          ),
          onPressed: () => _showAddTimeSlotDialog(),
        ),
      ],
    );
  }

  Future<void> _showAddTimeSlotDialog() async {
    TimeOfDay? startTime;
    TimeOfDay? endTime;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E1E1E),
          title: const Text(
            'Add Time Slot',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                icon: const Icon(Icons.access_time, color: Colors.white),
                label: Text(
                  startTime == null
                      ? 'Select Start Time'
                      : 'Start: ${startTime!.format(context)}',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => startTime = picked);
                  }
                },
              ),
              const SizedBox(height: 16),
              OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.white),
                ),
                icon: const Icon(Icons.access_time, color: Colors.white),
                label: Text(
                  endTime == null
                      ? 'Select End Time'
                      : 'End: ${endTime!.format(context)}',
                  style: const TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (picked != null) {
                    setDialogState(() => endTime = picked);
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent.shade700,
              ),
              onPressed: () {
                if (startTime != null && endTime != null) {
                  final startStr =
                      '${startTime!.hour.toString().padLeft(2, '0')}:${startTime!.minute.toString().padLeft(2, '0')}';
                  final endStr =
                      '${endTime!.hour.toString().padLeft(2, '0')}:${endTime!.minute.toString().padLeft(2, '0')}';

                  setState(() {
                    timeSlots.add(TimeSlotModel(
                      startTime: startStr,
                      endTime: endStr,
                    ));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (selectedSport == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sport')),
      );
      return;
    }

    if (selectedVenueId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a venue')),
      );
      return;
    }

    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please agree to the terms and conditions')),
      );
      return;
    }

    if (selectedDays.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select at least 2 available days')),
      );
      return;
    }

    if (timeSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one time slot')),
      );
      return;
    }

    setState(() => isSubmitting = true);

    try {
      final data = {
        'sport_type': selectedSport,
        'venue_id': selectedVenueId,
        'available_days': selectedDays.toList(),
        'available_time_slots':
            timeSlots.map((t) => t.toJson()).toList(),
        'skill_level': skillLevel,
        'mobile_number': _mobileController.text.trim(),
        'bio': _bioController.text.trim(),
        'experience': _experienceController.text.trim(),
      };

      if (isEditMode && existingApplicationId != null) {
        // Update existing application
        await SupaFlow.client
            .schema('playnow')
            .from('game_organizers')
            .update(data)
            .eq('id', existingApplicationId!);
      } else {
        // Insert new application
        data['user_id'] = currentUserUid;
        data['status'] = 'pending';
        await SupaFlow.client
            .schema('playnow')
            .from('game_organizers')
            .insert(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditMode
                ? 'Application updated successfully!'
                : 'Application submitted successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        // Navigate back to menu
        Navigator.pop(context);
        Navigator.pop(context);
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
        setState(() => isSubmitting = false);
      }
    }
  }

  Widget _buildReadOnlyView() {
    final statusMessage = existingApplicationStatus == 'approved'
        ? 'Your application has been approved! You can now start posting FunCircle PlayTime games.'
        : 'Your organizer account has been suspended. Please contact support for more information.';

    final statusIcon = existingApplicationStatus == 'approved'
        ? Icons.check_circle
        : Icons.block;

    final statusColor = _getStatusColor(existingApplicationStatus!);

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text(
          'Organizer Application',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    statusColor.withValues(alpha: 0.2),
                    statusColor.withValues(alpha: 0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: statusColor.withValues(alpha: 0.3),
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    statusIcon,
                    size: 64,
                    color: statusColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    existingApplicationStatus!.toUpperCase(),
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    statusMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Application Details
            const Text(
              'Application Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),

            _buildDetailRow('Sport', selectedSport?.toUpperCase() ?? 'N/A'),
            _buildDetailRow('Venue', selectedVenueName ?? 'N/A'),
            _buildDetailRow('Skill Level', 'Level $skillLevel'),
            _buildDetailRow('Mobile Number', _mobileController.text),
            _buildDetailRow(
              'Available Days',
              selectedDays.map((d) => d.substring(0, 3).toUpperCase()).join(', '),
            ),
            _buildDetailRow(
              'Time Slots',
              timeSlots.map((t) => t.format()).join(', '),
            ),

            if (_bioController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Bio',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _bioController.text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],

            if (_experienceController.text.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Experience',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.greenAccent,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _experienceController.text,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
            ],

            if (existingApplicationStatus == 'approved') ...[
              const SizedBox(height: 32),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.shade400.withValues(alpha: 0.15),
                      Colors.blue.shade600.withValues(alpha: 0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.shade400.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue.shade400, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'You can now create FunCircle PlayTime games from the PlayNow screen!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.greenAccent.shade400,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
