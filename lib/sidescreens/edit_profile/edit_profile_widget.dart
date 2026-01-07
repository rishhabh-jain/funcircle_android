import 'dart:ui';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'edit_profile_model.dart';
export 'edit_profile_model.dart';

class EditProfileWidget extends StatefulWidget {
  const EditProfileWidget({super.key});

  static String routeName = 'editProfile';
  static String routePath = '/editProfile';

  @override
  State<EditProfileWidget> createState() => _EditProfileWidgetState();
}

class _EditProfileWidgetState extends State<EditProfileWidget> {
  late EditProfileModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProfileModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<UsersRow>>(
      future: UsersTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('user_id', currentUserUid),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: Colors.orange,
                  size: 50.0,
                ),
              ),
            ),
          );
        }

        final userData = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;

        // Initialize form controllers with current data
        if (!_model.isInitialized && userData != null) {
          _model.initializeWithUserData(userData);
        }

        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.light,
          ),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
              FocusManager.instance.primaryFocus?.unfocus();
            },
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: const Color(0xFF121212),
              body: Stack(
                children: [
                  // Background pattern
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _BackgroundPatternPainter(),
                    ),
                  ),

                  // Main content
                  SafeArea(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // Title
                          Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Update your profile information',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // First Name
                          _buildGlassTextField(
                            label: 'First Name',
                            controller: _model.firstNameController,
                            icon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Location (City Picker)
                          _buildGlassDropdown(
                            label: 'Location',
                            value: _model.selectedCity,
                            items: [
                              'Mumbai',
                              'Delhi',
                              'Bangalore',
                              'Hyderabad',
                              'Ahmedabad',
                              'Chennai',
                              'Kolkata',
                              'Pune',
                              'Jaipur',
                              'Surat',
                              'Lucknow',
                              'Kanpur',
                              'Nagpur',
                              'Indore',
                              'Thane',
                              'Bhopal',
                              'Visakhapatnam',
                              'Pimpri-Chinchwad',
                              'Patna',
                              'Vadodara',
                              'Ghaziabad',
                              'Gurugram',
                              'Ludhiana',
                              'Agra',
                              'Nashik',
                              'Faridabad',
                              'Meerut',
                              'Rajkot',
                              'Kalyan-Dombivali',
                              'Vasai-Virar',
                              'Varanasi',
                              'Srinagar',
                              'Aurangabad',
                              'Dhanbad',
                              'Amritsar',
                              'Navi Mumbai',
                              'Allahabad',
                              'Ranchi',
                              'Howrah',
                              'Coimbatore',
                              'Jabalpur',
                              'Gwalior',
                              'Vijayawada',
                              'Jodhpur',
                              'Madurai',
                              'Raipur',
                              'Kota',
                              'Chandigarh',
                              'Guwahati',
                              'Solapur',
                              'Other',
                            ],
                            onChanged: (value) => setState(() => _model.selectedCity = value),
                            icon: Icons.location_city_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Date of Birth
                          _buildGlassDateField(
                            label: 'Date of Birth',
                            value: _model.selectedDate,
                            onTap: () => _selectDate(context),
                            icon: Icons.cake_outlined,
                          ),
                          const SizedBox(height: 16),

                          // Bio
                          _buildGlassTextField(
                            label: 'Bio',
                            controller: _model.bioController,
                            icon: Icons.edit_note_rounded,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 24),

                          // Skill Levels Section
                          _buildGlassSection(
                            title: 'Skill Levels',
                            child: Column(
                              children: [
                                _buildSkillLevelSelector(
                                  'Badminton',
                                  _model.badmintonSkillLevel,
                                  (level) => setState(() => _model.badmintonSkillLevel = level),
                                ),
                                const SizedBox(height: 16),
                                _buildSkillLevelSelector(
                                  'Pickleball',
                                  _model.pickleballSkillLevel,
                                  (level) => setState(() => _model.pickleballSkillLevel = level),
                                ),
                                const SizedBox(height: 16),
                                _buildSkillLevelSelector(
                                  'Tennis',
                                  _model.tennisSkillLevel,
                                  (level) => setState(() => _model.tennisSkillLevel = level),
                                ),
                                const SizedBox(height: 16),
                                _buildSkillLevelSelector(
                                  'Padel',
                                  _model.padelSkillLevel,
                                  (level) => setState(() => _model.padelSkillLevel = level),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Preferred Sports Section
                          _buildGlassSection(
                            title: 'Preferred Sports',
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _buildSportChip('Badminton', Icons.sports_tennis_rounded),
                                _buildSportChip('Pickleball', Icons.sports_baseball_rounded),
                                _buildSportChip('Tennis', Icons.sports_tennis_rounded),
                                _buildSportChip('Basketball', Icons.sports_basketball_rounded),
                                _buildSportChip('Football', Icons.sports_soccer_rounded),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Height
                          _buildGlassTextField(
                            label: 'Height (e.g., 5\'10")',
                            controller: _model.heightController,
                            icon: Icons.height_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Workout Status
                          _buildGlassDropdown(
                            label: 'Workout Status',
                            value: _model.workoutStatus,
                            items: [
                              'Active',
                              'Sometimes',
                              'Never',
                            ],
                            onChanged: (value) => setState(() => _model.workoutStatus = value),
                            icon: Icons.fitness_center_rounded,
                          ),
                          const SizedBox(height: 16),

                          // College
                          _buildGlassTextField(
                            label: 'College',
                            controller: _model.collegeController,
                            icon: Icons.school_outlined,
                          ),
                          const SizedBox(height: 16),

                          // Work/Company
                          _buildGlassTextField(
                            label: 'Company',
                            controller: _model.companyController,
                            icon: Icons.work_outline_rounded,
                          ),
                          const SizedBox(height: 16),

                          // Hometown
                          _buildGlassTextField(
                            label: 'Hometown',
                            controller: _model.hometownController,
                            icon: Icons.home_outlined,
                          ),
                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),

                  // Floating Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top + 8,
                    left: 8,
                    child: _buildFloatingButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => context.pop(),
                    ),
                  ),

                  // Floating Save Button
                  Positioned(
                    bottom: 24,
                    left: 20,
                    right: 20,
                    child: _buildSaveButton(userData),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGlassTextField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: maxLines > 1 ? CrossAxisAlignment.start : CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.orange, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    TextField(
                      controller: controller,
                      maxLines: maxLines,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: 'Enter $label',
                        hintStyle: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
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
    );
  }

  Widget _buildGlassDateField({
    required String label,
    required DateTime? value,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return InkWell(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(icon, color: Colors.orange, size: 24),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value != null
                            ? DateFormat('MMMM d, yyyy').format(value)
                            : 'Select date',
                        style: TextStyle(
                          color: value != null ? Colors.white : Colors.white.withValues(alpha: 0.3),
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.calendar_today_rounded,
                  color: Colors.white.withValues(alpha: 0.5),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGlassDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    required IconData icon,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(icon, color: Colors.orange, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DropdownButton<String>(
                      value: value,
                      isExpanded: true,
                      isDense: true,
                      underline: const SizedBox(),
                      dropdownColor: const Color(0xFF1E1E1E),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      hint: Text(
                        'Select $label',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      ),
                      items: items.map((String item) {
                        return DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: onChanged,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGlassSection({
    required String title,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSkillLevelSelector(String sport, int level, Function(int) onLevelChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          sport,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.8),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(5, (index) {
            final starLevel = index + 1;
            return GestureDetector(
              onTap: () => onLevelChanged(starLevel),
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon(
                  starLevel <= level ? Icons.star_rounded : Icons.star_border_rounded,
                  color: starLevel <= level ? Colors.orange : Colors.white.withValues(alpha: 0.3),
                  size: 32,
                ),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSportChip(String sport, IconData icon) {
    final isSelected = _model.preferredSports.contains(sport);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) {
            _model.preferredSports.remove(sport);
          } else {
            _model.preferredSports.add(sport);
          }
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Colors.orange.withValues(alpha: 0.2)
                  : Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? Colors.orange.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.orange : Colors.white.withValues(alpha: 0.7),
                  size: 18,
                ),
                const SizedBox(width: 8),
                Text(
                  sport,
                  style: TextStyle(
                    color: isSelected ? Colors.orange : Colors.white.withValues(alpha: 0.7),
                    fontSize: 14,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onPressed,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSaveButton(UsersRow? userData) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.orange.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _saveProfile(userData),
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                    SizedBox(width: 12),
                    Text(
                      'Save Changes',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _model.selectedDate ?? DateTime.now().subtract(const Duration(days: 365 * 20)),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.orange,
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
    if (picked != null && picked != _model.selectedDate) {
      setState(() {
        _model.selectedDate = picked;
      });
    }
  }

  Future<void> _saveProfile(UsersRow? userData) async {
    if (userData == null) return;

    try {
      // Show loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: const [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
              SizedBox(width: 16),
              Text('Saving changes...'),
            ],
          ),
          backgroundColor: const Color(0xFF1E1E1E),
        ),
      );

      // Prepare update data
      // Map display values to database values for workout_status
      String? dbWorkoutStatus;
      if (_model.workoutStatus != null) {
        switch (_model.workoutStatus) {
          case 'Active':
            dbWorkoutStatus = 'regularly';
            break;
          case 'Sometimes':
            dbWorkoutStatus = 'sometimes';
            break;
          case 'Never':
            dbWorkoutStatus = 'not active';
            break;
          default:
            dbWorkoutStatus = _model.workoutStatus;
        }
      }

      final updateData = {
        'first_name': _model.firstNameController.text.trim(),
        'location': _model.selectedCity,
        'birthday': _model.selectedDate?.toIso8601String(),
        'bio': _model.bioController.text.trim(),
        'skill_level_badminton': _model.badmintonSkillLevel,
        'skill_level_pickleball': _model.pickleballSkillLevel,
        'skill_level_tennis': _model.tennisSkillLevel,
        'skill_level_padel': _model.padelSkillLevel,
        'preferred_sports': _model.preferredSports,
        'height': _model.heightController.text.trim(),
        'workout_status': dbWorkoutStatus,
        'college': _model.collegeController.text.trim(),
        'company': _model.companyController.text.trim(),
        'hometown': _model.hometownController.text.trim(),
      };

      // Update in Supabase
      await UsersTable().update(
        data: updateData,
        matchingRows: (rows) => rows.eq('user_id', currentUserUid),
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.green),
                SizedBox(width: 16),
                Text('Profile updated successfully!'),
              ],
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            duration: const Duration(seconds: 2),
          ),
        );

        // Go back after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          context.pop();
        }
      }
    } catch (e) {
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline_rounded, color: Colors.red),
                const SizedBox(width: 16),
                Expanded(
                  child: Text('Error saving profile: ${e.toString()}'),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF1E1E1E),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }
}

// Background pattern painter
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.03);

    // Draw circles
    for (int i = 0; i < 5; i++) {
      canvas.drawCircle(
        Offset(size.width * 0.8, size.height * (0.2 + i * 0.2)),
        30 + i * 10,
        paint,
      );
    }

    // Draw lines
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * i * 0.1),
        Offset(size.width * 0.3, size.height * i * 0.1),
        paint,
      );
    }

    // Add orange gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange.withValues(alpha: 0.05),
          Colors.transparent,
          Colors.orange.withValues(alpha: 0.02),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      gradientPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
