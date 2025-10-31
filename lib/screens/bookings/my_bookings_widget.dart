import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/bookings_service.dart';
import '../../models/booking.dart';
import 'widgets/booking_card.dart';
import 'booking_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'my_bookings_model.dart';
export 'my_bookings_model.dart';

class MyBookingsWidget extends StatefulWidget {
  const MyBookingsWidget({super.key});

  static String routeName = 'MyBookingsScreen';
  static String routePath = '/myBookings';

  @override
  State<MyBookingsWidget> createState() => _MyBookingsWidgetState();
}

class _MyBookingsWidgetState extends State<MyBookingsWidget>
    with SingleTickerProviderStateMixin {
  late MyBookingsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late BookingsService _service;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyBookingsModel());
    _service = BookingsService(SupaFlow.client);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadBookings();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _model.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (!_tabController.indexIsChanging) {
      final filters = ['all', 'upcoming', 'past', 'cancelled'];
      setState(() {
        _model.currentFilter = filters[_tabController.index];
      });
      _loadBookings();
    }
  }

  Future<void> _loadBookings() async {
    if (currentUserUid.isEmpty) {
      print('No user ID found');
      return;
    }

    setState(() {
      _model.isLoading = true;
      _model.errorMessage = null;
    });

    try {
      print('Loading bookings with filter: ${_model.currentFilter}');
      final bookings = await _service.getUserBookings(
        currentUserUid,
        filter: _model.currentFilter,
      );

      print('Loaded ${bookings.length} bookings successfully');
      setState(() {
        _model.bookings = bookings;
        _model.isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading bookings: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _model.isLoading = false;
        _model.errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load bookings: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadBookings,
            ),
          ),
        );
      }
    }
  }

  void _showBookingDetails(Booking booking) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookingDetailScreen(booking: booking),
      ),
    ).then((_) {
      // Refresh bookings when returning from details screen
      _loadBookings();
    });
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
                painter: _BackgroundPatternPainter(),
              ),
            ),

            // Main content
            SafeArea(
              child: Column(
                children: [
                  // Header
                  _buildHeader(),

                  // Tabs
                  _buildTabs(),

                  // Content
                  Expanded(
                    child: _model.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : _model.errorMessage != null
                            ? _buildErrorState()
                            : _model.bookings.isEmpty
                                ? _buildEmptyState()
                                : RefreshIndicator(
                                    onRefresh: _loadBookings,
                                    color: Colors.orange,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(20),
                                      itemCount: _model.bookings.length,
                                      itemBuilder: (context, index) {
                                        final booking = _model.bookings[index];
                                        return BookingCard(
                                          booking: booking,
                                          onTap: () => _showBookingDetails(booking),
                                        );
                                      },
                                    ),
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

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.only(
        top: 8,
        left: 8,
        right: 20,
        bottom: 12,
      ),
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
            'My Bookings',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
              indicator: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                ),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.orange.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.all(5),
              dividerColor: Colors.transparent,
              labelPadding: const EdgeInsets.symmetric(horizontal: 4),
              labelStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              tabs: const [
                Tab(text: 'All'),
                Tab(text: 'Upcoming'),
                Tab(text: 'Past'),
                Tab(text: 'Cancelled'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.red.withValues(alpha: 0.2),
                    Colors.red.withValues(alpha: 0.05),
                  ],
                ),
              ),
              child: Icon(
                Icons.error_outline,
                size: 80,
                color: Colors.red.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Error Loading Bookings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.red.withValues(alpha: 0.3),
                ),
              ),
              child: SingleChildScrollView(
                child: SelectableText(
                  _model.errorMessage ?? 'Unknown error',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                    fontFamily: 'monospace',
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadBookings,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    IconData icon;

    switch (_model.currentFilter) {
      case 'upcoming':
        message = 'No upcoming bookings';
        icon = Icons.event_available;
        break;
      case 'past':
        message = 'No past bookings';
        icon = Icons.history;
        break;
      case 'cancelled':
        message = 'No cancelled bookings';
        icon = Icons.cancel;
        break;
      default:
        message = 'No bookings yet';
        icon = Icons.book_online;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.2),
                  Colors.orange.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: Icon(
              icon,
              size: 80,
              color: Colors.orange.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            message,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Book a game to get started',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}

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
    for (int i = 0; i < 8; i++) {
      canvas.drawLine(
        Offset(0, size.height * (i * 0.125)),
        Offset(size.width * 0.3, size.height * (i * 0.125)),
        paint,
      );
    }

    // Gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.orange.withValues(alpha: 0.02),
          Colors.transparent,
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

