import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '../models/skill_level.dart';
import '../services/quick_match_service.dart';
import '../services/location_service.dart';
import '../services/map_service.dart';

/// Bottom sheet for Quick Match feature - swipeable player recommendations
class QuickMatchSheet extends StatefulWidget {
  final String sportType;
  final double userLatitude;
  final double userLongitude;
  final int? userSkillLevel;

  const QuickMatchSheet({
    super.key,
    required this.sportType,
    required this.userLatitude,
    required this.userLongitude,
    this.userSkillLevel,
  });

  @override
  State<QuickMatchSheet> createState() => _QuickMatchSheetState();
}

class _QuickMatchSheetState extends State<QuickMatchSheet> {
  List<MatchRecommendation> _recommendations = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  bool _isConnecting = false;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadMatches() async {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return;

    setState(() => _isLoading = true);

    final matches = await QuickMatchService.getRecommendedMatches(
      userId: currentUserId,
      sportType: widget.sportType,
      userLatitude: widget.userLatitude,
      userLongitude: widget.userLongitude,
      userSkillLevel: widget.userSkillLevel,
      maxDistanceKm: 10.0,
      maxResults: 10,
    );

    setState(() {
      _recommendations = matches;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Match',
                      style:
                          FlutterFlowTheme.of(context).headlineSmall.override(
                                fontFamily: 'Outfit',
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Find your perfect ${widget.sportType} partner',
                      style: FlutterFlowTheme.of(context).bodySmall.override(
                            fontFamily: 'Readex Pro',
                            color: Colors.grey,
                          ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          // Content
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _recommendations.isEmpty
                    ? _buildEmptyState()
                    : _buildMatchCards(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No Matches Found',
              style: FlutterFlowTheme.of(context).titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Try adjusting your search radius or check back later',
              textAlign: TextAlign.center,
              style: FlutterFlowTheme.of(context).bodyMedium.override(
                    fontFamily: 'Readex Pro',
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCards() {
    final currentMatch = _recommendations[_currentIndex];

    return Column(
      children: [
        // Match counter
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_currentIndex + 1} of ${_recommendations.length}',
                  style: TextStyle(
                    color: FlutterFlowTheme.of(context).primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),

        // Match card
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() => _currentIndex = index);
              },
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                return _buildMatchCard(_recommendations[index]);
              },
            ),
          ),
        ),

        // Action buttons
        Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Skip button
              _buildActionButton(
                icon: Icons.close,
                color: Colors.red,
                label: 'Skip',
                onPressed: _isConnecting ? null : _handleSkip,
              ),

              // Maybe Later button
              _buildActionButton(
                icon: Icons.watch_later_outlined,
                color: Colors.orange,
                label: 'Later',
                onPressed: _isConnecting ? null : _handleMaybeLater,
              ),

              // Connect button
              _buildActionButton(
                icon: Icons.check,
                color: Colors.green,
                label: 'Connect',
                onPressed: _isConnecting ? null : _handleConnect,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMatchCard(MatchRecommendation match) {
    final skillLevel = match.player.skillLevel != null
        ? SkillLevel.fromValue(match.player.skillLevel!)
        : null;

    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Profile picture section
          Expanded(
            flex: 3,
            child: ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: match.player.userProfilePicture != null
                  ? CachedNetworkImage(
                      imageUrl: match.player.userProfilePicture!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[300],
                        child: const Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.person, size: 80),
                      ),
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.person, size: 80),
                    ),
            ),
          ),

          // Info section
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Name and skill level
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        match.player.userName ?? 'Unknown Player',
                        style: FlutterFlowTheme.of(context).headlineSmall,
                      ),
                      const SizedBox(height: 8),
                      if (skillLevel != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: _hexToColor(skillLevel.hexColor)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _hexToColor(skillLevel.hexColor),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            skillLevel.label,
                            style: TextStyle(
                              color: _hexToColor(skillLevel.hexColor),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Compatibility info
                  Column(
                    children: [
                      // Distance
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8),
                          Text(
                            LocationService.formatDistance(match.distanceKm),
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  fontFamily: 'Readex Pro',
                                  color: Colors.grey[700],
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Compatibility score
                      Row(
                        children: [
                          Icon(
                            Icons.verified,
                            size: 18,
                            color: FlutterFlowTheme.of(context).primary,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${(match.compatibilityScore * 100).toInt()}% Match',
                            style: TextStyle(
                              color: FlutterFlowTheme.of(context).primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Compatibility reason
                      Text(
                        match.compatibilityReason,
                        style: FlutterFlowTheme.of(context).bodySmall.override(
                              fontFamily: 'Readex Pro',
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: FlutterFlowTheme.of(context).bodySmall.override(
                fontFamily: 'Readex Pro',
                color: Colors.grey[700],
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Future<void> _handleSkip() async {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return;

    final currentMatch = _recommendations[_currentIndex];

    // Record the skip action
    await QuickMatchService.recordMatchInteraction(
      userId: currentUserId,
      matchedUserId: currentMatch.player.userId,
      sportType: widget.sportType,
      action: 'skip',
      compatibilityScore: currentMatch.compatibilityScore,
    );

    _moveToNext();
  }

  Future<void> _handleMaybeLater() async {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return;

    final currentMatch = _recommendations[_currentIndex];

    // Record the maybe later action
    await QuickMatchService.recordMatchInteraction(
      userId: currentUserId,
      matchedUserId: currentMatch.player.userId,
      sportType: widget.sportType,
      action: 'later',
      compatibilityScore: currentMatch.compatibilityScore,
    );

    _moveToNext();
  }

  Future<void> _handleConnect() async {
    final currentUserId = currentUserUid;
    if (currentUserId == null) return;

    final currentMatch = _recommendations[_currentIndex];

    setState(() => _isConnecting = true);

    // Record the connect action
    await QuickMatchService.recordMatchInteraction(
      userId: currentUserId,
      matchedUserId: currentMatch.player.userId,
      sportType: widget.sportType,
      action: 'connect',
      compatibilityScore: currentMatch.compatibilityScore,
    );

    // Create or get chat room
    final roomId = await MapService.createOrGetChatRoom(
      userId1: currentUserId,
      userId2: currentMatch.player.userId,
    );

    if (mounted) {
      setState(() => _isConnecting = false);

      if (roomId != null) {
        Navigator.pop(context);
        context.pushNamed(
          'chat_room',
          queryParameters: {'roomId': roomId},
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to create chat. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
        _moveToNext();
      }
    }
  }

  void _moveToNext() {
    if (_currentIndex < _recommendations.length - 1) {
      _pageController.animateToPage(
        _currentIndex + 1,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // No more matches
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No more matches! Check back later.'),
          ),
        );
        Navigator.pop(context);
      }
    }
  }

  Color _hexToColor(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
