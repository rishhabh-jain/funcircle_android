import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/game_requests_service.dart';
import '../../models/game_request.dart';
import 'widgets/received_request_card.dart';
import 'widgets/sent_request_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'game_requests_model.dart';
export 'game_requests_model.dart';

class GameRequestsWidget extends StatefulWidget {
  const GameRequestsWidget({super.key});

  static String routeName = 'GameRequestsScreen';
  static String routePath = '/gameRequests';

  @override
  State<GameRequestsWidget> createState() => _GameRequestsWidgetState();
}

class _GameRequestsWidgetState extends State<GameRequestsWidget>
    with SingleTickerProviderStateMixin {
  late GameRequestsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late GameRequestsService _service;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameRequestsModel());
    _service = GameRequestsService(SupaFlow.client);
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadReceivedRequests();
    _loadSentRequests();
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
      setState(() {});
    }
  }

  Future<void> _loadReceivedRequests() async {
    if (currentUserUid.isEmpty) return;

    setState(() {
      _model.isLoadingReceived = true;
    });

    try {
      final requests = await _service.getReceivedRequests(currentUserUid);
      setState(() {
        _model.receivedRequests = requests;
        _model.isLoadingReceived = false;
      });
    } catch (e) {
      setState(() {
        _model.isLoadingReceived = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load received requests: $e')),
        );
      }
    }
  }

  Future<void> _loadSentRequests() async {
    if (currentUserUid.isEmpty) return;

    setState(() {
      _model.isLoadingSent = true;
    });

    try {
      final requests = await _service.getSentRequests(currentUserUid);
      setState(() {
        _model.sentRequests = requests;
        _model.isLoadingSent = false;
      });
    } catch (e) {
      setState(() {
        _model.isLoadingSent = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load sent requests: $e')),
        );
      }
    }
  }

  Future<void> _handleAccept(GameRequest request) async {
    try {
      await _service.acceptRequest(request.requestId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Request accepted'),
            backgroundColor: Colors.green,
          ),
        );
        _loadReceivedRequests();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to accept request: $e')),
        );
      }
    }
  }

  Future<void> _handleReject(GameRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Request'),
        content: const Text('Are you sure you want to reject this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.rejectRequest(request.requestId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request rejected')),
          );
          _loadReceivedRequests();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to reject request: $e')),
          );
        }
      }
    }
  }

  Future<void> _handleCancel(GameRequest request) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Request'),
        content: const Text('Are you sure you want to cancel this request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await _service.cancelRequest(request.requestId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Request cancelled')),
          );
          _loadSentRequests();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to cancel request: $e')),
          );
        }
      }
    }
  }

  void _showMockReceivedRequests() {
    setState(() {
      _model.receivedRequests = [
        GameRequest(
          requestId: 'mock-1',
          senderId: 'user-1',
          senderName: 'Rahul Sharma',
          senderImage: 'https://i.pravatar.cc/150?img=12',
          senderLevel: '4',
          receiverId: currentUserUid,
          receiverName: 'You',
          sportType: 'Badminton',
          message: 'Hey! Want to play doubles tomorrow morning? I know a great court nearby.',
          status: 'pending',
          requestedAt: DateTime.now().subtract(const Duration(hours: 2)),
          venueName: 'Ace Badminton Academy',
        ),
        GameRequest(
          requestId: 'mock-2',
          senderId: 'user-2',
          senderName: 'Priya Singh',
          senderImage: 'https://i.pravatar.cc/150?img=47',
          senderLevel: '3',
          receiverId: currentUserUid,
          receiverName: 'You',
          sportType: 'Pickleball',
          message: 'Looking for a mixed doubles partner for this weekend. Are you available?',
          status: 'pending',
          requestedAt: DateTime.now().subtract(const Duration(hours: 5)),
          venueName: 'Sports Hub Center',
        ),
        GameRequest(
          requestId: 'mock-3',
          senderId: 'user-3',
          senderName: 'Amit Kumar',
          senderImage: 'https://i.pravatar.cc/150?img=33',
          senderLevel: '5',
          receiverId: currentUserUid,
          receiverName: 'You',
          sportType: 'Badminton',
          message: null,
          status: 'accepted',
          requestedAt: DateTime.now().subtract(const Duration(days: 1)),
          respondedAt: DateTime.now().subtract(const Duration(hours: 20)),
          venueName: 'Phoenix Sports Complex',
        ),
        GameRequest(
          requestId: 'mock-4',
          senderId: 'user-4',
          senderName: 'Sneha Patel',
          senderImage: 'https://i.pravatar.cc/150?img=25',
          senderLevel: '2',
          receiverId: currentUserUid,
          receiverName: 'You',
          sportType: 'Badminton',
          message: 'Hi! I saw your profile and I think we would be a good match for singles.',
          status: 'rejected',
          requestedAt: DateTime.now().subtract(const Duration(days: 2)),
          respondedAt: DateTime.now().subtract(const Duration(days: 1, hours: 18)),
        ),
      ];
    });
  }

  void _showMockSentRequests() {
    setState(() {
      _model.sentRequests = [
        GameRequest(
          requestId: 'mock-sent-1',
          senderId: currentUserUid,
          senderName: 'You',
          receiverId: 'user-5',
          receiverName: 'Arjun Mehta',
          receiverImage: 'https://i.pravatar.cc/150?img=68',
          receiverLevel: '4',
          sportType: 'Badminton',
          message: 'Hey! Would love to play a match with you this Friday evening.',
          status: 'pending',
          requestedAt: DateTime.now().subtract(const Duration(hours: 3)),
          venueName: 'Elite Sports Arena',
        ),
        GameRequest(
          requestId: 'mock-sent-2',
          senderId: currentUserUid,
          senderName: 'You',
          receiverId: 'user-6',
          receiverName: 'Kavya Reddy',
          receiverImage: 'https://i.pravatar.cc/150?img=44',
          receiverLevel: '3',
          sportType: 'Pickleball',
          message: 'Interested in playing a casual game this weekend?',
          status: 'accepted',
          requestedAt: DateTime.now().subtract(const Duration(hours: 12)),
          respondedAt: DateTime.now().subtract(const Duration(hours: 8)),
          venueName: 'City Sports Club',
        ),
        GameRequest(
          requestId: 'mock-sent-3',
          senderId: currentUserUid,
          senderName: 'You',
          receiverId: 'user-7',
          receiverName: 'Rohan Verma',
          receiverImage: 'https://i.pravatar.cc/150?img=15',
          receiverLevel: '5',
          sportType: 'Badminton',
          message: null,
          status: 'cancelled',
          requestedAt: DateTime.now().subtract(const Duration(days: 1)),
          respondedAt: DateTime.now().subtract(const Duration(hours: 18)),
        ),
      ];
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
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        // Received Tab
                        _buildReceivedTab(),
                        // Sent Tab
                        _buildSentTab(),
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

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(
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
            'Game Requests',
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
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              labelStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.1,
              ),
              tabs: const [
                Tab(text: 'Received'),
                Tab(text: 'Sent'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceivedTab() {
    if (_model.isLoadingReceived) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (_model.receivedRequests.isEmpty) {
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
                Icons.inbox_outlined,
                size: 80,
                color: Colors.orange.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No received requests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Game requests from other players will appear here',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Preview button
            GestureDetector(
              onTap: _showMockReceivedRequests,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.visibility, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Preview UI Design',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReceivedRequests,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _model.receivedRequests.length,
        itemBuilder: (context, index) {
          final request = _model.receivedRequests[index];
          return ReceivedRequestCard(
            request: request,
            onAccept: () => _handleAccept(request),
            onReject: () => _handleReject(request),
          );
        },
      ),
    );
  }

  Widget _buildSentTab() {
    if (_model.isLoadingSent) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (_model.sentRequests.isEmpty) {
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
                Icons.send_outlined,
                size: 80,
                color: Colors.orange.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'No sent requests',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Send game requests to play with other players',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            // Preview button
            GestureDetector(
              onTap: _showMockSentRequests,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.visibility, color: Colors.white, size: 18),
                    SizedBox(width: 8),
                    Text(
                      'Preview UI Design',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadSentRequests,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _model.sentRequests.length,
        itemBuilder: (context, index) {
          final request = _model.sentRequests[index];
          return SentRequestCard(
            request: request,
            onCancel: () => _handleCancel(request),
          );
        },
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
