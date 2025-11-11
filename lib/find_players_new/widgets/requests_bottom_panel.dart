import 'package:flutter/material.dart';
import 'dart:ui';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '../models/player_request_model.dart';
import '../models/game_session_model.dart';
import '../models/skill_level.dart';
import 'request_info_sheet.dart';
import 'session_info_sheet.dart';
import '../services/location_service.dart';
import '/playnow/widgets/game_card.dart';
import '/playnow/models/game_model.dart';

/// Dark glass UI bottom panel showing game requests, sessions, and organized games (Apple Maps style)
class RequestsBottomPanel extends StatefulWidget {
  final List<PlayerRequestModel> requests;
  final List<GameSessionModel> sessions;
  final List<Map<String, dynamic>> playNowGames;
  final String currentUserId;
  final LatLng? userLocation;
  final VoidCallback onExpand;

  const RequestsBottomPanel({
    super.key,
    required this.requests,
    required this.sessions,
    required this.playNowGames,
    required this.currentUserId,
    this.userLocation,
    required this.onExpand,
  });

  @override
  State<RequestsBottomPanel> createState() => _RequestsBottomPanelState();
}

enum SheetState { minimized, collapsed, expanded }

class _RequestsBottomPanelState extends State<RequestsBottomPanel>
    with SingleTickerProviderStateMixin {
  SheetState _sheetState = SheetState.collapsed;
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Search and filter state
  final _searchController = TextEditingController();
  String _searchQuery = '';
  double? _maxDistance; // km
  int? _selectedSkillLevel;

  bool get _isExpanded => _sheetState == SheetState.expanded;
  bool get _isMinimized => _sheetState == SheetState.minimized;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  /// Sort requests by distance from user location with filters applied
  List<PlayerRequestModel> get _sortedRequests {
    var filtered = widget.requests.where((request) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesDescription =
            request.description?.toLowerCase().contains(query) ?? false;
        final matchesUser =
            request.userName?.toLowerCase().contains(query) ?? false;
        if (!matchesDescription && !matchesUser) return false;
      }

      // Skill level filter
      if (_selectedSkillLevel != null &&
          request.skillLevel != null &&
          request.skillLevel != _selectedSkillLevel) {
        return false;
      }

      // Distance filter
      if (_maxDistance != null &&
          widget.userLocation != null &&
          request.latLng != null) {
        final distance = LocationService.calculateDistance(
          startLatitude: widget.userLocation!.latitude,
          startLongitude: widget.userLocation!.longitude,
          endLatitude: request.latitude!,
          endLongitude: request.longitude!,
        );
        if (distance > _maxDistance!) return false;
      }

      return true;
    }).toList();

    // Sort by distance if user location is available
    if (widget.userLocation != null) {
      filtered.sort((a, b) {
        if (a.latLng == null) return 1;
        if (b.latLng == null) return -1;

        final distA = LocationService.calculateDistance(
          startLatitude: widget.userLocation!.latitude,
          startLongitude: widget.userLocation!.longitude,
          endLatitude: a.latitude!,
          endLongitude: a.longitude!,
        );
        final distB = LocationService.calculateDistance(
          startLatitude: widget.userLocation!.latitude,
          startLongitude: widget.userLocation!.longitude,
          endLatitude: b.latitude!,
          endLongitude: b.longitude!,
        );
        return distA.compareTo(distB);
      });
    }

    return filtered;
  }

  /// Sort sessions by distance from user location
  List<GameSessionModel> get _sortedSessions {
    if (widget.userLocation == null) return widget.sessions;

    final sorted = List<GameSessionModel>.from(widget.sessions);
    sorted.sort((a, b) {
      if (a.latLng == null) return 1;
      if (b.latLng == null) return -1;

      final distA = LocationService.calculateDistance(
        startLatitude: widget.userLocation!.latitude,
        startLongitude: widget.userLocation!.longitude,
        endLatitude: a.latitude!,
        endLongitude: a.longitude!,
      );
      final distB = LocationService.calculateDistance(
        startLatitude: widget.userLocation!.latitude,
        startLongitude: widget.userLocation!.longitude,
        endLatitude: b.latitude!,
        endLongitude: b.longitude!,
      );
      return distA.compareTo(distB);
    });
    return sorted;
  }

  /// Sort playnow games by date (upcoming first) with filters applied
  List<Map<String, dynamic>> get _sortedPlayNowGames {
    var filtered = widget.playNowGames.where((game) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchesDescription =
            (game['description'] as String?)?.toLowerCase().contains(query) ??
                false;
        final matchesCreator =
            (game['creator_name'] as String?)?.toLowerCase().contains(query) ??
                false;
        final matchesGameType = (game['game_type'] as String)
            .toLowerCase()
            .replaceAll('_', ' ')
            .contains(query);
        if (!matchesDescription && !matchesCreator && !matchesGameType) {
          return false;
        }
      }

      // Skill level filter
      if (_selectedSkillLevel != null &&
          game['skill_level'] != null &&
          game['skill_level'] != _selectedSkillLevel) {
        return false;
      }

      return true;
    }).toList();

    // Sort by date
    filtered.sort((a, b) {
      final dateA = DateTime.parse(a['game_date'] as String);
      final dateB = DateTime.parse(b['game_date'] as String);
      return dateA.compareTo(dateB);
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final totalItems = widget.requests.length + widget.sessions.length + widget.playNowGames.length;

    return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        height: _sheetState == SheetState.minimized
            ? 70
            : (_sheetState == SheetState.expanded
                ? MediaQuery.of(context).size.height * 0.7
                : 360),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    const Color(0xFF1E1E1E).withValues(alpha: 0.95),
                    const Color(0xFF121212).withValues(alpha: 0.95),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.5),
                    blurRadius: 30,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              // Add a top border separately
              child: _isMinimized
                  ? _buildMinimizedView(totalItems)
                  : _buildExpandedCollapsedView(totalItems),
            ),
          ),
        ),
    );
  }

  /// Build minimized view - just drag handle and game count
  Widget _buildMinimizedView(int totalItems) {
    return GestureDetector(
      onTap: () {
        // Tap anywhere to expand
        _toggleExpand();
      },
      onVerticalDragEnd: (details) {
        // Swipe up to expand
        if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
          _toggleExpand();
        }
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.0),
                  Colors.white.withValues(alpha: 0.1),
                  Colors.white.withValues(alpha: 0.0),
                ],
              ),
            ),
          ),
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Game count
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$totalItems ${totalItems == 1 ? 'game' : 'games'} nearby',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Icon(
                  Icons.expand_less,
                  color: Colors.white.withValues(alpha: 0.6),
                  size: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Build expanded/collapsed view - full UI
  Widget _buildExpandedCollapsedView(int totalItems) {
    return Column(
      children: [
        // Draggable header area with gesture detection
        GestureDetector(
          onVerticalDragEnd: (details) {
            // Swipe down
            if (details.primaryVelocity != null && details.primaryVelocity! > 300) {
              if (_sheetState == SheetState.expanded) {
                _toggleExpand(); // Collapse
              } else if (_sheetState == SheetState.collapsed) {
                _minimizeSheet(); // Minimize
              }
            }
            // Swipe up
            else if (details.primaryVelocity != null && details.primaryVelocity! < -300) {
              if (_sheetState == SheetState.collapsed) {
                _toggleExpand(); // Expand
              }
            }
          },
          behavior: HitTestBehavior.opaque,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.1),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              // Drag handle
              Container(
                margin: const EdgeInsets.only(top: 8, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),

              // Header
              Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Open Games',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$totalItems ${totalItems == 1 ? 'game' : 'games'} nearby',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  // Minimize button
                  _buildGlassIconButton(
                    icon: Icons.minimize,
                    onPressed: _minimizeSheet,
                  ),
                  const SizedBox(width: 8),
                  // Expand/collapse button
                  _buildGlassIconButton(
                    icon: _isExpanded ? Icons.expand_more : Icons.expand_less,
                    onPressed: _toggleExpand,
                  ),
                ],
              ),
            ],
          ),
        ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Search bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            height: _isExpanded ? null : 42,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(_isExpanded ? 12 : 21),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
              ),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              onTap: !_isExpanded ? () => _toggleExpand() : null,
              style: TextStyle(
                color: Colors.white,
                fontSize: _isExpanded ? 15 : 14,
              ),
              decoration: InputDecoration(
                hintText: _isExpanded ? 'Search games, players...' : 'Search...',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: _isExpanded ? 15 : 14,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  size: _isExpanded ? 22 : 20,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.clear,
                          size: _isExpanded ? 22 : 20,
                          color: Colors.white.withValues(alpha: 0.6),
                        ),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: _isExpanded ? 16 : 12,
                  vertical: _isExpanded ? 12 : 10,
                ),
                isDense: !_isExpanded,
              ),
            ),
          ),
        ),

        // Filters (only when expanded)
        if (_isExpanded) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                _buildFilterChip(
                  label: _maxDistance == null
                      ? 'Distance'
                      : '${_maxDistance!.toStringAsFixed(0)} km',
                  icon: Icons.near_me,
                  isActive: _maxDistance != null,
                  onTap: () => _showDistanceFilter(),
                ),
                const SizedBox(width: 8),
                _buildFilterChip(
                  label: _selectedSkillLevel == null
                      ? 'Skill Level'
                      : SkillLevel.fromValue(_selectedSkillLevel!).label,
                  icon: Icons.bar_chart,
                  isActive: _selectedSkillLevel != null,
                  onTap: () => _showSkillLevelFilter(),
                ),
                const SizedBox(width: 8),
                if (_maxDistance != null || _selectedSkillLevel != null)
                  _buildFilterChip(
                    label: 'Clear',
                    icon: Icons.clear_all,
                    isActive: false,
                    onTap: () {
                      setState(() {
                        _maxDistance = null;
                        _selectedSkillLevel = null;
                      });
                    },
                  ),
              ],
            ),
          ),
        ],

        const SizedBox(height: 12),

        // Scrollable content
        Expanded(
          child: _isExpanded ? _buildExpandedList() : _buildHorizontalScroll(),
        ),
      ],
    );
  }

  void _toggleExpand() {
    setState(() {
      // Cycle through states: minimized -> collapsed -> expanded -> collapsed
      switch (_sheetState) {
        case SheetState.minimized:
          _sheetState = SheetState.collapsed;
          break;
        case SheetState.collapsed:
          _sheetState = SheetState.expanded;
          _animationController.forward();
          break;
        case SheetState.expanded:
          _sheetState = SheetState.collapsed;
          _animationController.reverse();
          break;
      }
    });
  }

  void _minimizeSheet() {
    setState(() {
      _sheetState = SheetState.minimized;
      _animationController.reverse();
    });
  }

  /// Build glass-style icon button
  Widget _buildGlassIconButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.08),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ),
    );
  }

  /// Build horizontal scrolling row (collapsed state) with lazy loading
  Widget _buildHorizontalScroll() {
    // Combine all items into a single list for efficient horizontal scrolling
    final allItems = <dynamic>[
      ..._sortedRequests,
      ..._sortedPlayNowGames,
      ..._sortedSessions,
    ];

    if (allItems.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Text(
            'No games available',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return SizedBox(
      height: 260, // Fixed height for horizontal scroll
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: allItems.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final item = allItems[index];

          Widget card;
          if (item is PlayerRequestModel) {
            card = _buildRequestCard(item, isHorizontal: true);
          } else if (item is Map<String, dynamic>) {
            card = _buildPlayNowGameCard(item, isHorizontal: true);
          } else if (item is GameSessionModel) {
            card = _buildSessionCard(item, isHorizontal: true);
          } else {
            return const SizedBox.shrink();
          }

          return Padding(
            padding: EdgeInsets.only(
              right: index == allItems.length - 1 ? 0 : 12,
            ),
            child: card,
          );
        },
      ),
    );
  }

  /// Build vertical list (expanded state)
  Widget _buildExpandedList() {
    final hasAnyGames = _sortedRequests.isNotEmpty ||
        _sortedPlayNowGames.isNotEmpty ||
        _sortedSessions.isNotEmpty;

    if (!hasAnyGames) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sports_tennis,
                size: 64,
                color: Colors.white.withValues(alpha: 0.3),
              ),
              const SizedBox(height: 16),
              Text(
                'No games available',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.6),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Check back later or create a new game request',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        // Player requests section
        if (_sortedRequests.isNotEmpty) ...[
          Text(
            'Player Requests',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._sortedRequests.map((request) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildRequestCard(request, isHorizontal: false),
              )),
        ],

        // Organized Games section
        if (_sortedPlayNowGames.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Organized Games',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._sortedPlayNowGames.map((game) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildPlayNowGameCard(game, isHorizontal: false),
              )),
        ],

        // Game sessions section
        if (_sortedSessions.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(
            'Game Sessions',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.9),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ..._sortedSessions.map((session) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildSessionCard(session, isHorizontal: false),
              )),
        ],

        const SizedBox(height: 20),
      ],
    );
  }

  /// Calculate distance to request/session
  String? _getDistance(double? lat, double? lng) {
    if (widget.userLocation == null || lat == null || lng == null) return null;

    final distance = LocationService.calculateDistance(
      startLatitude: widget.userLocation!.latitude,
      startLongitude: widget.userLocation!.longitude,
      endLatitude: lat,
      endLongitude: lng,
    );

    return LocationService.formatDistance(distance);
  }

  /// Build request card with glass UI
  Widget _buildRequestCard(PlayerRequestModel request,
      {required bool isHorizontal}) {
    final distance = _getDistance(request.latitude, request.longitude);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => RequestInfoSheet(
            request: request,
            distanceKm: distance != null
                ? double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), ''))
                : null,
            currentUserId: widget.currentUserId,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.orange.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: isHorizontal ? 260 : double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.orange.withValues(alpha: 0.15),
                    Colors.orange.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B35), Color(0xFFF7931E)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.orange.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.group_add,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Need ${request.playersNeeded} ${request.playersNeeded == 1 ? 'player' : 'players'}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              request.sportType.toUpperCase(),
                              style: const TextStyle(
                                color: Color(0xFFFF6B35),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (distance != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            distance,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (!isHorizontal && request.description != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      request.description!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          dateTimeFormat('relative', request.scheduledTime),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build session card with glass UI
  Widget _buildSessionCard(GameSessionModel session,
      {required bool isHorizontal}) {
    final distance = _getDistance(session.latitude, session.longitude);

    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => SessionInfoSheet(
            session: session,
            distanceKm: distance != null
                ? double.tryParse(distance.replaceAll(RegExp(r'[^0-9.]'), ''))
                : null,
            currentUserId: widget.currentUserId,
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.purple.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: isHorizontal ? 260 : double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.purple.withValues(alpha: 0.15),
                    Colors.purple.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF9C27B0), Color(0xFF7B1FA2)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.purple.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.sports,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${session.sessionType.toUpperCase()} Session',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${session.joinedPlayersCount}/${session.maxPlayers} Players',
                              style: const TextStyle(
                                color: Color(0xFF9C27B0),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (distance != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            distance,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.9),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (!isHorizontal && session.notes != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      session.notes!,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontSize: 13,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.schedule,
                            size: 14,
                            color: Colors.white.withValues(alpha: 0.5)),
                        const SizedBox(width: 4),
                        Text(
                          dateTimeFormat('relative', session.scheduledTime),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Build playnow game card using the standard GameCard widget
  Widget _buildPlayNowGameCard(Map<String, dynamic> game,
      {required bool isHorizontal}) {
    // Convert Map to Game model
    final gameModel = Game.fromJson(game);

    // Use the standard GameCard widget from PlayNow
    return isHorizontal
        ? SizedBox(
            width: 280,
            child: GameCard(game: gameModel),
          )
        : GameCard(game: gameModel);
  }

  /// Build filter chip with glass UI
  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isActive
                ? [
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3),
                    FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                  ]
                : [
                    Colors.white.withValues(alpha: 0.15),
                    Colors.white.withValues(alpha: 0.08),
                  ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive
                ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isActive
                  ? FlutterFlowTheme.of(context).primary
                  : Colors.white.withValues(alpha: 0.7),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? FlutterFlowTheme.of(context).primary
                    : Colors.white.withValues(alpha: 0.9),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Show distance filter bottom sheet
  void _showDistanceFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E1E1E).withValues(alpha: 0.95),
              const Color(0xFF121212).withValues(alpha: 0.95),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Distance',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...[ 5.0, 10.0, 25.0, 50.0].map((distance) {
              return ListTile(
                title: Text(
                  'Within ${distance.toStringAsFixed(0)} km',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: _maxDistance == distance
                    ? Icon(Icons.check,
                        color: FlutterFlowTheme.of(context).primary)
                    : null,
                onTap: () {
                  setState(() {
                    _maxDistance = distance;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Show skill level filter bottom sheet
  void _showSkillLevelFilter() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color(0xFF1E1E1E).withValues(alpha: 0.95),
              const Color(0xFF121212).withValues(alpha: 0.95),
            ],
          ),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter by Skill Level',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ...SkillLevel.values.map((skillLevel) {
              return ListTile(
                leading: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _hexToColor(skillLevel.hexColor),
                    shape: BoxShape.circle,
                  ),
                ),
                title: Text(
                  skillLevel.label,
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: _selectedSkillLevel == skillLevel.value
                    ? Icon(Icons.check,
                        color: FlutterFlowTheme.of(context).primary)
                    : null,
                onTap: () {
                  setState(() {
                    _selectedSkillLevel = skillLevel.value;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  /// Convert hex color string to Color
  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
