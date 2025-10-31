import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'profile_menu_model.dart';
export 'profile_menu_model.dart';

class ProfileMenuWidget extends StatefulWidget {
  const ProfileMenuWidget({super.key});

  static String routeName = 'ProfileMenuScreen';
  static String routePath = '/profileMenu';

  @override
  State<ProfileMenuWidget> createState() => _ProfileMenuWidgetState();
}

class _ProfileMenuWidgetState extends State<ProfileMenuWidget> {
  late ProfileMenuModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProfileMenuModel());
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPatternPainter(),
              ),
            ),
            // Content
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with user info (extends behind status bar)
                  _buildUserHeader(),

                  // Menu Grid with safe area
                  SafeArea(
                    top: false,
                    child: Column(
                      children: [
                        const SizedBox(height: 24),
                        _buildMenuGrid(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFFFF6B35),
            Color(0xFFF7931E),
          ],
          stops: const [0.0, 1.0],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _PatternPainter(),
            ),
          ),
          // Semi-transparent overlay to reduce orange intensity
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.1),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.15),
                  ],
                  stops: const [0.0, 0.5, 1.0],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Content
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 24,
              right: 24,
              bottom: 24,
            ),
            child: Column(
              children: [
                // Close button
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Menu',
                      style: FlutterFlowTheme.of(context).headlineMedium.override(
                            fontFamily: 'Outfit',
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white, size: 28),
                      onPressed: () {
                        context.safePop();
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                // User profile card
                _buildProfileCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return FutureBuilder(
      future: SupaFlow.client
          .from('users')
          .select('first_name, images, location, age')
          .eq('user_id', currentUserUid)
          .single()
          .timeout(const Duration(seconds: 5)),
      builder: (context, snapshot) {
        // Show loading only briefly
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 220,
            child: Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            ),
          );
        }

        // If error or no data, show basic card
        if (snapshot.hasError || !snapshot.hasData) {
          print('Error loading profile card: ${snapshot.error}');
          return _buildBasicProfileCard();
        }

        final userData = snapshot.data as Map<String, dynamic>;
        final name = userData['first_name'] as String? ?? 'User';
        final images = (userData['images'] as List?)?.cast<String>() ?? [];
        final profileImage = images.isNotEmpty ? images.first : null;

        // Optional fields - try to get them if they exist
        final location = userData['location'] as String?;
        final age = userData['age'] as String?;

        return InkWell(
          onTap: () {
            context.pushNamed('MyProfileScreen');
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 20,
                  color: Color(0x30000000),
                  offset: Offset(0, 6),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  // Base gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFFFF6B35),
                          Color(0xFFF7931E),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                  ),
                  // Pattern overlay
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _CardPatternPainter(),
                    ),
                  ),
                  // Subtle dark overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.08),
                            Colors.transparent,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                // Profile picture
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: 3,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 10,
                        color: Color(0x33000000),
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 32,
                    backgroundImage: profileImage != null
                        ? CachedNetworkImageProvider(profileImage)
                        : null,
                    backgroundColor: Colors.white,
                    child: profileImage == null
                        ? Icon(
                            Icons.person,
                            size: 35,
                            color: FlutterFlowTheme.of(context).primary,
                          )
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                // Name and info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        name,
                        style: FlutterFlowTheme.of(context).headlineSmall.override(
                              fontFamily: 'Outfit',
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      // Age and Location in a compact row
                      Row(
                        children: [
                          if (age != null && age.isNotEmpty) ...[
                            Icon(
                              Icons.cake_outlined,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$age yrs',
                              style: FlutterFlowTheme.of(context).bodySmall.override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white.withValues(alpha: 0.85),
                                    fontSize: 13,
                                  ),
                            ),
                          ],
                          if (age != null && age.isNotEmpty && location != null && location.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 3,
                              height: 3,
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          if (location != null && location.isNotEmpty) ...[
                            Icon(
                              Icons.location_on,
                              size: 14,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                location,
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white.withValues(alpha: 0.85),
                                      fontSize: 13,
                                    ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 10),
                      // View profile button
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_forward_rounded,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'View Profile',
                            style: FlutterFlowTheme.of(context).bodySmall.override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.white.withValues(alpha: 0.9),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ],
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
      },
    );
  }

  // Fallback basic profile card if query fails
  Widget _buildBasicProfileCard() {
    return InkWell(
      onTap: () {
        context.pushNamed('MyProfileScreen');
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              blurRadius: 20,
              color: Color(0x30000000),
              offset: Offset(0, 6),
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Base gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFF7931E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Pattern overlay
              Positioned.fill(
                child: CustomPaint(
                  painter: _CardPatternPainter(),
                ),
              ),
              // Subtle dark overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.black.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    // Profile picture placeholder
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 3,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 10,
                            color: Color(0x33000000),
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.person,
                        size: 35,
                        color: FlutterFlowTheme.of(context).primary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Name and button
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'My Profile',
                            style: FlutterFlowTheme.of(context).headlineSmall.override(
                                  fontFamily: 'Outfit',
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(
                                Icons.arrow_forward_rounded,
                                size: 14,
                                color: Colors.white.withValues(alpha: 0.9),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'View Profile',
                                style: FlutterFlowTheme.of(context).bodySmall.override(
                                      fontFamily: 'Readex Pro',
                                      color: Colors.white.withValues(alpha: 0.9),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                        ],
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

  Widget _buildMenuGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 20,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFFF6B35),
                        Color(0xFFF7931E),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Quick Access',
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Grid of menu items
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 1.3,
            children: [
              _buildMenuItem(
                'My Bookings',
                Icons.book_online_rounded,
                const Color(0xFF4CAF50),
                () => context.pushNamed('MyBookingsScreen'),
              ),
              _buildMenuItem(
                'Game Requests',
                Icons.sports_handball_rounded,
                const Color(0xFF2196F3),
                () => context.pushNamed('GameRequestsScreen'),
              ),
              _buildMenuItem(
                'Play Friends',
                Icons.people_rounded,
                const Color(0xFF9C27B0),
                () => context.pushNamed('PlayFriendsScreen'),
              ),
              _buildMenuItem(
                'Settings',
                Icons.settings_rounded,
                const Color(0xFF607D8B),
                () => context.pushNamed('SettingsScreen'),
              ),
              _buildMenuItem(
                'More Options',
                Icons.apps_rounded,
                const Color(0xFFFF9800),
                () => context.pushNamed('MoreOptionsScreen'),
              ),
              _buildMenuItem(
                'Help & Support',
                Icons.help_outline_rounded,
                const Color(0xFFE91E63),
                () => context.pushNamed('ContactSupportScreen'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: color.withValues(alpha: 0.1),
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black.withValues(alpha: 0.05),
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    color.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  center: Alignment.topLeft,
                  radius: 1.5,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          color.withValues(alpha: 0.2),
                          color.withValues(alpha: 0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: color.withValues(alpha: 0.3),
                        width: 1,
                      ),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: color.withValues(alpha: 0.15),
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.2,
                        color: Colors.white,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for decorative pattern
class _PatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw circles pattern
    for (double i = -size.width; i < size.width * 2; i += 100) {
      for (double j = -size.height; j < size.height * 2; j += 100) {
        canvas.drawCircle(Offset(i, j), 40, paint);
      }
    }

    // Draw diagonal lines
    final linePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    for (double i = -size.height; i < size.width + size.height; i += 60) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height),
        linePaint,
      );
    }

    // Draw dots pattern
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 30) {
      for (double j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i, j), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Custom painter for card pattern
class _CardPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Subtle circles
    final circlePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.04)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    for (double i = -size.width / 2; i < size.width * 1.5; i += 60) {
      for (double j = -size.height / 2; j < size.height * 1.5; j += 60) {
        canvas.drawCircle(Offset(i, j), 25, circlePaint);
      }
    }

    // Dots pattern
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 20) {
      for (double j = 0; j < size.height; j += 20) {
        canvas.drawCircle(Offset(i, j), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Background pattern painter for dark mode
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

    // Add subtle orange gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange.withValues(alpha: 0.03),
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
