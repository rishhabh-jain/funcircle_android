import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/index.dart';
import '../../services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'settings_model.dart';
export 'settings_model.dart';

class SettingsScreenWidget extends StatefulWidget {
  const SettingsScreenWidget({super.key});

  static String routeName = 'SettingsScreen';
  static String routePath = '/settingsScreen';

  @override
  State<SettingsScreenWidget> createState() => _SettingsScreenWidgetState();
}

class _SettingsScreenWidgetState extends State<SettingsScreenWidget> with TickerProviderStateMixin {
  late SettingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingsService _service;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SettingsModel());
    _service = SettingsService(SupaFlow.client);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _loadSettings();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    if (currentUserUid.isEmpty) return;

    setState(() {
      _model.isLoading = true;
    });

    try {
      final settings = await _service.getUserSettings(currentUserUid);
      setState(() {
        _model.userSettings = settings;
        _model.isLoading = false;
      });
    } catch (e) {
      print('Error loading settings: $e');
      setState(() {
        _model.isLoading = false;
      });
    }
  }

  Future<void> _updateSetting(String field, dynamic value) async {
    try {
      await _service.updateSetting(currentUserUid, field, value);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update setting: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
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
                painter: _SettingsBackgroundPainter(),
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

                    // Settings content
                    Expanded(
                      child: _model.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )
                          : SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: const EdgeInsets.only(bottom: 32),
                              child: Column(
                                children: [
                                  const SizedBox(height: 8),

                                  // Notifications Section
                                  _buildSectionHeader('Notifications', Icons.notifications_outlined),
                                  _buildNotificationsSection(),

                                  const SizedBox(height: 24),

                                  // Rewards Section
                                  _buildSectionHeader('Rewards', Icons.card_giftcard),
                                  _buildRewardsSection(),

                                  const SizedBox(height: 24),

                                  // Privacy Section
                                  _buildSectionHeader('Privacy', Icons.lock_outline),
                                  _buildPrivacySection(),

                                  const SizedBox(height: 32),

                                  // Logout Button
                                  _buildLogoutButton(),

                                  const SizedBox(height: 16),

                                  // Delete Account Button
                                  _buildDeleteAccountButton(),
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
          const Text(
            'Settings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
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
                  icon: Icons.person_outline,
                  title: 'My Profile',
                  subtitle: 'View and edit profile',
                  onTap: () => context.pushNamed('MyProfileScreen'),
                  accentColor: Colors.blue,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.book_online_outlined,
                  title: 'My Bookings',
                  subtitle: 'View your bookings',
                  onTap: () => context.pushNamed('MyBookingsScreen'),
                  accentColor: Colors.purple,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.sports_handball_outlined,
                  title: 'Game Requests',
                  subtitle: 'Manage game requests',
                  onTap: () => context.pushNamed('GameRequestsScreen'),
                  accentColor: Colors.green,
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
                  icon: Icons.more_horiz,
                  title: 'More Options',
                  subtitle: 'Additional settings',
                  onTap: () => context.pushNamed('MoreOptionsScreen'),
                  accentColor: Colors.indigo,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationsSection() {
    if (_model.userSettings == null) return const SizedBox.shrink();
    final settings = _model.userSettings!;

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
                _buildSwitchTile(
                  icon: Icons.notifications_active,
                  title: 'Push Notifications',
                  subtitle: 'Receive push notifications',
                  value: settings.pushNotifications,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(pushNotifications: value);
                    });
                    _updateSetting('push_notifications', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  title: 'Email Notifications',
                  subtitle: 'Receive email updates',
                  value: settings.emailNotifications,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(emailNotifications: value);
                    });
                    _updateSetting('email_notifications', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.sports_handball,
                  title: 'Game Requests',
                  subtitle: 'Notify for game requests',
                  value: settings.gameRequestNotifications,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(gameRequestNotifications: value);
                    });
                    _updateSetting('game_request_notifications', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.book_online,
                  title: 'Bookings',
                  subtitle: 'Notify for booking updates',
                  value: settings.bookingNotifications,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(bookingNotifications: value);
                    });
                    _updateSetting('booking_notifications', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.chat_bubble_outline,
                  title: 'Chat Messages',
                  subtitle: 'Notify for new messages',
                  value: settings.chatNotifications,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(chatNotifications: value);
                    });
                    _updateSetting('chat_notifications', value);
                  },
                  accentColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRewardsSection() {
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
                  icon: Icons.card_giftcard,
                  title: 'Refer & Earn',
                  subtitle: 'Get ₹50 for each referral',
                  onTap: () => context.pushNamed('ReferralsScreen'),
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.local_offer,
                  title: 'My Offers',
                  subtitle: 'View available discounts',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Offers are automatically applied during payment'),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  accentColor: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPrivacySection() {
    if (_model.userSettings == null) return const SizedBox.shrink();
    final settings = _model.userSettings!;

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
                _buildSwitchTile(
                  icon: Icons.visibility_outlined,
                  title: 'Profile Visible',
                  subtitle: 'Show your profile to others',
                  value: settings.profileVisible,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(profileVisible: value);
                    });
                    _updateSetting('profile_visible', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.online_prediction_outlined,
                  title: 'Show Online Status',
                  subtitle: 'Let others see when you\'re online',
                  value: settings.showOnlineStatus,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(showOnlineStatus: value);
                    });
                    _updateSetting('show_online_status', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.location_on_outlined,
                  title: 'Show Location',
                  subtitle: 'Share your location with others',
                  value: settings.showLocation,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(showLocation: value);
                    });
                    _updateSetting('show_location', value);
                  },
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildSwitchTile(
                  icon: Icons.person_add_outlined,
                  title: 'Allow Friend Requests',
                  subtitle: 'Receive friend requests',
                  value: settings.allowFriendRequests,
                  onChanged: (value) {
                    setState(() {
                      _model.userSettings = settings.copyWith(allowFriendRequests: value);
                    });
                    _updateSetting('allow_friend_requests', value);
                  },
                  accentColor: Colors.orange,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSupportSection() {
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
                  icon: Icons.contact_support_outlined,
                  title: 'Contact Support',
                  subtitle: 'Get help from our team',
                  onTap: () => context.pushNamed('ContactSupportScreen'),
                  accentColor: Colors.blue,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.report_problem_outlined,
                  title: 'Report a Problem',
                  subtitle: 'Report issues or bugs',
                  onTap: () => context.pushNamed('ContactSupportScreen'),
                  accentColor: Colors.orange,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.help_outline,
                  title: 'Help Center',
                  subtitle: 'Browse help articles',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Help center coming soon'),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  accentColor: Colors.green,
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
                  onTap: () => context.pushNamed('PolicyScreen', queryParameters: {'policyType': 'privacy'}),
                  accentColor: Colors.teal,
                ),
                _buildDivider(),
                _buildNavigationTile(
                  icon: Icons.description_outlined,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms',
                  onTap: () => context.pushNamed('PolicyScreen', queryParameters: {'policyType': 'terms'}),
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
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('About section coming soon'),
                        backgroundColor: Colors.orange,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildSocialButton(
                  icon: FontAwesomeIcons.instagram,
                  color: const Color(0xFFE4405F),
                  onTap: () => launchURL('https://instagram.com/faceoutsocial'),
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

  Widget _buildLogoutButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          final confirm = await showDialog<bool>(
            context: context,
            builder: (context) => _buildConfirmDialog(
              title: 'Logout',
              content: 'Are you sure you want to logout?',
              confirmText: 'Logout',
              confirmColor: Colors.orange,
            ),
          );

          if (confirm == true && mounted) {
            await authManager.signOut();
            if (context.mounted) {
              context.goNamed(WelcomeScreen.routeName);
            }
          }
        },
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.logout,
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                'Log Out',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.9),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: () async {
          final userEmail = currentUserEmail;
          final userPhone = currentPhoneNumber;
          final String verificationText = userEmail.isNotEmpty ? userEmail : userPhone;

          // Create controller that will be managed by the dialog
          TextEditingController? controller;

          final confirm = await showDialog<bool>(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              // Create controller inside builder so it's part of the dialog lifecycle
              controller = TextEditingController();

              return StatefulBuilder(
                builder: (context, setState) {
                  return AlertDialog(
                  backgroundColor: const Color(0xFF1E1E1E),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: Colors.red.withValues(alpha: 0.3),
                      width: 1.5,
                    ),
                  ),
                  title: const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: Colors.red, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'Delete Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'This action cannot be undone. All your data will be permanently deleted.',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'To confirm, please enter your ${userEmail.isNotEmpty ? "email" : "phone number"}:',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        verificationText,
                        style: TextStyle(
                          color: Colors.red.withValues(alpha: 0.9),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller!,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: userEmail.isNotEmpty ? 'Enter your email' : 'Enter your phone number',
                          hintStyle: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                          ),
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.05),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.white.withValues(alpha: 0.2),
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: Colors.red,
                              width: 2,
                            ),
                          ),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.7),
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: controller!.text.trim() == verificationText
                          ? () => Navigator.pop(context, true)
                          : null,
                      child: Text(
                        'Delete Account',
                        style: TextStyle(
                          color: controller!.text.trim() == verificationText
                              ? Colors.red
                              : Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
          );

          // Dispose controller after a frame to ensure dialog animation is complete
          if (controller != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              controller?.dispose();
            });
          }

          if (confirm == true && mounted) {
            try {
              await _service.deleteAccount(currentUserUid);
              await authManager.signOut();
              if (context.mounted) {
                context.goNamed(WelcomeScreen.routeName);
              }
            } catch (e) {
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Failed to delete account: $e'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              }
            }
          }
        },
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFDC2626), Color(0xFFB91C1C)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.red.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.delete_forever,
                color: Colors.white,
                size: 20,
              ),
              SizedBox(width: 12),
              Text(
                'Delete Account',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color accentColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
          Transform.scale(
            scale: 0.9,
            child: Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: accentColor,
              activeTrackColor: accentColor.withValues(alpha: 0.5),
              inactiveThumbColor: Colors.grey,
              inactiveTrackColor: Colors.grey.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavigationTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    required Color accentColor,
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

  Widget _buildConfirmDialog({
    required String title,
    required String content,
    required String confirmText,
    required Color confirmColor,
  }) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: confirmColor.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 14,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(
            confirmText,
            style: TextStyle(
              color: confirmColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

}

class _SettingsBackgroundPainter extends CustomPainter {
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
