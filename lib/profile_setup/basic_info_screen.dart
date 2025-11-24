import 'package:flutter/material.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/profile_setup/sports_selection_screen.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';

class BasicInfoScreen extends StatefulWidget {
  const BasicInfoScreen({super.key});

  static String routeName = 'BasicInfo';
  static String routePath = '/basicInfo';

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _referralCodeController = TextEditingController();
  String? _selectedGender;
  bool _isLoadingName = true;

  @override
  void initState() {
    super.initState();
    _loadExistingName();
  }

  /// Load existing name from Supabase or Firebase (for Apple/Google Sign In)
  Future<void> _loadExistingName() async {
    try {
      final userId = currentUserUid;
      if (userId.isEmpty) {
        setState(() => _isLoadingName = false);
        return;
      }

      // First try to get name from Supabase
      final userProfile = await SupaFlow.client
          .from('users')
          .select('first_name')
          .eq('user_id', userId)
          .maybeSingle();

      if (userProfile != null && userProfile['first_name'] != null) {
        final firstName = userProfile['first_name'] as String;
        if (firstName.isNotEmpty) {
          _nameController.text = firstName;
          print('DEBUG: Pre-filled name from Supabase: $firstName');
        }
      } else {
        // Fallback to Firebase displayName (set by Apple/Google Sign In)
        final displayName = currentUserDisplayName;
        if (displayName.isNotEmpty) {
          _nameController.text = displayName;
          print('DEBUG: Pre-filled name from Firebase: $displayName');
        }
      }
    } catch (e) {
      print('DEBUG: Error loading existing name: $e');
      // Fallback to Firebase displayName
      final displayName = currentUserDisplayName;
      if (displayName.isNotEmpty) {
        _nameController.text = displayName;
      }
    } finally {
      if (mounted) {
        setState(() => _isLoadingName = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _referralCodeController.dispose();
    super.dispose();
  }

  void _continue() {
    if (_formKey.currentState!.validate() && _selectedGender != null) {
      // Navigate to sports selection
      context.pushNamed(
        SportsSelectionScreen.routeName,
        queryParameters: {
          'name': serializeParam(_nameController.text, ParamType.String),
          'gender': serializeParam(_selectedGender, ParamType.String),
          'referralCode': serializeParam(
            _referralCodeController.text.isNotEmpty
              ? _referralCodeController.text
              : null,
            ParamType.String
          ),
        }.withoutNulls,
      );
    } else if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select your gender'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back navigation
      child: Scaffold(
        backgroundColor: FlutterFlowTheme.of(context).secondary,
        body: SafeArea(
        child: Stack(
          children: [
            // Background gradient blobs
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFF6C63FF).withOpacity(0.3),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),

                    // Progress indicator
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Color(0xFF6C63FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Step indicator
                    Text(
                      'Step 1 of 2',
                      style: TextStyle(
                        color: FlutterFlowTheme.of(context)
                            .tertiary
                            .withOpacity(0.6),
                        fontSize: 14,
                        letterSpacing: 0.5,
                      ),
                    ),
                    SizedBox(height: 30),

                    // Title
                    Text(
                      'Tell us about\nyourself',
                      style: FlutterFlowTheme.of(context).displayMedium.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).displayMediumFamily,
                            color: FlutterFlowTheme.of(context).tertiary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).displayMediumIsCustom,
                          ),
                    ),
                    SizedBox(height: 12),

                    Text(
                      'This helps us personalize your experience',
                      style: FlutterFlowTheme.of(context).bodyLarge.override(
                            fontFamily:
                                FlutterFlowTheme.of(context).bodyLargeFamily,
                            color: FlutterFlowTheme.of(context)
                                .tertiary
                                .withOpacity(0.6),
                            fontSize: 16,
                            letterSpacing: 0.2,
                            useGoogleFonts:
                                !FlutterFlowTheme.of(context).bodyLargeIsCustom,
                          ),
                    ),
                    SizedBox(height: 50),

                    // Form
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // Name input
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Your Name',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary
                                            .withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    TextFormField(
                                      controller: _nameController,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).tertiary,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter your name',
                                        hintStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary
                                              .withOpacity(0.3),
                                          fontSize: 18,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Color(0xFF6C63FF),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                      ),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter your name';
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Gender selection
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Gender',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary
                                            .withOpacity(0.7),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: _buildGenderOption('Male', Icons.man),
                                        ),
                                        SizedBox(width: 12),
                                        Expanded(
                                          child: _buildGenderOption('Female', Icons.woman),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),

                          // Referral Code input (Optional)
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                              child: Container(
                                padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.white.withOpacity(0.1),
                                      Colors.white.withOpacity(0.05),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.card_giftcard_rounded,
                                          color: Color(0xFF6C63FF),
                                          size: 20,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Referral Code',
                                          style: TextStyle(
                                            color: FlutterFlowTheme.of(context)
                                                .tertiary
                                                .withOpacity(0.7),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                        SizedBox(width: 6),
                                        Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                              color: Colors.green.withOpacity(0.4),
                                            ),
                                          ),
                                          child: Text(
                                            'OPTIONAL',
                                            style: TextStyle(
                                              color: Colors.green.shade300,
                                              fontSize: 10,
                                              fontWeight: FontWeight.w700,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      'Have a referral code? Get 50% OFF your first game!',
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .tertiary
                                            .withOpacity(0.5),
                                        fontSize: 12,
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    TextFormField(
                                      controller: _referralCodeController,
                                      textCapitalization: TextCapitalization.characters,
                                      style: TextStyle(
                                        color: FlutterFlowTheme.of(context).tertiary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 1.5,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Enter code (e.g., ABC1234)',
                                        hintStyle: TextStyle(
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary
                                              .withOpacity(0.3),
                                          fontSize: 16,
                                          letterSpacing: 0,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white.withOpacity(0.1),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Colors.white.withOpacity(0.2),
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(
                                            color: Color(0xFF6C63FF),
                                            width: 2,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 16,
                                        ),
                                        prefixIcon: Icon(
                                          Icons.confirmation_number_outlined,
                                          color: FlutterFlowTheme.of(context)
                                              .tertiary
                                              .withOpacity(0.5),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 40),

                    // Continue button - Glassy theme style
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.3),
                                FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            border: Border.all(
                              color: FlutterFlowTheme.of(context)
                                  .primary
                                  .withValues(alpha: 0.4),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: FlutterFlowTheme.of(context)
                                    .primary
                                    .withValues(alpha: 0.2),
                                blurRadius: 20,
                                offset: Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _continue,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Continue',
                                        style: TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildGenderOption(String gender, IconData icon) {
    final isSelected = _selectedGender == gender.toLowerCase();

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedGender = gender.toLowerCase();
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Color(0xFF6C63FF).withOpacity(0.3)
              : Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? Color(0xFF6C63FF)
                : Colors.white.withOpacity(0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Color(0xFF6C63FF)
                  : FlutterFlowTheme.of(context).tertiary.withOpacity(0.6),
              size: 32,
            ),
            SizedBox(height: 8),
            Text(
              gender,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : FlutterFlowTheme.of(context).tertiary.withOpacity(0.6),
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
