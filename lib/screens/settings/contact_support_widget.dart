import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/settings_service.dart';
import '../../models/support_ticket.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'contact_support_model.dart';
export 'contact_support_model.dart';

class ContactSupportWidget extends StatefulWidget {
  const ContactSupportWidget({super.key});

  static String routeName = 'ContactSupportScreen';
  static String routePath = '/contactSupport';

  @override
  State<ContactSupportWidget> createState() => _ContactSupportWidgetState();
}

class _ContactSupportWidgetState extends State<ContactSupportWidget> with TickerProviderStateMixin {
  late ContactSupportModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingsService _service;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ContactSupportModel());
    _service = SettingsService(SupaFlow.client);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _submitTicket() async {
    if (!_model.formKey.currentState!.validate()) return;

    setState(() {
      _model.isSubmitting = true;
    });

    try {
      final ticket = SupportTicket(
        userId: currentUserUid,
        subject: _model.subjectController!.text.trim(),
        description: _model.descriptionController!.text.trim(),
        category: _model.selectedCategory,
        createdAt: DateTime.now(),
      );

      // Save ticket to database (email notification will be handled by Supabase webhook)
      await _service.submitSupportTicket(ticket);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Support ticket submitted successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Clear form
        _model.subjectController!.clear();
        _model.descriptionController!.clear();
        setState(() {
          _model.selectedCategory = 'Help';
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit ticket: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _model.isSubmitting = false;
        });
      }
    }
  }

  void _showFAQBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.help_outline, color: Colors.white, size: 24),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Frequently Asked Questions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // FAQ List
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  _buildFAQItem(
                    'How do I book a venue?',
                    'Go to the Venues tab, select your preferred venue, choose a time slot, and complete the booking. You can pay online or at the venue.',
                  ),
                  _buildFAQItem(
                    'How do I find play friends?',
                    'Navigate to the Play Friends section, use filters for sport type and skill level, and send friend requests to players you want to connect with.',
                  ),
                  _buildFAQItem(
                    'Can I cancel my booking?',
                    'Yes, you can cancel bookings from the My Bookings section. Cancellation policies vary by venue. Check the venue details for specific refund policies.',
                  ),
                  _buildFAQItem(
                    'How do game requests work?',
                    'You can send game requests to other players. They will receive a notification and can accept or decline. You can view all your requests in the Game Requests section.',
                  ),
                  _buildFAQItem(
                    'What payment methods are accepted?',
                    'We accept UPI, credit/debit cards, net banking, and wallets. Some venues also accept cash payments.',
                  ),
                  _buildFAQItem(
                    'How do I update my skill level?',
                    'Go to Settings → Profile, and update your skill level for Badminton or Pickleball. This helps match you with players of similar abilities.',
                  ),
                  _buildFAQItem(
                    'Can I bring a guest to my booking?',
                    'Yes, most venues allow guests. The number of players allowed depends on the court type and booking. Check your booking details.',
                  ),
                  _buildFAQItem(
                    'How do I report a problem?',
                    'Use the Contact Us form on this page, or email us directly at funcircleapp@gmail.com. We typically respond within 24 hours.',
                  ),
                  _buildFAQItem(
                    'Is there a cancellation fee?',
                    'Cancellation fees depend on the venue and how far in advance you cancel. Most venues offer free cancellation 24+ hours before the booking.',
                  ),
                  _buildFAQItem(
                    'How do I add friends?',
                    'You can add friends by sending them game requests or connecting after playing together. You can also search for players in the Find Players section.',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.1),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
        ),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          title: Text(
            question,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          iconColor: Colors.orange,
          collapsedIconColor: Colors.white.withValues(alpha: 0.6),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                answer,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
                painter: _SupportBackgroundPainter(),
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

                            // Support Options Section
                            _buildSectionHeader('Support Options', Icons.support_agent),
                            _buildSupportOptionsSection(),

                            const SizedBox(height: 24),

                            // Contact Form Section
                            _buildSectionHeader('Contact Us', Icons.contact_mail_outlined),
                            _buildContactFormSection(),
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
            'Help & Support',
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

  Widget _buildSupportOptionsSection() {
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
                _buildSupportOptionTile(
                  icon: Icons.email_outlined,
                  title: 'Email Support',
                  subtitle: 'funcircleapp@gmail.com',
                  onTap: () => launchURL('mailto:funcircleapp@gmail.com'),
                  accentColor: Colors.blue,
                ),
                _buildDivider(),
                _buildSupportOptionTile(
                  icon: Icons.phone_outlined,
                  title: 'Call Us',
                  subtitle: '+91 95610 79271',
                  onTap: () => launchURL('tel:+919561079271'),
                  accentColor: Colors.green,
                ),
                _buildDivider(),
                _buildSupportOptionTile(
                  icon: Icons.help_outline,
                  title: 'FAQ',
                  subtitle: 'Find answers to common questions',
                  onTap: _showFAQBottomSheet,
                  accentColor: Colors.amber,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactFormSection() {
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
            child: Form(
              key: _model.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Intro text
                  Text(
                    'We\'re here to help!',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Fill out the form below and we\'ll get back to you as soon as possible.',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Category Selection
                  Text(
                    'Category',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildCategoryChip('Help', 'help'),
                      _buildCategoryChip('Bug Report', 'bug'),
                      _buildCategoryChip('Feature Request', 'feature_request'),
                      _buildCategoryChip('Other', 'other'),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Subject Field
                  Text(
                    'Subject',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.subjectController,
                    focusNode: _model.subjectFocusNode,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter subject',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Subject is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Description Field
                  Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _model.descriptionController,
                    focusNode: _model.descriptionFocusNode,
                    maxLines: 6,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Describe your issue or request',
                      hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                      filled: true,
                      fillColor: Colors.white.withValues(alpha: 0.08),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.orange, width: 2),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.red, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Description is required';
                      }
                      if (value.trim().length < 10) {
                        return 'Description must be at least 10 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    child: GestureDetector(
                      onTap: _model.isSubmitting ? null : _submitTicket,
                      child: Container(
                        height: 54,
                        decoration: BoxDecoration(
                          gradient: _model.isSubmitting
                              ? LinearGradient(
                                  colors: [
                                    Colors.grey.withValues(alpha: 0.5),
                                    Colors.grey.withValues(alpha: 0.3),
                                  ],
                                )
                              : const LinearGradient(
                                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                                ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: !_model.isSubmitting
                              ? [
                                  BoxShadow(
                                    color: Colors.orange.withValues(alpha: 0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_model.isSubmitting)
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            else
                              const Icon(
                                Icons.send,
                                color: Colors.white,
                                size: 20,
                              ),
                            const SizedBox(width: 12),
                            Text(
                              _model.isSubmitting ? 'Submitting...' : 'Submit Ticket',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
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
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, String value) {
    final isSelected = _model.selectedCategory == value;
    return GestureDetector(
      onTap: () {
        setState(() {
          _model.selectedCategory = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                )
              : null,
          color: !isSelected ? Colors.white.withValues(alpha: 0.1) : null,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.orange.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
            width: 1.5,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildSupportOptionTile({
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
}

class _SupportBackgroundPainter extends CustomPainter {
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
