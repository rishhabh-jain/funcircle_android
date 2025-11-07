import 'package:flutter/material.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/services/profile_completion_service.dart';
import '/auth_screens/phone_auth_screen.dart';
import '/profile_setup/basic_info_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AuthMethodScreen extends StatelessWidget {
  const AuthMethodScreen({super.key});

  static String routeName = 'AuthMethod';
  static String routePath = '/authMethod';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            Positioned(
              bottom: 100,
              left: -150,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      FlutterFlowTheme.of(context).primary.withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // Main content
            Column(
              children: [
                // Back button
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      onPressed: () => context.safePop(),
                      icon: Icon(
                        Icons.arrow_back,
                        color: FlutterFlowTheme.of(context).tertiary,
                        size: 24,
                      ),
                    ),
                  ),
                ),

                // Title section
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Welcome text
                        Text(
                          'Welcome to',
                          style: FlutterFlowTheme.of(context).headlineMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).headlineMediumFamily,
                                color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.7),
                                fontSize: 24,
                                fontWeight: FontWeight.w400,
                                letterSpacing: 0.5,
                                useGoogleFonts: !FlutterFlowTheme.of(context).headlineMediumIsCustom,
                              ),
                        ),
                        SizedBox(height: 8),

                        ShaderMask(
                          shaderCallback: (bounds) => LinearGradient(
                            colors: [
                              Colors.white,
                              Color(0xFF6C63FF),
                            ],
                          ).createShader(bounds),
                          child: Text(
                            'Fun Circle',
                            style: TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ),
                        SizedBox(height: 12),

                        Text(
                          'Choose your login method',
                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                fontFamily: FlutterFlowTheme.of(context).bodyMediumFamily,
                                color: FlutterFlowTheme.of(context).tertiary.withOpacity(0.6),
                                fontSize: 15,
                                letterSpacing: 0.3,
                                useGoogleFonts: !FlutterFlowTheme.of(context).bodyMediumIsCustom,
                              ),
                        ),
                        SizedBox(height: 60),

                        // Google Sign In button
                        _buildGlassButton(
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

                            // Sign in with Google
                            final user = await authManager.signInWithGoogle(context);

                            Navigator.pop(context); // Close loading dialog

                            if (user != null && user.uid != null && user.uid!.isNotEmpty) {
                              // Check if profile needs completion
                              final service = ProfileCompletionService(SupaFlow.client);
                              final needsCompletion =
                                  await service.needsProfileCompletion(user.uid!);

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
                            size: 22,
                          ),
                          text: 'Continue with Google',
                          iconBackgroundColor: Color(0xFFDB4437),
                        ),
                        SizedBox(height: 16),

                        // Apple Sign In button
                        _buildGlassButton(
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

                            try {
                              // Sign in with Apple
                              final user = await authManager.signInWithApple(context);

                              Navigator.pop(context); // Close loading dialog

                              if (user != null && user.uid != null && user.uid!.isNotEmpty) {
                                // Check if profile needs completion
                                final service = ProfileCompletionService(SupaFlow.client);
                                final needsCompletion =
                                    await service.needsProfileCompletion(user.uid!);

                                if (needsCompletion) {
                                  // Navigate to profile setup
                                  context.goNamed(BasicInfoScreen.routeName);
                                } else {
                                  // Navigate to home
                                  context.goNamed('HomeNew');
                                }
                              }
                            } catch (e) {
                              Navigator.pop(context); // Close loading dialog
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Sign in with Apple failed. Please try again.')),
                              );
                            }
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.apple,
                            color: Colors.white,
                            size: 22,
                          ),
                          text: 'Continue with Apple',
                          iconBackgroundColor: Colors.black,
                        ),
                        SizedBox(height: 16),

                        // Phone Sign In button
                        _buildGlassButton(
                          context: context,
                          onTap: () {
                            context.pushNamed(PhoneAuthScreen.routeName);
                          },
                          icon: Icon(
                            Icons.phone_android,
                            color: Colors.white,
                            size: 22,
                          ),
                          text: 'Continue with Phone',
                          iconBackgroundColor: Color(0xFF6C63FF),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlassButton({
    required BuildContext context,
    required VoidCallback onTap,
    required Widget icon,
    required String text,
    required Color iconBackgroundColor,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
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
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Row(
                  children: [
                    // Icon container
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: iconBackgroundColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(child: icon),
                    ),
                    SizedBox(width: 16),
                    // Text
                    Expanded(
                      child: Text(
                        text,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                    // Arrow
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white.withOpacity(0.6),
                      size: 16,
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
}
