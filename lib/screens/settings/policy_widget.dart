import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../../services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'policy_model.dart';
export 'policy_model.dart';

class PolicyWidget extends StatefulWidget {
  final String policyType;

  const PolicyWidget({
    super.key,
    required this.policyType,
  });

  static String routeName = 'PolicyScreen';
  static String routePath = '/policy';

  @override
  State<PolicyWidget> createState() => _PolicyWidgetState();
}

class _PolicyWidgetState extends State<PolicyWidget> with TickerProviderStateMixin {
  late PolicyModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late SettingsService _service;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PolicyModel());
    _service = SettingsService(SupaFlow.client);

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _loadPolicy();
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadPolicy() async {
    setState(() {
      _model.isLoading = true;
    });

    try {
      print('Loading policy type: ${widget.policyType}');
      final policy = await _service.getPolicy(widget.policyType);
      print('Policy loaded: ${policy != null ? policy.title : "NULL"}');

      setState(() {
        _model.policy = policy;
        _model.isLoading = false;
      });

      if (policy == null) {
        print('⚠️ Policy is null for type: ${widget.policyType}');
      }
    } catch (e) {
      print('❌ Error loading policy: $e');
      setState(() {
        _model.isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load policy: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  String get _title {
    switch (widget.policyType) {
      case 'privacy':
        return 'Privacy Policy';
      case 'terms':
        return 'Terms of Service';
      case 'community':
        return 'Community Guidelines';
      default:
        return 'Policy';
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
                painter: _PolicyBackgroundPainter(),
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
                      child: _model.isLoading
                          ? const Center(
                              child: CircularProgressIndicator(
                                color: Colors.orange,
                              ),
                            )
                          : _model.policy == null
                              ? _buildErrorState()
                              : SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 32),
                                  child: _buildPolicyContent(),
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
          Expanded(
            child: Text(
              _title,
              style: const TextStyle(
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

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(32),
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.orange.withValues(alpha: 0.8),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Policy Not Found',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Unable to load the policy. Please try again later.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 24),
                  GestureDetector(
                    onTap: _loadPolicy,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                        ),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withValues(alpha: 0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
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

  Widget _buildPolicyContent() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.all(24),
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
                // Title
                Text(
                  _model.policy!.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Version and date
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'Version ${_model.policy!.version} • Effective ${DateFormat('MMM dd, yyyy').format(_model.policy!.effectiveDate)}',
                    style: TextStyle(
                      color: Colors.orange.withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Content - render markdown-style text
                _buildMarkdownContent(_model.policy!.content),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMarkdownContent(String content) {
    final lines = content.split('\n');
    final List<Widget> widgets = [];

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];

      if (line.trim().isEmpty) {
        widgets.add(const SizedBox(height: 8));
        continue;
      }

      // H1 Headers (# )
      if (line.startsWith('# ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            line.substring(2),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
        continue;
      }

      // H2 Headers (## )
      if (line.startsWith('## ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Row(
            children: [
              Container(
                width: 4,
                height: 20,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  line.substring(3),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.95),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ));
        continue;
      }

      // Bullet points (- )
      if (line.startsWith('- ')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(left: 8, top: 4, bottom: 4),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 8),
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  line.substring(2),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),
            ],
          ),
        ));
        continue;
      }

      // Horizontal rule (---)
      if (line.trim() == '---') {
        widgets.add(Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.orange.withValues(alpha: 0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ));
        continue;
      }

      // Bold text (**text**)
      if (line.contains('**')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Text(
            line.replaceAll('**', ''),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 15,
              fontWeight: FontWeight.bold,
              height: 1.6,
            ),
          ),
        ));
        continue;
      }

      // Italic text (*text*)
      if (line.startsWith('*') && line.endsWith('*')) {
        widgets.add(Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            line.substring(1, line.length - 1),
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontStyle: FontStyle.italic,
              height: 1.6,
            ),
          ),
        ));
        continue;
      }

      // Regular paragraph text
      widgets.add(Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 4),
        child: Text(
          line,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.85),
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ));
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: widgets,
    );
  }
}

class _PolicyBackgroundPainter extends CustomPainter {
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
