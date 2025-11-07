import 'package:flutter/material.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/services/profile_completion_service.dart';
import '/playnow/services/offers_service.dart';

class SportsSelectionScreen extends StatefulWidget {
  const SportsSelectionScreen({
    super.key,
    required this.name,
    required this.gender,
    this.referralCode,
  });

  static String routeName = 'SportsSelection';
  static String routePath = '/sportsSelection';

  final String name;
  final String gender;
  final String? referralCode;

  @override
  State<SportsSelectionScreen> createState() => _SportsSelectionScreenState();
}

class _SportsSelectionScreenState extends State<SportsSelectionScreen> {
  final Set<String> _selectedSports = {};
  final Map<String, int> _skillLevels = {};
  bool _isLoading = false;

  Future<void> _completeSetup() async {
    if (_selectedSports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select at least one sport'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
      return;
    }

    // Check if all selected sports have skill levels
    for (final sport in _selectedSports) {
      if (!_skillLevels.containsKey(sport)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select skill level for $sport'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
        return;
      }
    }

    setState(() => _isLoading = true);

    try {
      final service = ProfileCompletionService(SupaFlow.client);

      // Create user profile
      await service.createUserProfile(
        userId: currentUserUid,
        firstName: widget.name,
        gender: widget.gender,
        preferredSports: _selectedSports.toList(),
        email: currentUserEmail.isNotEmpty ? currentUserEmail : null,
        phoneNumber: currentPhoneNumber.isNotEmpty ? currentPhoneNumber : null,
      );

      // Update skill levels
      for (final entry in _skillLevels.entries) {
        await service.updateSkillLevel(
          userId: currentUserUid,
          sport: entry.key,
          level: entry.value,
        );
      }

      // Apply referral code if provided
      if (widget.referralCode != null && widget.referralCode!.isNotEmpty) {
        try {
          final success = await OffersService.applyReferralCode(
            newUserId: currentUserUid,
            referralCode: widget.referralCode!.toUpperCase().trim(),
          );

          if (success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('🎉 Referral code applied! You got 50% OFF your first game!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 4),
              ),
            );
          } else if (!success && mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Invalid referral code'),
                backgroundColor: Colors.orange,
                duration: Duration(seconds: 3),
              ),
            );
          }
        } catch (e) {
          print('Error applying referral code: $e');
          // Don't block signup if referral fails
        }
      }

      setState(() => _isLoading = false);

      if (mounted) {
        // Navigate to home screen
        context.goNamed('HomeNew');
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: FlutterFlowTheme.of(context).error,
          ),
        );
      }
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
                              color: Color(0xFF6C63FF),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    // Step indicator
                    Text(
                      'Step 2 of 2',
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
                      'What do you\nlike to play?',
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
                      'Select sports and your skill level',
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
                    SizedBox(height: 40),

                    // Sport selection cards
                    _buildSportCard(
                      title: 'Badminton',
                      icon: Icons.sports_tennis,
                      sport: 'badminton',
                    ),
                    SizedBox(height: 16),

                    _buildSportCard(
                      title: 'Pickleball',
                      icon: Icons.sports_baseball,
                      sport: 'pickleball',
                    ),
                    SizedBox(height: 40),

                    // Complete Setup button - Glassy theme style
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
                              onTap: _isLoading ? null : _completeSetup,
                              borderRadius: BorderRadius.circular(30),
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: _isLoading
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                          ),
                                        )
                                      : Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Complete Setup',
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

  Widget _buildSportCard({
    required String title,
    required IconData icon,
    required String sport,
  }) {
    final isSelected = _selectedSports.contains(sport);
    final selectedLevel = _skillLevels[sport];

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(isSelected ? 0.15 : 0.1),
                Colors.white.withOpacity(isSelected ? 0.1 : 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: isSelected
                  ? Color(0xFF6C63FF)
                  : Colors.white.withOpacity(0.2),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              // Sport header
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        _selectedSports.remove(sport);
                        _skillLevels.remove(sport);
                      } else {
                        _selectedSports.add(sport);
                      }
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Color(0xFF6C63FF)
                                : Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            icon,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Text(
                            title,
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).tertiary,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Icon(
                          isSelected
                              ? Icons.check_circle
                              : Icons.circle_outlined,
                          color: isSelected
                              ? Color(0xFF6C63FF)
                              : Colors.white.withOpacity(0.3),
                          size: 28,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Skill level selector (shown when selected)
              if (isSelected) ...[
                Divider(
                  color: Colors.white.withOpacity(0.1),
                  height: 1,
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Skill Level',
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
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: List.generate(5, (index) {
                          final level = index + 1;
                          final isLevelSelected = selectedLevel == level;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _skillLevels[sport] = level;
                              });
                            },
                            child: Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isLevelSelected
                                    ? Color(0xFF6C63FF)
                                    : Colors.white.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isLevelSelected
                                      ? Color(0xFF6C63FF)
                                      : Colors.white.withOpacity(0.2),
                                  width: isLevelSelected ? 2 : 1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  '$level',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Beginner',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context)
                                  .tertiary
                                  .withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            'Expert',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context)
                                  .tertiary
                                  .withOpacity(0.5),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
