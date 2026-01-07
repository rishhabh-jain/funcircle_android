import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '/chatsnew/chatsnew_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/playnow/widgets/create_game_sheet.dart';
import '/playnow/widgets/game_card.dart';
import '/playnow/models/game_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import 'single_venue_new_model.dart';
export 'single_venue_new_model.dart';

class SingleVenueNewWidget extends StatefulWidget {
  const SingleVenueNewWidget({
    super.key,
    int? venueid,
  }) : this.venueid = venueid ?? 9;

  final int venueid;

  static String routeName = 'SingleVenueNew';
  static String routePath = '/singleVenueNew';

  @override
  State<SingleVenueNewWidget> createState() => _SingleVenueNewWidgetState();
}

class _SingleVenueNewWidgetState extends State<SingleVenueNewWidget> {
  late SingleVenueNewModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SingleVenueNewModel());
    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<List<ChatRoomsRow>> _fetchVenueRooms() async {
    try {
      final response = await SupaFlow.client
          .schema('chat')
          .from('rooms')
          .select('*')
          .eq('venue_id', widget.venueid)
          .eq('is_active', true)
          .order('name');

      return (response as List).map((data) => ChatRoomsRow(data)).toList();
    } catch (e) {
      print('Error fetching venue rooms: $e');
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> _fetchVenueGames() async {
    try {
      final today = DateTime.now();
      final response = await SupaFlow.client
          .schema('playnow')
          .from('games')
          .select('*')
          .eq('venue_id', widget.venueid)
          .gte('game_date', today.toIso8601String().split('T')[0])
          .inFilter('status', ['open', 'in_progress'])
          .order('game_date')
          .order('start_time')
          .limit(10);

      final gamesList = List<Map<String, dynamic>>.from(response as List);

      // Fetch creator details in batch for all games
      final creatorIds = gamesList
          .map((g) => g['created_by'] as String?)
          .where((id) => id != null)
          .toSet()
          .toList();

      // Fetch all creators at once
      Map<String, Map<String, dynamic>> creatorsMap = {};
      if (creatorIds.isNotEmpty) {
        try {
          final creatorsResponse = await SupaFlow.client
              .from('users')
              .select('user_id, first_name, profile_picture')
              .inFilter('user_id', creatorIds);

          for (final creator in (creatorsResponse as List)) {
            creatorsMap[creator['user_id'] as String] = creator;
          }
        } catch (e) {
          print('Error fetching creators: $e');
        }
      }

      // Get venue name (since we're on the venue page, fetch it once)
      String? venueName;
      try {
        final venueResponse = await SupaFlow.client
            .from('venues')
            .select('venue_name')
            .eq('id', widget.venueid)
            .maybeSingle();

        venueName = venueResponse?['venue_name'] as String?;
      } catch (e) {
        print('Error fetching venue name: $e');
      }

      // Combine game data with creator and venue info
      return gamesList.map((json) {
        final creatorId = json['created_by'] as String?;

        // Get creator data (format as expected by Game.fromJson)
        Map<String, dynamic>? creatorData;
        if (creatorId != null && creatorsMap.containsKey(creatorId)) {
          creatorData = {
            'first_name': creatorsMap[creatorId]!['first_name'],
            'profile_picture': creatorsMap[creatorId]!['profile_picture'],
          };
        }

        return {
          ...json,
          'creator': creatorData, // Nested object format expected by Game.fromJson
          'venue_name': venueName, // Add venue name
        };
      }).toList();
    } catch (e) {
      print('Error fetching venue games: $e');
      return [];
    }
  }

  String _getRoomLevelFromName(String? roomName) {
    if (roomName == null) return '';
    final lower = roomName.toLowerCase();
    if (lower.contains('beginner-intermediate') ||
        lower.contains('beginner intermediate')) {
      return 'Beginner-Intermediate';
    } else if (lower.contains('upper-intermediate') ||
        lower.contains('upper intermediate')) {
      return 'Upper Intermediate';
    } else if (lower.contains('intermediate')) {
      return 'Intermediate';
    } else if (lower.contains('beginner')) {
      return 'Beginner';
    }
    return '';
  }

  Future<void> _joinRoom(String roomId) async {
    try {
      final existingMember = await SupaFlow.client
          .schema('chat')
          .from('room_members')
          .select()
          .eq('room_id', roomId)
          .eq('user_id', currentUserUid)
          .maybeSingle();

      if (existingMember != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are already a member of this group!'),
            backgroundColor: FlutterFlowTheme.of(context).warning,
          ),
        );
        await Future.delayed(Duration(milliseconds: 500));
        context.pushNamed(ChatsnewWidget.routeName);
        return;
      }

      await SupaFlow.client.schema('chat').from('room_members').insert({
        'room_id': roomId,
        'user_id': currentUserUid,
        'role': 'member',
        'joined_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Successfully joined the group!'),
          backgroundColor: FlutterFlowTheme.of(context).success,
        ),
      );

      await Future.delayed(Duration(milliseconds: 800));
      context.pushNamed(ChatsnewWidget.routeName);
    } catch (e) {
      print('Error joining room: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to join group. Please try again.'),
          backgroundColor: FlutterFlowTheme.of(context).error,
        ),
      );
    }
  }

  List<Map<String, String>> _getSportsFromType(String? sportType) {
    final sports = <Map<String, String>>[];

    if (sportType == null) return sports;

    final lowerType = sportType.toLowerCase();

    if (lowerType == 'both') {
      sports.add({'emoji': '🏸', 'name': 'Badminton'});
      sports.add({'emoji': '🎾', 'name': 'Pickleball'});
    } else if (lowerType.contains('badminton')) {
      sports.add({'emoji': '🏸', 'name': 'Badminton'});
    } else if (lowerType.contains('pickleball')) {
      sports.add({'emoji': '🎾', 'name': 'Pickleball'});
    } else if (lowerType.contains('padel')) {
      sports.add({'emoji': '🏓', 'name': 'Padel'});
    }

    return sports;
  }

  Future<void> _launchMaps(String mapsLink) async {
    final uri = Uri.parse(mapsLink);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<VenuesRow>>(
      future: VenuesTable().querySingleRow(
        queryFn: (q) => q.eqOrNull('id', widget.venueid),
      ),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Center(
              child: SizedBox(
                width: 50.0,
                height: 50.0,
                child: SpinKitRing(
                  color: Colors.orange,
                  size: 50.0,
                ),
              ),
            ),
          );
        }

        final venueData = snapshot.data!;
        if (venueData.isEmpty) {
          return Scaffold(
            backgroundColor: const Color(0xFF121212),
            body: Center(
              child: Text(
                'Venue not found',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
        }

        final venue = venueData.first;
        final images = venue.images;
        // Validate venue image URL
        String? venueImage;
        if (images.isNotEmpty) {
          final rawUrl = images.first;
          if (rawUrl.startsWith('http') || rawUrl.contains('.jpg') || rawUrl.contains('.png') || rawUrl.contains('.jpeg')) {
            venueImage = rawUrl;
          }
        }

        return Scaffold(
          key: scaffoldKey,
          backgroundColor: const Color(0xFF121212),
          body: AnnotatedRegion<SystemUiOverlayStyle>(
            value: SystemUiOverlayStyle(
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

                // Main Content
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Venue Header with Image
                      _buildVenueHeader(venue, venueImage),

                      const SizedBox(height: 20),

                      // Featured Badge
                      if (venue.isFeatured == true)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildFeaturedBadge(),
                        ),

                      if (venue.isFeatured == true) const SizedBox(height: 20),

                      // Sport Types Available
                      _buildSportTypesSection(venue),

                      const SizedBox(height: 16),

                      // Create Game Button
                      _buildCreateGameButton(venue),

                      const SizedBox(height: 16),

                      // Active Games
                      _buildActiveGamesSection(),

                      const SizedBox(height: 16),

                      // Stats
                      _buildStatsRow(venue),

                      const SizedBox(height: 16),

                      // Description
                      if (venue.description != null &&
                          venue.description!.isNotEmpty)
                        _buildDescriptionSection(venue.description!),

                      const SizedBox(height: 16),

                      // Location Info
                      _buildLocationSection(venue),

                      const SizedBox(height: 16),

                      // Amenities
                      if (venue.amenities.isNotEmpty)
                        _buildAmenitiesSection(venue.amenities),

                      const SizedBox(height: 16),

                      // Chat Rooms
                      _buildChatRoomsSection(),

                      const SizedBox(height: 140),
                    ],
                  ),
                ),

                // Back Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 8,
                  child: _buildBackButton(),
                ),

                // Share Button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  right: 8,
                  child: _buildShareButton(venue),
                ),

                // Sticky Action Buttons at Bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildStickyActionButtons(venue),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBackButton() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 22),
            onPressed: () => context.safePop(),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton(VenuesRow venue) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.2),
                Colors.white.withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
          ),
          child: IconButton(
            icon:
                const Icon(Icons.share_rounded, color: Colors.white, size: 22),
            onPressed: () => _shareVenue(venue),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Future<void> _shareVenue(VenuesRow venue) async {
    try {
      final venueName = venue.venueName ?? 'Venue';
      final location = venue.location ?? '';
      final price = venue.pricePerHour != null
          ? '\nPrice: ₹${venue.pricePerHour!.toStringAsFixed(0)} onwards'
          : '';
      final description =
          venue.description != null && venue.description!.isNotEmpty
              ? '\n\n${venue.description}'
              : '';

      // Create deep link URL
      final deepLink = 'funcircle://venue/${venue.id}';

      // Create shareable text
      final shareText = '''
Check out this venue on FunCircle!

🏟️ $venueName
📍 $location$price$description

🔗 Tap to view directly: $deepLink

Download FunCircle app to book your slot!
''';

      await Share.share(
        shareText,
        subject: 'Check out $venueName on FunCircle',
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Venue shared successfully!'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    } catch (e) {
      print('Error sharing venue: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Unable to share at this time'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        );
      }
    }
  }

  Widget _buildVenueHeader(VenuesRow venue, String? venueImage) {
    // Get all images from venue
    final List<String> images = venue.images.isNotEmpty
        ? venue.images
        : (venueImage != null ? [venueImage] : []);

    return SizedBox(
      width: double.infinity,
      height: 420,
      child: Stack(
        children: [
          // Image gallery with PageView
          if (images.isNotEmpty)
            Positioned.fill(
              child: PageView.builder(
                controller: _model.imagePageController,
                itemCount: images.length,
                onPageChanged: (index) {
                  setState(() {
                    _model.currentImageIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: images[index],
                    fit: BoxFit.cover,
                    fadeInDuration: Duration(milliseconds: 300),
                    placeholder: (context, url) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF6B35),
                            Color(0xFFF7931E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFFFF6B35),
                            Color(0xFFF7931E),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.white.withValues(alpha: 0.5),
                          size: 48,
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          else
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFF7931E),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),

          // Pattern overlay - subtle (ignore pointer to allow swiping)
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _HeaderPatternPainter(),
              ),
            ),
          ),

          // Gradient overlay - more dramatic (ignore pointer to allow swiping)
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),
          ),

          // Content at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 28,
                top: 20,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Page indicators (only show if multiple images)
                  if (images.length > 1)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          images.length,
                          (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _model.currentImageIndex == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _model.currentImageIndex == index
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.4),
                              borderRadius: BorderRadius.circular(4),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                  // Venue Name
                  Text(
                    venue.venueName ?? 'Venue',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.5),
                          blurRadius: 12,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Location with icon
                  if (venue.location != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.location_on_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              venue.location!,
                              style: TextStyle(
                                fontFamily: 'Readex Pro',
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
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

  Widget _buildFeaturedBadge() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFD700).withValues(alpha: 0.25),
                Color(0xFFFFD700).withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Color(0xFFFFD700).withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Color(0xFFFFD700), size: 18),
              const SizedBox(width: 6),
              Text(
                'Featured',
                style: TextStyle(
                  color: Color(0xFFFFD700),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSportTypesSection(VenuesRow venue) {
    final sports = _getSportsFromType(venue.sportType);

    if (sports.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sports Available',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: sports
                .map((sport) => _buildSportBadge(
                      sport['emoji']!,
                      sport['name']!,
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSportBadge(String emoji, String name) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFF4CAF50).withValues(alpha: 0.2),
                const Color(0xFF4CAF50).withValues(alpha: 0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                emoji,
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(width: 10),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsRow(VenuesRow venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              '${venue.courtCount ?? 1}',
              venue.courtCount == 1 ? 'Court' : 'Courts',
              Icons.sports_tennis_rounded,
              const Color(0xFF2196F3),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              venue.pricePerHour != null
                  ? '₹${venue.pricePerHour!.toStringAsFixed(0)}'
                  : 'N/A',
              'starts at',
              Icons.currency_rupee_rounded,
              const Color(0xFFFF6B35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String value, String label, IconData icon, Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.15),
                Colors.white.withValues(alpha: 0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
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
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.7),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDescriptionSection(String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.info_outline_rounded,
                        size: 20,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'About Venue',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 15,
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection(VenuesRow venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                if (venue.location != null)
                  _buildInfoRow(
                      Icons.location_on_rounded, 'Address', venue.location!),
                if (venue.city != null)
                  _buildInfoRow(
                      Icons.location_city_rounded, 'City', venue.city!),
                if (venue.state != null)
                  _buildInfoRow(Icons.map_rounded, 'State', venue.state!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 20,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    color: Colors.white.withValues(alpha: 0.6),
                    fontSize: 11,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Readex Pro',
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(List<dynamic> amenities) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Amenities',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: amenities
                .map((amenity) => _buildAmenityChip(amenity.toString()))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityChip(String amenity) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withValues(alpha: 0.12),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _getAmenityIcon(amenity),
                color: Colors.orange,
                size: 16,
              ),
              const SizedBox(width: 6),
              Text(
                amenity,
                style: TextStyle(
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final lower = amenity.toLowerCase();
    if (lower.contains('parking')) return Icons.local_parking_rounded;
    if (lower.contains('water')) return Icons.water_drop_rounded;
    if (lower.contains('locker')) return Icons.lock_rounded;
    if (lower.contains('shower')) return Icons.shower_rounded;
    if (lower.contains('wifi')) return Icons.wifi_rounded;
    if (lower.contains('cafe') || lower.contains('food'))
      return Icons.restaurant_rounded;
    if (lower.contains('ac') || lower.contains('air'))
      return Icons.ac_unit_rounded;
    return Icons.check_circle_rounded;
  }

  Widget _buildStickyActionButtons(VenuesRow venue) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            const Color(0xFF121212).withValues(alpha: 0.8),
            const Color(0xFF121212),
          ],
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: EdgeInsets.only(
              left: 16,
              right: 16,
              top: 16,
              bottom: MediaQuery.of(context).padding.bottom + 16,
            ),
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.white.withValues(alpha: 0.1),
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                if (venue.mapsLink != null && venue.mapsLink!.isNotEmpty)
                  Expanded(
                    child: _buildActionButton(
                      'Open Maps',
                      Icons.map_rounded,
                      const Color(0xFF4285F4),
                      () => _launchMaps(venue.mapsLink!),
                    ),
                  ),
                if (venue.mapsLink != null && venue.mapsLink!.isNotEmpty)
                  const SizedBox(width: 12),
                Expanded(
                  flex: venue.mapsLink != null && venue.mapsLink!.isNotEmpty
                      ? 1
                      : 2,
                  child: _buildActionButton(
                    'Book Now',
                    Icons.calendar_today_rounded,
                    const Color(0xFFFF6B35),
                    () {
                      // TODO: Navigate to booking page
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Booking feature coming soon!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                color,
                color.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                blurRadius: 16,
                color: color.withValues(alpha: 0.4),
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        fontFamily: 'Readex Pro',
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCreateGameButton(VenuesRow venue) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextButton(
        onPressed: () async {
          // Determine sport type from venue
          String? sportType;
          if (venue.sportType != null) {
            final lowerType = venue.sportType!.toLowerCase();
            if (lowerType.contains('badminton')) {
              sportType = 'badminton';
            } else if (lowerType.contains('pickleball')) {
              sportType = 'pickleball';
            }
          }

          // Show create game sheet with venue pre-selected
          await showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (context) => CreateGameSheet(
              initialVenueId: venue.id,
              initialSportType: sportType,
              onGameCreated: () {
                safeSetState(() {});
              },
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          minimumSize: const Size(double.infinity, 48),
          backgroundColor: Colors.white.withValues(alpha: 0.1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1.5,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_circle_outline,
              size: 20,
              color: Colors.white.withValues(alpha: 0.9),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Create Game at ${venue.venueName ?? 'this venue'}',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveGamesSection() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _fetchVenueGames(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final games = snapshot.data!;

        if (games.isEmpty) {
          return const SizedBox.shrink();
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      Icons.sports_tennis_rounded,
                      size: 20,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Active Games',
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${games.length} ${games.length == 1 ? 'game' : 'games'}',
                    style: TextStyle(
                      fontFamily: 'Readex Pro',
                      fontSize: 13,
                      color: Colors.white.withValues(alpha: 0.6),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 250,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: games.length,
                itemBuilder: (context, index) {
                  final game = games[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      right: index < games.length - 1 ? 12 : 0,
                    ),
                    child: _buildGameCard(game),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildGameCard(Map<String, dynamic> game) {
    // Convert Map to Game model
    final gameModel = Game.fromJson(game);

    // Use the standard GameCard widget from PlayNow
    return SizedBox(
      width: 260,
      child: GameCard(game: gameModel),
    );
  }

  Widget _buildChatRoomsSection() {
    return FutureBuilder<List<ChatRoomsRow>>(
      future: _fetchVenueRooms(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Center(
              child: CircularProgressIndicator(color: Colors.orange),
            ),
          );
        }

        final rooms = snapshot.data!;

        if (rooms.isEmpty) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Community Rooms',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              ...rooms.map((room) => _buildRoomCard(room)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildRoomCard(ChatRoomsRow room) {
    final level = _getRoomLevelFromName(room.name);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.white.withValues(alpha: 0.15),
                  Colors.white.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.2),
                width: 1.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () => _joinRoom(room.id),
                borderRadius: BorderRadius.circular(20),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFFFF6B35),
                              Color(0xFFF7931E),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.groups_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              room.name ?? 'Room',
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            if (level.isNotEmpty)
                              Text(
                                level,
                                style: TextStyle(
                                  fontFamily: 'Readex Pro',
                                  fontSize: 13,
                                  color: Colors.orange,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white.withValues(alpha: 0.5),
                        size: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Background pattern painter
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
    for (int i = 0; i < 10; i++) {
      canvas.drawLine(
        Offset(0, size.height * i * 0.1),
        Offset(size.width * 0.3, size.height * i * 0.1),
        paint,
      );
    }

    // Add subtle orange gradient overlay
    final gradientPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.orange.withValues(alpha: 0.03),
          Colors.transparent,
          Colors.orange.withValues(alpha: 0.02),
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

// Custom painter for header pattern
class _HeaderPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // Draw circles
    for (double i = -size.width; i < size.width * 2; i += 100) {
      for (double j = -size.height; j < size.height * 2; j += 100) {
        canvas.drawCircle(Offset(i, j), 40, paint);
      }
    }

    // Draw dots
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..style = PaintingStyle.fill;

    for (double i = 0; i < size.width; i += 30) {
      for (double j = 0; j < size.height; j += 30) {
        canvas.drawCircle(Offset(i, j), 2, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
