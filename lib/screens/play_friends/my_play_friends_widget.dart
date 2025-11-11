import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../../services/play_friends_service.dart';
import '../../models/play_friend.dart';
import 'widgets/play_friend_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'my_play_friends_model.dart';
export 'my_play_friends_model.dart';

class MyPlayFriendsWidget extends StatefulWidget {
  const MyPlayFriendsWidget({super.key});

  static String routeName = 'PlayFriendsScreen';
  static String routePath = '/playFriends';

  @override
  State<MyPlayFriendsWidget> createState() => _MyPlayFriendsWidgetState();
}

class _MyPlayFriendsWidgetState extends State<MyPlayFriendsWidget>
    with TickerProviderStateMixin {
  late MyPlayFriendsModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  late PlayFriendsService _service;
  late AnimationController _statsAnimationController;
  late Animation<double> _statsAnimation;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyPlayFriendsModel());
    _service = PlayFriendsService(SupaFlow.client);

    _statsAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _statsAnimation = CurvedAnimation(
      parent: _statsAnimationController,
      curve: Curves.easeOutCubic,
    );

    _loadFriends();
    _statsAnimationController.forward();
  }

  @override
  void dispose() {
    _statsAnimationController.dispose();
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    if (currentUserUid.isEmpty) return;

    setState(() {
      _model.isLoading = true;
    });

    try {
      final friends = await _service.getPlayFriends(
        currentUserUid,
        favoritesOnly: _model.favoritesOnly,
        sportType: _model.sportFilter != 'all' ? _model.sportFilter : null,
      );

      setState(() {
        _model.allFriends = friends;
        _applyFilters();
        _model.isLoading = false;
      });
    } catch (e) {
      print('Error loading friends: $e');
      setState(() {
        _model.isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load friends: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _applyFilters() {
    var filtered = List<PlayFriend>.from(_model.allFriends);

    // Apply search filter
    if (_model.searchQuery.isNotEmpty) {
      filtered = filtered.where((friend) {
        final name = friend.displayName.toLowerCase();
        final query = _model.searchQuery.toLowerCase();
        return name.contains(query);
      }).toList();
    }

    setState(() {
      _model.filteredFriends = filtered;
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _model.searchQuery = query;
    });
    _applyFilters();
  }

  void _onFilterChanged(String filter) {
    setState(() {
      if (filter == 'favorites') {
        _model.favoritesOnly = !_model.favoritesOnly;
      } else {
        _model.sportFilter = filter;
        _model.favoritesOnly = false;
      }
    });
    _loadFriends();
  }

  Future<void> _toggleFavorite(PlayFriend friend) async {
    try {
      await _service.toggleFavorite(friend.friendshipId, !friend.isFavorite);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              friend.isFavorite
                  ? 'Removed from favorites'
                  : 'Added to favorites',
            ),
            backgroundColor: Colors.orange,
            behavior: SnackBarBehavior.floating,
          ),
        );
        _loadFriends();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update favorite: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  int get _totalGamesPlayed {
    return _model.allFriends.fold(0, (sum, friend) => sum + friend.gamesPlayedTogether);
  }

  int get _favoriteCount {
    return _model.allFriends.where((f) => f.isFavorite).length;
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

                  // Stats Overview
                  if (_model.allFriends.isNotEmpty)
                    _buildStatsOverview(),

                  // Search Bar
                  _buildSearchBar(),

                  // Filter Chips
                  _buildFilterChips(),

                  const SizedBox(height: 16),

                  // Friends List
                  Expanded(
                    child: _buildFriendsList(),
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
            'Play Friends',
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

  Widget _buildStatsOverview() {
    return FadeTransition(
      opacity: _statsAnimation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, -0.3),
          end: Offset.zero,
        ).animate(_statsAnimation),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(child: _buildStatCard(
                'Total Friends',
                _model.allFriends.length.toString(),
                Icons.people,
                const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(
                'Total Games',
                _totalGamesPlayed.toString(),
                Icons.sports_tennis,
                const LinearGradient(
                  colors: [Color(0xFF4CAF50), Color(0xFF8BC34A)],
                ),
              )),
              const SizedBox(width: 12),
              Expanded(child: _buildStatCard(
                'Favorites',
                _favoriteCount.toString(),
                Icons.star,
                const LinearGradient(
                  colors: [Color(0xFFFFB300), Color(0xFFFFC107)],
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Gradient gradient) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.orange.withValues(alpha: 0.3),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 20),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: TextField(
              controller: _model.searchController,
              focusNode: _model.searchFocusNode,
              onChanged: _onSearchChanged,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search friends...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.orange.withValues(alpha: 0.8),
                ),
                suffixIcon: _model.searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          _model.searchController?.clear();
                          _onSearchChanged('');
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _buildFilterChip(
            'Favorites',
            Icons.star,
            _model.favoritesOnly,
            () => _onFilterChanged('favorites'),
            Colors.amber,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'All Sports',
            Icons.sports,
            _model.sportFilter == 'all',
            () => _onFilterChanged('all'),
            Colors.blue,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Badminton',
            Icons.sports_tennis,
            _model.sportFilter == 'Badminton',
            () => _onFilterChanged('Badminton'),
            Colors.green,
          ),
          const SizedBox(width: 8),
          _buildFilterChip(
            'Pickleball',
            Icons.sports_handball,
            _model.sportFilter == 'Pickleball',
            () => _onFilterChanged('Pickleball'),
            Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    String label,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
    Color accentColor,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isSelected
                  ? LinearGradient(
                      colors: [
                        accentColor.withValues(alpha: 0.3),
                        accentColor.withValues(alpha: 0.15),
                      ],
                    )
                  : LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.1),
                        Colors.white.withValues(alpha: 0.05),
                      ],
                    ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected
                    ? accentColor.withValues(alpha: 0.5)
                    : Colors.white.withValues(alpha: 0.15),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  size: 16,
                  color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: isSelected ? accentColor : Colors.white.withValues(alpha: 0.7),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsList() {
    if (_model.isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Colors.orange,
        ),
      );
    }

    if (_model.filteredFriends.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadFriends,
      color: Colors.orange,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _model.filteredFriends.length,
        itemBuilder: (context, index) {
          final friend = _model.filteredFriends[index];
          return PlayFriendCard(
            friend: friend,
            onToggleFavorite: () => _toggleFavorite(friend),
            onViewProfile: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('View profile coming soon'),
                  backgroundColor: Colors.orange,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            onSendMessage: () async {
              try {
                final roomId = await _service.findOrCreateChatRoom(
                  currentUserUid,
                  friend.friendId,
                );

                if (roomId != null && mounted) {
                  // Navigate to chat room
                  context.pushNamed(
                    'ChatRoom',
                    queryParameters: {'roomId': roomId},
                  );
                }
              } catch (e) {
                print('Error opening chat: $e');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to open chat: $e'),
                      backgroundColor: Colors.red,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
            },
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    String message;
    String subtitle;

    if (_model.searchQuery.isNotEmpty) {
      message = 'No friends found';
      subtitle = 'Try a different search term';
    } else if (_model.favoritesOnly) {
      message = 'No favorite friends';
      subtitle = 'Star your favorite friends to see them here';
    } else if (_model.sportFilter != 'all') {
      message = 'No ${_model.sportFilter} friends';
      subtitle = 'No friends play this sport';
    } else {
      message = 'No play friends yet';
      subtitle = 'Play games with others to make friends';
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
              Icons.people_outline,
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
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
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
