import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/my_games_service.dart';
import '../../models/my_game_item.dart';
import '../../find_players_new/models/player_request_model.dart';
import '../../find_players_new/widgets/request_info_sheet.dart';
import '../../playnow/pages/game_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'game_requests_model.dart';
export 'game_requests_model.dart';

/// Screen showing ALL games and requests user is involved in
/// Includes both FindPlayers requests and PlayNow games (paid or free)
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

  late MyGamesService _service;
  late TabController _tabController;
  List<MyGameItem> _allGames = [];
  bool _isLoading = true;
  String? _errorMessage;
  String _currentFilter = 'all';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => GameRequestsModel());
    _service = MyGamesService(SupaFlow.client);
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_onTabChanged);
    _loadGames();
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
        _currentFilter = filters[_tabController.index];
      });
      _loadGames();
    }
  }

  Future<void> _loadGames() async {
    if (currentUserUid.isEmpty) {
      print('No user ID found');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      print('Loading games with filter: $_currentFilter');
      final games = await _service.getUserGames(
        currentUserUid,
        filter: _currentFilter,
      );

      print('Loaded ${games.length} games successfully');
      setState(() {
        _allGames = games;
        _isLoading = false;
      });
    } catch (e, stackTrace) {
      print('Error loading games: $e');
      print('Stack trace: $stackTrace');

      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load games: $e'),
            duration: const Duration(seconds: 5),
            action: SnackBarAction(
              label: 'Retry',
              onPressed: _loadGames,
            ),
          ),
        );
      }
    }
  }

  void _navigateToGameDetails(MyGameItem game) async {
    if (game.isPlayNow) {
      // Navigate to PlayNow game details page
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => GameDetailsPage(gameId: game.id),
        ),
      );
    } else {
      // For FindPlayers, fetch full request data and show bottom sheet
      try {
        // Fetch complete request data from database
        final requestData = await SupaFlow.client
            .schema('findplayers')
            .from('player_requests')
            .select('''
              *,
              users!player_requests_user_id_fkey(
                user_id,
                first_name,
                profile_picture,
                skill_level_badminton,
                skill_level_pickleball
              )
            ''')
            .eq('id', game.id)
            .maybeSingle();

        if (requestData == null) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Request not found'),
                backgroundColor: Colors.red,
              ),
            );
          }
          return;
        }

        // Transform to PlayerRequestModel
        final userData = requestData['users'];

        // Get user skill level based on sport type
        int? userSkillLevel;
        if (userData != null) {
          if (game.sportType.toLowerCase() == 'badminton') {
            userSkillLevel = userData['skill_level_badminton'] as int?;
          } else {
            userSkillLevel = userData['skill_level_pickleball'] as int?;
          }
        }

        final request = PlayerRequestModel(
          id: requestData['id'] as String,
          userId: requestData['user_id'] as String,
          sportType: requestData['sport_type'] as String,
          venueId: requestData['venue_id'] as int?,
          customLocation: requestData['custom_location'] as String?,
          latitude: requestData['latitude'] != null
              ? (requestData['latitude'] as num).toDouble()
              : null,
          longitude: requestData['longitude'] != null
              ? (requestData['longitude'] as num).toDouble()
              : null,
          playersNeeded: requestData['players_needed'] as int,
          scheduledTime: DateTime.parse(requestData['scheduled_time'] as String),
          skillLevel: requestData['skill_level'] as int?,
          description: requestData['description'] as String?,
          status: requestData['status'] as String,
          createdAt: DateTime.parse(requestData['created_at'] as String),
          expiresAt: DateTime.parse(requestData['expires_at'] as String),
          userName: userData?['first_name'] as String?,
          userProfilePicture: userData?['profile_picture'] as String?,
          userSkillLevel: userSkillLevel,
        );

        // Show request info sheet
        if (mounted) {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => RequestInfoSheet(
              request: request,
              currentUserId: currentUserUid,
            ),
          );
        }
      } catch (e) {
        print('Error fetching request details: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to load request: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
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
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                            ),
                          )
                        : _errorMessage != null
                            ? _buildErrorState()
                            : _allGames.isEmpty
                                ? _buildEmptyState()
                                : RefreshIndicator(
                                    onRefresh: _loadGames,
                                    color: Colors.orange,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.all(20),
                                      itemCount: _allGames.length,
                                      itemBuilder: (context, index) {
                                        final game = _allGames[index];
                                        return _buildGameCard(game);
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
            'My Games',
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

  Widget _buildGameCard(MyGameItem game) {
    final dateFormat = DateFormat('MMM dd, yyyy');
    final timeFormat = DateFormat('h:mm a');

    // Sport color
    Color sportColor = game.sportType.toLowerCase() == 'badminton'
        ? const Color(0xFF4CAF50)
        : const Color(0xFF2196F3);

    // Status color
    Color statusColor;
    switch (game.statusColor) {
      case 'green':
        statusColor = Colors.green;
        break;
      case 'blue':
        statusColor = Colors.blue;
        break;
      case 'orange':
        statusColor = Colors.orange;
        break;
      case 'red':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    return GestureDetector(
      onTap: () => _navigateToGameDetails(game),
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withValues(alpha: 0.1),
              Colors.white.withValues(alpha: 0.05),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with sport, source, and status
                  Row(
                    children: [
                      // Sport badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: sportColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: sportColor.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          game.sportType,
                          style: TextStyle(
                            color: sportColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Source badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: game.isFindPlayers
                              ? Colors.purple.withValues(alpha: 0.2)
                              : Colors.blue.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          game.isFindPlayers ? 'Find Players' : 'Play Now',
                          style: TextStyle(
                            color: game.isFindPlayers
                                ? Colors.purple.shade300
                                : Colors.blue.shade300,
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Spacer(),
                      // Status badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: statusColor.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: statusColor.withValues(alpha: 0.5),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          game.statusDisplay,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Title
                  Text(
                    game.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  // Venue info
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          game.venueName,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Date and time
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        dateFormat.format(game.scheduledDateTime),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Icon(
                        Icons.access_time_outlined,
                        color: Colors.white.withValues(alpha: 0.6),
                        size: 16,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        timeFormat.format(game.scheduledDateTime),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Bottom row with players and payment
                  Row(
                    children: [
                      // Players count
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.people_outline,
                              color: Colors.white.withValues(alpha: 0.8),
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              game.playersDisplay,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      // Payment badge
                      if (game.isPaid)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.currency_rupee,
                                color: Colors.white,
                                size: 14,
                              ),
                              Text(
                                game.paymentAmount.toStringAsFixed(0),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '• ${game.paymentBadge}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 11,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.green.withValues(alpha: 0.5),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Free',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
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
              'Error Loading Games',
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
                  _errorMessage ?? 'Unknown error',
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
              onPressed: _loadGames,
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

    switch (_currentFilter) {
      case 'upcoming':
        message = 'No upcoming games';
        icon = Icons.event_available;
        break;
      case 'past':
        message = 'No past games';
        icon = Icons.history;
        break;
      case 'cancelled':
        message = 'No cancelled games';
        icon = Icons.cancel;
        break;
      default:
        message = 'No games yet';
        icon = Icons.sports_tennis;
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
            'Create or join a game to get started',
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
