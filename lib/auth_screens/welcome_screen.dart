import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:ui';
import 'dart:io';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/services/profile_completion_service.dart';
import '/auth_screens/phone_auth_screen.dart';
import '/profile_setup/basic_info_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  static String routeName = 'Welcome';
  static String routePath = '/welcome';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  PageController? _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0, viewportFraction: 1.0);

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );

    // Auto-scroll carousel
    Future.delayed(Duration(seconds: 4), _autoScroll);
  }

  void _autoScroll() {
    if (!mounted) return;
    Future.delayed(Duration(seconds: 5), () {
      if (!mounted || _pageController == null || !_pageController!.hasClients)
        return;
      _pageController!.animateToPage(
        (_currentPage + 1) % 2,
        duration: Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      _autoScroll();
    });
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF131315),
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          // Feature carousel - Top section (extends behind status bar)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: MediaQuery.of(context).size.height * 0.5,
            child: _pageController != null
                ? PageView(
                    controller: _pageController,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    children: [
                      _FindPlayersPreview(),
                      _PlayNowPreview(),
                    ],
                  )
                : SizedBox(),
          ),

          // Dots indicator - right below carousel
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5 + 16,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0, 1].map((i) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == i ? 32 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    gradient: _currentPage == i
                        ? LinearGradient(colors: [
                            FlutterFlowTheme.of(context).primary,
                            FlutterFlowTheme.of(context).warning,
                          ])
                        : null,
                    color: _currentPage == i ? null : Colors.white24,
                  ),
                );
              }).toList(),
            ),
          ),

          // Subtle background pattern on bottom section
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            top: MediaQuery.of(context).size.height * 0.5,
            child: CustomPaint(
              painter: _SubtleBackgroundPainter(),
            ),
          ),

          // Bottom content section
          Positioned(
            left: 0,
            right: 0,
            top: MediaQuery.of(context).size.height * 0.5 + 40,
            bottom: 0,
            child: SafeArea(
              top: false,
              bottom: true,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(24, 4, 24, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Compact FunCircle Logo
                      SvgPicture.asset(
                        'assets/images/yzds4_O.svg',
                        width: 70,
                        height: 70,
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: 8),

                    // Subtitle - stylish with gradient
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: ShaderMask(
                        shaderCallback: (bounds) => LinearGradient(
                          colors: [
                            Colors.white.withValues(alpha: 0.95),
                            Colors.white.withValues(alpha: 0.75),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ).createShader(bounds),
                        child: Text(
                          'Find players, Join games, Book venues',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            letterSpacing: 0.3,
                            height: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                offset: Offset(0, 1),
                                blurRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Auth buttons
                    Column(
                      children: [
                        // Google and Apple in a Row (50% each) for iOS
                        if (Platform.isIOS)
                          Row(
                            children: [
                              // Google Sign In Button (50%)
                              Expanded(
                                child: _buildAuthButton(
                                  context: context,
                                  onTap: () async {
                            // Show loading
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            );

                            print('DEBUG: Starting Google sign in...');

                            // Store the navigator context before it gets unmounted
                            final navigatorContext = Navigator.of(context, rootNavigator: true).context;
                            print('DEBUG: Stored root navigator context');

                            // Sign in with Google
                            final user =
                                await authManager.signInWithGoogle(context);

                            print('DEBUG: Sign in completed. User: ${user?.uid}');

                            // Close loading dialog using root navigator (won't fail if local context unmounted)
                            print('DEBUG: Attempting to close loading dialog...');
                            print('DEBUG: Context mounted? ${context.mounted}');
                            print('DEBUG: Navigator context mounted? ${navigatorContext.mounted}');

                            try {
                              print('DEBUG: Closing dialog with root navigator');
                              Navigator.of(navigatorContext, rootNavigator: true).pop();
                              print('DEBUG: Loading dialog closed successfully');
                            } catch (e) {
                              print('ERROR closing loading dialog: $e');
                            }

                            print('DEBUG: Proceeding with user check...');

                            if (user != null &&
                                user.uid != null &&
                                user.uid!.isNotEmpty) {
                              print('DEBUG: User authenticated successfully: ${user.uid}');

                              // First check if account has been deleted
                              try {
                                print('DEBUG: Querying Supabase for deleted status...');

                                final userProfile = await SupaFlow.client
                                    .from('users')
                                    .select('user_id, deleted_at')
                                    .eq('user_id', user.uid!)
                                    .maybeSingle();

                                print('DEBUG: Query completed. Result: $userProfile');

                                if (userProfile != null && userProfile['deleted_at'] != null) {
                                  print('🚨 ACCOUNT IS DELETED! deleted_at = ${userProfile['deleted_at']}');

                                  // Show dialog FIRST, then sign out when they click OK
                                  print('DEBUG: Showing deleted account dialog...');
                                  print('DEBUG: Local context mounted? ${context.mounted}');
                                  print('DEBUG: Navigator context mounted? ${navigatorContext.mounted}');

                                  if (navigatorContext.mounted) {
                                    print('DEBUG: Using root navigator context to show dialog');

                                    await showDialog(
                                      context: navigatorContext,
                                      barrierDismissible: false,
                                      builder: (dialogContext) {
                                        print('DEBUG: Dialog builder called');
                                        return AlertDialog(
                                          backgroundColor: const Color(0xFF1E1E1E),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          title: Row(
                                            children: [
                                              Icon(Icons.cancel, color: Colors.red, size: 28),
                                              SizedBox(width: 12),
                                              Text(
                                                'Account Deleted',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          content: Text(
                                            'This account has been deleted and cannot be accessed. Please contact support if you believe this is an error.',
                                            style: TextStyle(
                                              color: Colors.white.withValues(alpha: 0.8),
                                              fontSize: 14,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                print('DEBUG: User clicked OK, closing dialog');
                                                Navigator.of(dialogContext).pop();
                                              },
                                              child: Text(
                                                'OK',
                                                style: TextStyle(
                                                  color: Color(0xFF6C63FF), // Hardcoded primary color
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );

                                    print('DEBUG: Dialog closed, now signing out user...');

                                    // NOW sign out after dialog is dismissed
                                    await authManager.signOut();
                                    print('DEBUG: User signed out successfully');
                                  } else {
                                    print('ERROR: Navigator context not mounted, cannot show dialog');
                                    print('ERROR: This should never happen with root navigator');
                                    // Sign out anyway
                                    await authManager.signOut();
                                  }
                                  return;
                                } else {
                                  print('✅ Account is NOT deleted. Proceeding normally.');
                                }
                              } catch (e, stackTrace) {
                                print('❌ ERROR checking deleted status: $e');
                                print('Stack trace: $stackTrace');
                              }

                              // Check if this email is already registered with a different account
                              if (user.email != null && user.email!.isNotEmpty) {
                                try {
                                  final existingUser = await SupaFlow.client
                                      .from('users')
                                      .select('user_id')
                                      .eq('email', user.email!)
                                      .maybeSingle();

                                  if (existingUser != null &&
                                      existingUser['user_id'] != user.uid) {
                                    // Email is already registered with a different account
                                    await authManager.signOut();

                                    if (context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'This email is already registered with a phone number. Please use phone login instead.',
                                          ),
                                          backgroundColor: FlutterFlowTheme.of(context).error,
                                          duration: Duration(seconds: 4),
                                        ),
                                      );
                                    }
                                    return;
                                  }
                                } catch (e) {
                                  print('Error checking email: $e');
                                }
                              }

                              // Get the display name from Firebase (set by Google Sign In)
                              final googleDisplayName = user.displayName;
                              final googleEmail = user.email;

                              print('DEBUG: Google provided name: $googleDisplayName');
                              print('DEBUG: Google provided email: $googleEmail');

                              // Save Google-provided data to Supabase immediately
                              if (googleDisplayName != null && googleDisplayName.isNotEmpty) {
                                try {
                                  // Check if user exists in Supabase
                                  final existingProfile = await SupaFlow.client
                                      .from('users')
                                      .select('user_id, first_name')
                                      .eq('user_id', user.uid!)
                                      .maybeSingle();

                                  if (existingProfile == null) {
                                    // Create new user with Google-provided data
                                    await SupaFlow.client.from('users').insert({
                                      'user_id': user.uid!,
                                      'first_name': googleDisplayName,
                                      'email': googleEmail,
                                      'created': DateTime.now().toIso8601String(),
                                      'isOnline': true,
                                      'lastactive': DateTime.now().toIso8601String(),
                                    });
                                    print('DEBUG: Created new Supabase user with Google name');
                                  } else if (existingProfile['first_name'] == null ||
                                             (existingProfile['first_name'] as String).isEmpty) {
                                    // Update existing user with Google-provided name
                                    await SupaFlow.client
                                        .from('users')
                                        .update({
                                          'first_name': googleDisplayName,
                                          'email': googleEmail,
                                        })
                                        .eq('user_id', user.uid!);
                                    print('DEBUG: Updated Supabase user with Google name');
                                  }
                                } catch (e) {
                                  print('DEBUG: Error saving Google data to Supabase: $e');
                                }
                              }

                              // Check if profile needs completion
                              final service =
                                  ProfileCompletionService(SupaFlow.client);
                              final needsCompletion = await service
                                  .needsProfileCompletion(user.uid!);

                              if (needsCompletion) {
                                // Navigate to profile setup
                                context.goNamed(BasicInfoScreen.routeName);
                              } else {
                                // Navigate to home
                                context.goNamed('HomeNew');
                              }
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.google,
                            color: Colors.white,
                            size: 20,
                          ),
                          text: 'Google',
                          iconBackgroundColor: Color(0xFFDB4437),
                                ),
                              ),
                              SizedBox(width: 10),

                              // Apple Sign In Button (50%)
                              Expanded(
                                child: _buildAuthButton(
                            context: context,
                            onTap: () async {
                              // Show loading
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      FlutterFlowTheme.of(context).primary,
                                    ),
                                  ),
                                ),
                              );

                              print('DEBUG: Starting Apple sign in...');

                              // Store the navigator context before it gets unmounted
                              final navigatorContext = Navigator.of(context, rootNavigator: true).context;
                              print('DEBUG: Stored root navigator context');

                              try {
                                // Sign in with Apple
                                final user = await authManager.signInWithApple(context);

                                print('DEBUG: Sign in completed. User: ${user?.uid}');

                                // Close loading dialog using root navigator
                                print('DEBUG: Attempting to close loading dialog...');
                                if (navigatorContext.mounted) {
                                  Navigator.of(navigatorContext, rootNavigator: true).pop();
                                  print('DEBUG: Loading dialog closed');
                                }

                                // Check for profile completion
                                if (user != null && user.uid != null && user.uid!.isNotEmpty) {
                                  print('DEBUG: User authenticated successfully: ${user.uid}');

                                  // First check if account has been deleted (same as Google)
                                  try {
                                    print('DEBUG: Querying Supabase for deleted status...');

                                    final userProfile = await SupaFlow.client
                                        .from('users')
                                        .select('user_id, deleted_at')
                                        .eq('user_id', user.uid!)
                                        .maybeSingle();

                                    print('DEBUG: Query completed. Result: $userProfile');

                                    if (userProfile != null && userProfile['deleted_at'] != null) {
                                      print('🚨 ACCOUNT IS DELETED! deleted_at = ${userProfile['deleted_at']}');

                                      // Show dialog FIRST, then sign out when they click OK
                                      if (navigatorContext.mounted) {
                                        await showDialog(
                                          context: navigatorContext,
                                          barrierDismissible: false,
                                          builder: (dialogContext) {
                                            return AlertDialog(
                                              backgroundColor: const Color(0xFF1E1E1E),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              title: Row(
                                                children: [
                                                  Icon(Icons.cancel, color: Colors.red, size: 28),
                                                  SizedBox(width: 12),
                                                  Text(
                                                    'Account Deleted',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              content: Text(
                                                'This account has been deleted and cannot be accessed. Please contact support if you believe this is an error.',
                                                style: TextStyle(
                                                  color: Colors.white.withValues(alpha: 0.8),
                                                  fontSize: 14,
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.of(dialogContext).pop();
                                                  },
                                                  child: Text(
                                                    'OK',
                                                    style: TextStyle(
                                                      color: Color(0xFF6C63FF),
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );

                                        // NOW sign out after dialog is dismissed
                                        await authManager.signOut();
                                        print('DEBUG: User signed out successfully');
                                      }
                                      return;
                                    } else {
                                      print('✅ Account is NOT deleted. Proceeding normally.');
                                    }
                                  } catch (e, stackTrace) {
                                    print('❌ ERROR checking deleted status: $e');
                                    print('Stack trace: $stackTrace');
                                  }

                                  // Check if this email is already registered with a different account (same as Google)
                                  if (user.email != null && user.email!.isNotEmpty) {
                                    try {
                                      final existingUser = await SupaFlow.client
                                          .from('users')
                                          .select('user_id')
                                          .eq('email', user.email!)
                                          .maybeSingle();

                                      if (existingUser != null &&
                                          existingUser['user_id'] != user.uid) {
                                        // Email is already registered with a different account
                                        await authManager.signOut();

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'This email is already registered with a phone number. Please use phone login instead.',
                                              ),
                                              backgroundColor: FlutterFlowTheme.of(context).error,
                                              duration: Duration(seconds: 4),
                                            ),
                                          );
                                        }
                                        return;
                                      }
                                    } catch (e) {
                                      print('Error checking email: $e');
                                    }
                                  }

                                  print('DEBUG: User authenticated, checking profile completion...');

                                  // Get the display name from Firebase (set by Apple Sign In)
                                  final appleDisplayName = user.displayName;
                                  final appleEmail = user.email;

                                  print('DEBUG: Apple provided name: $appleDisplayName');
                                  print('DEBUG: Apple provided email: $appleEmail');

                                  // Save Apple-provided data to Supabase immediately
                                  if (appleDisplayName != null && appleDisplayName.isNotEmpty) {
                                    try {
                                      // Check if user exists in Supabase
                                      final existingProfile = await SupaFlow.client
                                          .from('users')
                                          .select('user_id, first_name')
                                          .eq('user_id', user.uid!)
                                          .maybeSingle();

                                      if (existingProfile == null) {
                                        // Create new user with Apple-provided data
                                        await SupaFlow.client.from('users').insert({
                                          'user_id': user.uid!,
                                          'first_name': appleDisplayName,
                                          'email': appleEmail,
                                          'created': DateTime.now().toIso8601String(),
                                          'isOnline': true,
                                          'lastactive': DateTime.now().toIso8601String(),
                                        });
                                        print('DEBUG: Created new Supabase user with Apple name');
                                      } else if (existingProfile['first_name'] == null ||
                                                 (existingProfile['first_name'] as String).isEmpty) {
                                        // Update existing user with Apple-provided name
                                        await SupaFlow.client
                                            .from('users')
                                            .update({
                                              'first_name': appleDisplayName,
                                              'email': appleEmail,
                                            })
                                            .eq('user_id', user.uid!);
                                        print('DEBUG: Updated Supabase user with Apple name');
                                      }
                                    } catch (e) {
                                      print('DEBUG: Error saving Apple data to Supabase: $e');
                                    }
                                  }

                                  final service = ProfileCompletionService(SupaFlow.client);
                                  final needsCompletion = await service.needsProfileCompletion(user.uid!);

                                  print('DEBUG: Profile needs completion: $needsCompletion');

                                  if (needsCompletion) {
                                    print('DEBUG: Navigating to BasicInfoScreen');
                                    context.goNamed(BasicInfoScreen.routeName);
                                  } else {
                                    print('DEBUG: Navigating to HomeNew');
                                    context.goNamed('HomeNew');
                                  }
                                }
                              } catch (e, stackTrace) {
                                print('DEBUG: Error during Apple sign in: $e');
                                print('STACK: $stackTrace');

                                // Close loading dialog
                                if (navigatorContext.mounted) {
                                  try {
                                    Navigator.of(navigatorContext, rootNavigator: true).pop();
                                  } catch (popError) {
                                    print('ERROR: Could not pop loading dialog: $popError');
                                  }
                                }

                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Sign in with Apple failed. Please try again or use another method.'),
                                      backgroundColor: FlutterFlowTheme.of(context).error,
                                      duration: Duration(seconds: 4),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: FaIcon(
                              FontAwesomeIcons.apple,
                              color: Colors.white,
                              size: 20,
                            ),
                            text: 'Apple',
                            iconBackgroundColor: Colors.black,
                                ),
                              ),
                            ],
                          ), // Close Row
                        SizedBox(height: 10),

                        // Phone Sign In Button (Full Width)
                        _buildAuthButton(
                          context: context,
                          onTap: () {
                            context.pushNamed(PhoneAuthScreen.routeName);
                          },
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 20,
                          ),
                          text: 'Continue with Phone',
                          iconBackgroundColor: Color(0xFF6C63FF),
                        ),
                      ],
                    ),
                    SizedBox(height: 24),

                    // Terms text
                    Text(
                      'By continuing, you agree to our Terms & Privacy Policy',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 10,
                      ),
                    ),
                    SizedBox(height: 8),
                  ],
                ),
              ), // Close Padding
            ), // Close SingleChildScrollView
          ), // Close SafeArea
        ), // Close Positioned
      ],
      ),
    );
  }

  Widget _buildAuthButton({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget icon,
    required String text,
    required Color iconBackgroundColor,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.06),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.2,
            ),
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(30),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon container
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(child: icon),
                    ),
                    SizedBox(width: 12),
                    // Text - wrapped in Flexible to prevent overflow
                    Flexible(
                      child: Text(
                        text,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.3,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
    );
  }
}

// Find Players Map Preview
class _FindPlayersPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFFF5F1E8), // Match map background
      child: Stack(
        children: [
          // Map background
          CustomPaint(
            painter: _MapPainter(),
            size: Size.infinite,
          ),

          // Title at top - below notification bar
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.85),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Color(0xFF6C63FF).withValues(alpha: 0.3),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, color: Color(0xFF6C63FF), size: 26),
                  SizedBox(width: 10),
                  Text(
                    'Find Players Nearby',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Player pins - scattered across the map with Indian names (avoiding title area)
          _buildPlayerPin(context, 0.15, 0.45, 'Rahul', Colors.blue),
          _buildPlayerPin(context, 0.7, 0.6, 'Priya', Colors.pink),
          _buildPlayerPin(context, 0.4, 0.85, 'Arjun', Colors.green),

          // Court pins - scattered across the map with venue labels (avoiding title area)
          _buildVenuePin(context, 0.25, 0.55, 'Badminton Court', '1.7 km'),
          _buildVenuePin(context, 0.75, 0.35, 'Pickleball Court', '2.5 km'),
          _buildVenuePin(context, 0.50, 0.75, 'Box Cricket Venue', '0.9 km'),
        ],
      ),
    );
  }

  Widget _buildPlayerPin(BuildContext context, double leftFactor,
      double topFactor, String name, Color color) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width * leftFactor - 30, // Center the pin
      top: screenSize.height *
          0.5 *
          topFactor, // Use half screen height for carousel
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(Icons.person, color: Colors.white, size: 34),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3), width: 1),
            ),
            child: Text(
              name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVenuePin(BuildContext context, double leftFactor,
      double topFactor, String venueName, String distance) {
    final screenSize = MediaQuery.of(context).size;
    return Positioned(
      left: screenSize.width * leftFactor - 27.5, // Center the pin
      top: screenSize.height *
          0.5 *
          topFactor, // Use half screen height for carousel
      child: Column(
        children: [
          Container(
            width: 55,
            height: 55,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFFF6B35),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFFFF6B35).withValues(alpha: 0.6),
                  blurRadius: 15,
                  spreadRadius: 3,
                ),
              ],
            ),
            child: Icon(Icons.sports_tennis, color: Colors.white, size: 30),
          ),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3), width: 1),
            ),
            child: Column(
              children: [
                Text(
                  venueName,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  distance,
                  style: TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 10,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// PlayNow Game Requests Preview
class _PlayNowPreview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Color(0xFF1F1F1F),
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 16,
        24,
        24,
      ),
      child: Column(
        children: [
          // Title
          Row(
            children: [
              Icon(Icons.sports_tennis,
                  color: FlutterFlowTheme.of(context).primary, size: 28),
              SizedBox(width: 10),
              Text(
                'Organized Games',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          SizedBox(height: 20),

          // Game cards
          Expanded(
            child: ListView(
              children: [
                _buildGameCard(
                  context,
                  'Badminton Doubles',
                  'Today 6:00 PM',
                  'Gurgaon Badminton Club',
                  '2/4 Players',
                  Color(0xFF6C63FF),
                ),
                SizedBox(height: 12),
                _buildGameCard(
                  context,
                  'Mixed Doubles',
                  'Tomorrow 7:30 PM',
                  'Flow Sector 48',
                  '3/4 Players',
                  Color(0xFFFF6B35),
                ),
                SizedBox(height: 12),
                _buildGameCard(
                  context,
                  'Singles Match',
                  'Sat 5:00 PM',
                  'Padel First, Gurgaon',
                  '1/2 Players',
                  Color(0xFF9B51E0),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(BuildContext context, String title, String time,
      String venue, String players, Color accentColor) {
    return Container(
      padding: EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: accentColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: accentColor,
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  players,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: accentColor,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.access_time, color: Colors.white60, size: 14),
              SizedBox(width: 4),
              Text(
                time,
                style: TextStyle(fontSize: 12, color: Colors.white70),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.white60, size: 14),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  venue,
                  style: TextStyle(fontSize: 12, color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Map painter for Find Players - Gurgaon style
class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Map background - light beige like Google Maps
    final bgPaint = Paint()..color = Color(0xFFF5F1E8);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    // Draw city blocks (buildings) - varied sizes
    final blockPaint = Paint()..color = Color(0xFFE8E4DB);

    // Residential/commercial blocks
    final blocks = [
      Rect.fromLTWH(size.width * 0.05, size.height * 0.05, size.width * 0.25,
          size.height * 0.15),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.05, size.width * 0.28,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.68, size.height * 0.08, size.width * 0.27,
          size.height * 0.14),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.28, size.width * 0.22,
          size.height * 0.16),
      Rect.fromLTWH(size.width * 0.32, size.height * 0.30, size.width * 0.32,
          size.height * 0.12),
      Rect.fromLTWH(size.width * 0.68, size.height * 0.27, size.width * 0.27,
          size.height * 0.18),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.52, size.width * 0.18,
          size.height * 0.14),
      Rect.fromLTWH(size.width * 0.28, size.height * 0.50, size.width * 0.28,
          size.height * 0.20),
      Rect.fromLTWH(size.width * 0.60, size.height * 0.52, size.width * 0.35,
          size.height * 0.16),
      Rect.fromLTWH(size.width * 0.05, size.height * 0.73, size.width * 0.25,
          size.height * 0.22),
      Rect.fromLTWH(size.width * 0.35, size.height * 0.76, size.width * 0.30,
          size.height * 0.19),
      Rect.fromLTWH(size.width * 0.70, size.height * 0.74, size.width * 0.25,
          size.height * 0.21),
    ];

    for (var block in blocks) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(block, Radius.circular(3)),
        blockPaint,
      );
    }

    // Draw major roads - Golf Course Road style (wider)
    final majorRoadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..color = Color(0xFFFFFFFF);

    // Main horizontal road (like Golf Course Road)
    canvas.drawLine(Offset(0, size.height * 0.25),
        Offset(size.width, size.height * 0.25), majorRoadPaint);

    // Main vertical road (like Sohna Road)
    canvas.drawLine(Offset(size.width * 0.65, 0),
        Offset(size.width * 0.65, size.height), majorRoadPaint);

    // Secondary roads
    final roadPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..color = Color(0xFFFEFEFE);

    // Horizontal secondary roads
    canvas.drawLine(Offset(0, size.height * 0.48),
        Offset(size.width, size.height * 0.48), roadPaint);
    canvas.drawLine(Offset(0, size.height * 0.70),
        Offset(size.width, size.height * 0.70), roadPaint);

    // Vertical secondary roads
    canvas.drawLine(Offset(size.width * 0.30, 0),
        Offset(size.width * 0.30, size.height), roadPaint);

    // Road borders (darker edges)
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8
      ..color = Color(0xFFD4D0C8);

    // Borders for major horizontal road
    canvas.drawLine(Offset(0, size.height * 0.25 - 6),
        Offset(size.width, size.height * 0.25 - 6), borderPaint);
    canvas.drawLine(Offset(0, size.height * 0.25 + 6),
        Offset(size.width, size.height * 0.25 + 6), borderPaint);

    // Borders for major vertical road
    canvas.drawLine(Offset(size.width * 0.65 - 6, 0),
        Offset(size.width * 0.65 - 6, size.height), borderPaint);
    canvas.drawLine(Offset(size.width * 0.65 + 6, 0),
        Offset(size.width * 0.65 + 6, size.height), borderPaint);

    // Yellow center line for major road
    final centerLinePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..color = Color(0xFFFDB913);

    _drawDashedLine(canvas, Offset(0, size.height * 0.25),
        Offset(size.width, size.height * 0.25), centerLinePaint);
    _drawDashedLine(canvas, Offset(size.width * 0.65, 0),
        Offset(size.width * 0.65, size.height), centerLinePaint);

    // Green spaces (parks) - like Leisure Valley Park
    final parkPaint = Paint()..color = Color(0xFFB8E6B8);

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width * 0.08, size.height * 0.53, size.width * 0.15,
            size.height * 0.12),
        Radius.circular(6),
      ),
      parkPaint,
    );

    // Trees in park
    final treePaint = Paint()..color = Color(0xFF7AC77A);
    for (int i = 0; i < 4; i++) {
      canvas.drawCircle(
        Offset(size.width * (0.10 + i * 0.03), size.height * 0.59),
        3,
        treePaint,
      );
    }
  }

  void _drawDashedLine(Canvas canvas, Offset start, Offset end, Paint paint) {
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    double distance = (end - start).distance;
    double dashCount = distance / (dashWidth + dashSpace);

    for (int i = 0; i < dashCount; i++) {
      double startX = start.dx +
          (end.dx - start.dx) * (i * (dashWidth + dashSpace)) / distance;
      double startY = start.dy +
          (end.dy - start.dy) * (i * (dashWidth + dashSpace)) / distance;
      double endX = start.dx +
          (end.dx - start.dx) *
              (i * (dashWidth + dashSpace) + dashWidth) /
              distance;
      double endY = start.dy +
          (end.dy - start.dy) *
              (i * (dashWidth + dashSpace) + dashWidth) /
              distance;

      canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    }
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) => false;
}

// Subtle background pattern
class _SubtleBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Very subtle diagonal grid
    final gridPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.3
      ..color = Colors.white.withValues(alpha: 0.02);

    for (int i = -10; i < 20; i++) {
      final startX = i * size.width * 0.15;
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + size.height * 1.2, size.height),
        gridPaint,
      );
    }

    // Very subtle dots
    final dotPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.white.withValues(alpha: 0.02);

    for (int i = 0; i < 15; i++) {
      for (int j = 0; j < 30; j++) {
        if ((i + j) % 4 == 0) {
          canvas.drawCircle(
            Offset(i * size.width * 0.08, j * size.height * 0.05),
            1,
            dotPaint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(_SubtleBackgroundPainter oldDelegate) => false;
}
