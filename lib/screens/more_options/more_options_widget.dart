import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/more_options_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'more_options_model.dart';
export 'more_options_model.dart';

class MoreOptionsWidget extends StatefulWidget {
  const MoreOptionsWidget({super.key});

  static String routeName = 'MoreOptionsScreen';
  static String routePath = '/moreOptions';

  @override
  State<MoreOptionsWidget> createState() => _MoreOptionsWidgetState();
}

class _MoreOptionsWidgetState extends State<MoreOptionsWidget> with TickerProviderStateMixin {
  late MoreOptionsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late MoreOptionsService _service;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MoreOptionsModel());
    _service = MoreOptionsService(SupaFlow.client);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _loadData();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    if (currentUserUid.isEmpty) return;

    setState(() {
      _model.isLoadingStats = true;
    });

    try {
      final stats = await _service.getUserQuickStats(currentUserUid);
      final count = await _service.getPendingGameRequestsCount(currentUserUid);

      setState(() {
        _model.userStats = stats;
        _model.pendingRequestsCount = count;
        _model.isLoadingStats = false;
      });
    } catch (e) {
      setState(() {
        _model.isLoadingStats = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFF121212),
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _MoreOptionsBackgroundPainter(),
              ),
            ),

            // Main content
            SafeArea(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    // Header
                    _buildHeader(),

                    // Content
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Column(
                          children: [
                            const SizedBox(height: 8),

                            // User Profile Header
                            _buildUserProfileSection(),

                            const SizedBox(height: 16),

                            // Quick Stats
                            if (_model.isLoadingStats)
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(24),
                                  child: CircularProgressIndicator(
                                    color: Colors.orange,
                                  ),
                                ),
                              )
                            else if (_model.userStats != null)
                              _buildQuickStatsSection(),

                            const SizedBox(height: 24),

                            // Legal & About Section
                            _buildSectionHeader('Legal & About', Icons.article_outlined),
                            _buildLegalSection(),

                            const SizedBox(height: 24),

                            // Social Section
                            _buildSectionHeader('Follow Us', Icons.share_outlined),
                            _buildSocialSection(),

                            const SizedBox(height: 24),

                            // App Version
                            _buildAppVersion(),
                          ],
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
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, left: 8, right: 20, bottom: 16),
      child: Row(
        children: [
          // Back button
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          const SizedBox(width: 8),
          // Title
          const Expanded(
            child: Text(
              'More Options',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(icon, size: 18, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: FutureBuilder(
              future: SupaFlow.client
                  .from('users')
                  .select('first_name, images')
                  .eq('user_id', currentUserUid)
                  .single(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Row(
                    children: [
                      CircleAvatar(
                        radius: 30,
                        child: Icon(Icons.person),
                      ),
                      SizedBox(width: 16),
                      Text('Loading...', style: TextStyle(color: Colors.white)),
                    ],
                  );
                }

                final userData = snapshot.data as Map<String, dynamic>;
                final name = userData['first_name'] as String? ?? 'User';
                final images = (userData['images'] as List?)?.cast<String>() ?? [];
                final profileImage = images.isNotEmpty ? images.first : null;

                return InkWell(
                  onTap: () => context.pushNamed('MyProfileScreen'),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.grey[800],
                          backgroundImage: profileImage != null
                              ? CachedNetworkImageProvider(profileImage)
                              : null,
                          child: profileImage == null
                              ? const Icon(Icons.person, size: 30, color: Colors.white70)
                              : null,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'View Profile',
                              style: TextStyle(
                                color: Colors.orange.withValues(alpha: 0.9),
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white.withValues(alpha: 0.4),
                        size: 20,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildQuickStatsSection() {
    final stats = _model.userStats!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick Stats',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Bookings',
                        stats.totalBookings.toString(),
                        Icons.book_online,
                        const LinearGradient(colors: [Color(0xFF2196F3), Color(0xFF64B5F6)]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Friends',
                        stats.totalFriends.toString(),
                        Icons.people,
                        const LinearGradient(colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)]),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildStatCard(
                        'Upcoming',
                        stats.upcomingBookings.toString(),
                        Icons.event,
                        const LinearGradient(colors: [Color(0xFFFF6B35), Color(0xFFF7931E)]),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildStatCard(
                        'Games',
                        stats.totalGamesPlayed.toString(),
                        Icons.sports_tennis,
                        const LinearGradient(colors: [Color(0xFF9C27B0), Color(0xFFBA68C8)]),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Gradient gradient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              gradient: gradient,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAccessSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                _buildNavigationTile(
                  icon: Icons.book_online_outlined,
                  title: 'My Bookings',
                  subtitle: 'View your bookings',
                  onTap: () => context.pushNamed('MyBookingsScreen'),
                  accentColor: Colors.blue,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.sports_handball_outlined,
                  title: 'Game Requests',
                  subtitle: 'Manage game requests',
                  onTap: () => context.pushNamed('GameRequestsScreen'),
                  accentColor: Colors.green,
                  badge: _model.pendingRequestsCount > 0 ? _model.pendingRequestsCount : null,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.people_outline,
                  title: 'My Play Friends',
                  subtitle: 'View your play friends',
                  onTap: () => context.pushNamed('PlayFriendsScreen'),
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  subtitle: 'View and edit profile',
                  onTap: () => context.pushNamed('MyProfileScreen'),
                  accentColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                _buildNavigationTile(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  subtitle: 'How we protect your data',
                  onTap: () => launchURL('https://www.funcircleapp.com/privacyPolicy'),
                  accentColor: Colors.teal,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms',
                  onTap: () => launchURL('https://www.funcircleapp.com/termsandservice'),
                  accentColor: Colors.green,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.groups_outlined,
                  title: 'Community Guidelines',
                  subtitle: 'Community rules',
                  onTap: () => context.pushNamed('PolicyScreen', queryParameters: {'policyType': 'community'}),
                  accentColor: Colors.indigo,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.info_outline,
                  title: 'About Us',
                  subtitle: 'Learn more about Fun Circle',
                  onTap: () => launchURL('https://www.funcircleapp.com/about'),
                  accentColor: Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withValues(alpha: 0.12),
                  Colors.white.withValues(alpha: 0.04),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Connect with us on social media',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildSocialButton(
                      icon: FontAwesomeIcons.instagram,
                      color: const Color(0xFFE4405F),
                      onTap: () => launchURL('https://instagram.com/funcircleapp'),
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.facebookF,
                      color: const Color(0xFF1877F2),
                      onTap: () {},
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.youtube,
                      color: const Color(0xFFFF0000),
                      onTap: () {},
                    ),
                    _buildSocialButton(
                      icon: FontAwesomeIcons.linkedinIn,
                      color: const Color(0xFF0A66C2),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color,
              color.withValues(alpha: 0.7),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildAppVersion() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
              ),
            ),
            child: Column(
              children: [
                Text(
                  'Fun Circle',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Version 4.0.x',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accentColor,
    int? badge,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 20, color: accentColor),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (badge != null)
              Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.4),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Text(
                  badge.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withValues(alpha: 0.4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Divider(
        height: 1,
        thickness: 1,
        color: Colors.white.withValues(alpha: 0.08),
      ),
    );
  }
}

class _MoreOptionsBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white.withValues(alpha: 0.03);

    // Draw grid pattern
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i * 0.1)),
        Offset(size.width, size.height * (i * 0.1)),
        paint,
      );
    }

    // Draw decorative circles
    final circlePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.orange.withValues(alpha: 0.04);

    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.15),
      40,
      circlePaint,
    );

    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.7),
      30,
      circlePaint,
    );

    // Gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.orange.withValues(alpha: 0.02),
          Colors.transparent,
          Colors.blue.withValues(alpha: 0.01),
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
