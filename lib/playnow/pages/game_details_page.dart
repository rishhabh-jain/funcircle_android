import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/auth/firebase_auth/auth_util.dart';
import '/backend/supabase/supabase.dart';
import '../models/game_model.dart';
import '../services/game_service.dart';
import '../services/after_game_service.dart';
import '../services/game_payment_service.dart';
import '../widgets/game_payment_sheet.dart';
import '../widgets/edit_game_dialog.dart';
import 'game_details_model.dart';
import 'after_game_dialogs.dart';
export 'game_details_model.dart';

/// Full-screen game details page with venue-inspired design
class GameDetailsPage extends StatefulWidget {
  final String gameId;

  const GameDetailsPage({
    super.key,
    required this.gameId,
  });

  @override
  State<GameDetailsPage> createState() => _GameDetailsPageState();
}

class _GameDetailsPageState extends State<GameDetailsPage> {
  late GameDetailsModel _model;

  @override
  void initState() {
    super.initState();
    _model = GameDetailsModel();
    _loadGameDetails();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> _loadGameDetails() async {
    setState(() => _model.isLoading = true);

    try {
      // 1. Load game data
      final gameData = await SupaFlow.client
          .schema('playnow')
          .from('games')
          .select()
          .eq('id', widget.gameId)
          .single();

      if (mounted) {
        setState(() {
          _model.game = Game.fromJson(gameData);
        });
      }

      // 2. Load organizer name
      if (_model.game != null) {
        try {
          final userData = await SupaFlow.client
              .from('users')
              .select('first_name')
              .eq('user_id', _model.game!.createdBy)
              .single();

          if (mounted) {
            setState(() {
              _model.organizerName = userData['first_name'] as String?;
            });
          }
        } catch (e) {
          print('Error loading organizer name: $e');
        }

        // 3. Load venue details if venue is set
        if (_model.game!.venueId != null) {
          try {
            final venueData = await SupaFlow.client
                .from('venues')
                .select('venue_name, location, lat, lng')
                .eq('id', _model.game!.venueId!)
                .single();

            if (mounted) {
              setState(() {
                _model.venueName = venueData['venue_name'] as String?;
                _model.venueAddress = venueData['location'] as String?;
                // Handle numeric type conversion for lat/lng
                final lat = venueData['lat'];
                final lng = venueData['lng'];
                _model.venueLatitude =
                    lat != null ? (lat is num ? lat.toDouble() : null) : null;
                _model.venueLongitude =
                    lng != null ? (lng is num ? lng.toDouble() : null) : null;
              });
            }
          } catch (e) {
            print('Error loading venue details: $e');
          }
        }
      }

      await _loadParticipants();
    } catch (e) {
      print('Error loading game details: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load game details'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _model.isLoading = false);
      }
    }
  }

  Future<void> _loadParticipants() async {
    if (_model.game == null) return;

    try {
      // First get the game participants
      final participantResults = await SupaFlow.client
          .schema('playnow')
          .from('game_participants')
          .select('*')
          .eq('game_id', widget.gameId)
          .order('joined_at', ascending: true) as List;

      if (participantResults.isEmpty) {
        if (mounted) {
          setState(() {
            _model.participants = [];
          });
        }
        return;
      }

      // Get all user IDs
      final userIds =
          participantResults.map((p) => p['user_id'] as String).toList();

      // Fetch user data from public schema
      final userResults = await SupaFlow.client
          .from('users')
          .select(
              'user_id, first_name, profile_picture, skill_level_badminton, skill_level_pickleball')
          .inFilter('user_id', userIds) as List;

      // Create a map of user data
      final userMap = {
        for (var user in userResults)
          user['user_id'] as String: user as Map<String, dynamic>
      };

      // Combine participant and user data
      final combinedResults = participantResults.map((participant) {
        final participantData = participant as Map<String, dynamic>;
        final userId = participantData['user_id'] as String;
        final userData = userMap[userId];

        return {
          ...participantData,
          'user': userData,
        };
      }).toList();

      if (mounted) {
        setState(() {
          _model.participants = combinedResults
              .map((json) => GameParticipant.fromJson(json))
              .toList();
        });
      }
    } catch (e) {
      print('Error loading participants: $e');
    }
  }

  /// Calculate the height of the bottom button area
  double _getBottomButtonHeight() {
    final game = _model.game;
    if (game == null) return 88;

    final hasJoined = _model.participants.any((p) => p.userId == currentUserUid);

    // Calculate based on what buttons will be shown
    double height = 72; // Base height for one button

    // Add height for chat button if applicable
    if (hasJoined && game.chatRoomId != null) {
      height += 68; // Chat button height + spacing
    }

    // Add bottom padding
    height += MediaQuery.of(context).padding.bottom;

    return height;
  }

  @override
  Widget build(BuildContext context) {
    if (_model.isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: CircularProgressIndicator(
              color: FlutterFlowTheme.of(context).primary),
        ),
      );
    }

    if (_model.game == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Text(
            'Game not found',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      extendBodyBehindAppBar: true,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF121212),
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.dark,
        ),
        child: Stack(
          children: [
            // Solid background for status bar area
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).padding.top,
              child: Container(
                color: const Color(0xFF121212),
              ),
            ),

            // Background pattern
            Positioned.fill(
              child: CustomPaint(
                painter: _BackgroundPatternPainter(),
              ),
            ),

            // Main Content with SafeArea
            SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top spacing for back/share buttons
                    const SizedBox(height: 60),

                    // Single unified game info block
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: _buildUnifiedGameBlock(),
                    ),

                    const SizedBox(height: 16),

                    // After Game Section (only for completed games)
                    if (_model.game!.status == 'completed')
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: _buildAfterGameSection(),
                      ),

                    if (_model.game!.status == 'completed')
                      const SizedBox(height: 16),

                    // Bottom padding for sticky buttons (dynamically calculated)
                    SizedBox(height: _getBottomButtonHeight() + 20),
                  ],
                ),
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
              child: _buildShareButton(),
            ),

            // Sticky Action Buttons
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStickyActionButtons(),
            ),
          ],
        ),
      ),
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
            onPressed: () => Navigator.pop(context),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildShareButton() {
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
            onPressed: _shareGame,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildUnifiedGameBlock() {
    final game = _model.game!;
    final isCreator = game.createdBy == currentUserUid;
    final hasJoined = _model.participants.any((p) => p.userId == currentUserUid);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
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
          // Header: Sport badge and player count
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getSportColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getSportColor().withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getSportIcon(), color: _getSportColor(), size: 14),
                    const SizedBox(width: 5),
                    Text(
                      game.sportType == 'badminton' ? 'Badminton' : 'Pickleball',
                      style: TextStyle(
                        color: _getSportColor(),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (isCreator) ...[
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: FlutterFlowTheme.of(context).primary.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    'Your Game',
                    style: TextStyle(
                      color: FlutterFlowTheme.of(context).primary,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              // Edit and Cancel buttons for creator
              if (isCreator && game.status != 'completed' && game.status != 'cancelled') ...[
                // Edit button
                GestureDetector(
                  onTap: _showEditGameDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: Colors.blue,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                // Cancel button
                GestureDetector(
                  onTap: _showCancelGameDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.close_rounded,
                      color: Colors.red,
                      size: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 6),
              ],
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: _getStatusColor().withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getStatusColor().withValues(alpha: 0.4),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(_getStatusIcon(), size: 14, color: _getStatusColor()),
                    const SizedBox(width: 6),
                    Text(
                      '${game.currentPlayersCount}/${game.playersNeeded}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Game Title
          Text(
            game.autoTitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 20),

          // Divider
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 20),

          // Details Section
          _buildDetailRow(Icons.person_pin_rounded, 'Host', _model.organizerName ?? 'Player'),
          const SizedBox(height: 16),

          // Venue button (larger, prominent) with date/time
          if (_model.game!.venueId != null)
            InkWell(
              onTap: _openDirections,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.blue.withValues(alpha: 0.15),
                      Colors.blue.withValues(alpha: 0.08),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.blue.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Date and Time at top
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 14, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          game.formattedDate,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Icon(Icons.access_time, size: 14, color: Colors.blue),
                        const SizedBox(width: 6),
                        Text(
                          game.formattedTime,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      height: 1,
                      color: Colors.white.withValues(alpha: 0.1),
                    ),
                    const SizedBox(height: 12),
                    // Venue info
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Venue',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _model.venueName ?? game.locationDisplay,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.directions_rounded,
                            color: Colors.blue,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          else
            Column(
              children: [
                _buildDetailRow(Icons.calendar_today, 'Date', game.formattedDate),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.access_time, 'Time', game.formattedTime),
                const SizedBox(height: 12),
                _buildDetailRow(Icons.location_on, 'Location', game.locationDisplay),
              ],
            ),
          const SizedBox(height: 16),
          _buildDetailRow(
            Icons.emoji_events,
            'Level',
            game.skillLevel != null ? 'Level ${game.skillLevel}' : 'Open',
            valueColor: game.skillLevel != null ? _getLevelColor(game.skillLevel) : null,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(
            Icons.currency_rupee,
            'Per Player Share',
            game.isFree ? 'Free' : '₹${game.costPerPlayer?.toStringAsFixed(0)}',
            valueColor: game.isFree ? Colors.green : Colors.blue,
          ),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.groups, 'Type', _getGameTypeLabel(game.gameType)),

          // Special badges
          if (game.isVenueBooked || game.isWomenOnly || game.isMixedOnly) ...[
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (game.isVenueBooked)
                  _buildSmallBadge('Booked', Icons.check_circle, Colors.green),
                if (game.isWomenOnly)
                  _buildSmallBadge('Women', Icons.female, Colors.pink),
                if (game.isMixedOnly)
                  _buildSmallBadge('Mixed', Icons.people, Colors.blue),
              ],
            ),
          ],

          // Description
          if (game.description != null && game.description!.isNotEmpty) ...[
            const SizedBox(height: 20),
            Container(
              height: 1,
              color: Colors.white.withValues(alpha: 0.1),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Icon(Icons.description_rounded, color: Colors.white.withValues(alpha: 0.7), size: 16),
                const SizedBox(width: 8),
                Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              game.description!,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.8),
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ],

          // Players Section
          const SizedBox(height: 20),
          Container(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.people_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Players (${_model.participants.length}/${game.playersNeeded})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_model.participants.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No players yet',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...(_model.participants.asMap().entries.map((entry) {
              final index = entry.key;
              final participant = entry.value;
              final isLast = index == _model.participants.length - 1;
              return Column(
                children: [
                  _buildPlayerCard(participant),
                  if (!isLast) const SizedBox(height: 8),
                ],
              );
            }).toList()),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value,
      {IconData? trailing, Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: TextStyle(
            fontSize: 13,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (trailing != null) ...[
          const SizedBox(width: 8),
          Icon(trailing, size: 16, color: Colors.blue),
        ],
      ],
    );
  }

  Widget _buildQuickInfoSection() {
    final game = _model.game!;
    final hasJoined =
        _model.participants.any((p) => p.userId == currentUserUid);

    return Row(
        children: [
          // Host
          Expanded(
            child: _buildQuickInfoCard(
              Icons.person_pin_rounded,
              'Host',
              _model.organizerName ?? 'Player',
              _getSportColor(),
            ),
          ),
          const SizedBox(width: 8),
          // Venue/Chat
          if (_model.game!.venueId != null)
            Expanded(
              child: InkWell(
                onTap: _openDirections,
                child: _buildQuickInfoCard(
                  Icons.location_on,
                  'Venue',
                  _model.venueName ?? game.locationDisplay,
                  Colors.blue,
                  icon2: Icons.directions_rounded,
                ),
              ),
            )
          else if (game.chatRoomId != null)
            Expanded(
              child: InkWell(
                onTap: hasJoined
                    ? () {
                        context.pushNamed(
                          'ChatRoomWidget',
                          queryParameters: {'roomId': game.chatRoomId!},
                        );
                      }
                    : null,
                child: _buildQuickInfoCard(
                  Icons.chat_bubble_rounded,
                  'Chat',
                  hasJoined ? 'Open' : 'Join first',
                  hasJoined ? Colors.green : Colors.grey,
                ),
              ),
            ),
        ],
    );
  }

  Widget _buildQuickInfoCard(
      IconData icon, String label, String value, Color color,
      {IconData? icon2}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            color.withValues(alpha: 0.15),
            color.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.7),
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (icon2 != null) ...[
                const Spacer(),
                Icon(icon2, size: 14, color: color),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsGrid() {
    final game = _model.game!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: _buildDetailItem(
                      Icons.calendar_today, 'Date', game.formattedDate)),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDetailItem(
                      Icons.access_time, 'Time', game.formattedTime)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                  child: _buildDetailItem(
                Icons.emoji_events,
                'Level',
                game.skillLevel != null
                    ? 'Level ${game.skillLevel}'
                    : 'Open',
                valueColor: game.skillLevel != null
                    ? _getLevelColor(game.skillLevel)
                    : null,
              )),
              const SizedBox(width: 12),
              Expanded(
                  child: _buildDetailItem(
                Icons.currency_rupee,
                'Cost',
                game.isFree
                    ? 'Free'
                    : '₹${game.costPerPlayer?.toStringAsFixed(0)}',
                valueColor: game.isFree ? Colors.green : Colors.orange,
              )),
            ],
          ),
          const SizedBox(height: 10),
          _buildDetailItem(
              Icons.groups, 'Type', _getGameTypeLabel(game.gameType)),

          // Special badges
          if (game.isVenueBooked ||
              game.isWomenOnly ||
              game.isMixedOnly) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (game.isVenueBooked)
                  _buildSmallBadge(
                      'Booked', Icons.check_circle, Colors.green),
                if (game.isWomenOnly)
                  _buildSmallBadge('Women', Icons.female, Colors.pink),
                if (game.isMixedOnly)
                  _buildSmallBadge('Mixed', Icons.people, Colors.blue),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value,
      {Color? valueColor}) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.white.withValues(alpha: 0.6)),
        const SizedBox(width: 6),
        Text(
          '$label: ',
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildSmallBadge(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getLevelColor(int? level) {
    if (level == null) return Colors.white.withValues(alpha: 0.7);
    if (level <= 2) return Colors.green.shade300;
    if (level == 3) return Colors.yellow.shade400;
    return Colors.orange.shade400;
  }

  Widget _buildPlayersSection() {
    final game = _model.game!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.people_rounded, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                'Players (${_model.participants.length}/${game.playersNeeded})',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_model.participants.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(
                  'No players yet',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 13,
                  ),
                ),
              ),
            )
          else
            ...(_model.participants.asMap().entries.map((entry) {
              final index = entry.key;
              final participant = entry.value;
              final isLast = index == _model.participants.length - 1;
              return Column(
                children: [
                  _buildPlayerCard(participant),
                  if (!isLast) const SizedBox(height: 8),
                ],
              );
            }).toList()),
        ],
      ),
    );
  }

  Widget _buildPlayerCard(GameParticipant participant) {
    final game = _model.game!;
    final isCreator = participant.userId == game.createdBy;
    final skillLevel = game.sportType == 'badminton'
        ? participant.skillLevelBadminton
        : participant.skillLevelPickleball;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: isCreator ? 0.08 : 0.04),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isCreator
              ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.3)
              : Colors.white.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Profile picture
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.1),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1.5,
              ),
              image: participant.profilePicture != null
                  ? DecorationImage(
                      image: NetworkImage(participant.profilePicture!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: participant.profilePicture == null
                ? Icon(
                    Icons.person,
                    color: Colors.white.withValues(alpha: 0.6),
                    size: 22,
                  )
                : null,
          ),
          const SizedBox(width: 10),

          // Player info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        participant.firstName ?? 'Player',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (isCreator) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context)
                              .primary
                              .withValues(alpha: 0.3),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'Host',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (skillLevel != null) ...[
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Icon(Icons.emoji_events,
                          size: 12, color: _getLevelColor(skillLevel)),
                      const SizedBox(width: 4),
                      Text(
                        'Level $skillLevel',
                        style: TextStyle(
                          color: _getLevelColor(skillLevel),
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    final game = _model.game!;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.12),
            Colors.white.withValues(alpha: 0.06),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.25),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.description_rounded,
                  color: Colors.white, size: 16),
              const SizedBox(width: 8),
              Text(
                'Description',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            game.description!,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.85),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAfterGameSection() {
    final hasParticipated =
        _model.participants.any((p) => p.userId == currentUserUid);

    if (!hasParticipated) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withValues(alpha: 0.15),
            Colors.purple.withValues(alpha: 0.08),
          ],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.purple.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events_rounded,
                  color: Colors.purple.shade300, size: 18),
              const SizedBox(width: 8),
              Text(
                'After Game',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // 2x2 Grid of actions
          Row(
            children: [
              Expanded(
                child: _buildAfterGameActionCard(
                  Icons.scoreboard_rounded,
                  'Record\nScores',
                  Colors.green,
                  () => _showRecordScoresDialog(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAfterGameActionCard(
                  Icons.star_rounded,
                  'Rate\nPlayers',
                  Colors.orange,
                  () => _showRatePlayersDialog(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildAfterGameActionCard(
                  Icons.label_rounded,
                  'Tag\nPlayers',
                  Colors.blue,
                  () => _showTagPlayersDialog(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildAfterGameActionCard(
                  Icons.group_add_rounded,
                  'Add Play\nPals',
                  Colors.pink,
                  () => _showAddPlayPalsDialog(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAfterGameActionCard(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.2),
              color.withValues(alpha: 0.1),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: color.withValues(alpha: 0.4),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showRecordScoresDialog() async {
    // Check if scores already recorded
    final hasRecorded = await AfterGameService.hasRecordedScores(
      gameId: _model.game!.id,
      userId: currentUserUid,
    );

    if (hasRecorded) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have already recorded scores for this game'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Show scores dialog
    await showDialog(
      context: context,
      builder: (context) => RecordScoresDialog(
        game: _model.game!,
        participants: _model.participants,
        currentUserId: currentUserUid,
      ),
    );

    // Refresh data
    await _loadGameDetails();
  }

  Future<void> _showRatePlayersDialog() async {
    // Get already rated player IDs
    final ratedPlayerIds = await AfterGameService.getRatedPlayerIds(
      gameId: _model.game!.id,
      userId: currentUserUid,
    );

    // Filter out current user and already rated players
    final playersToRate = _model.participants
        .where((p) =>
            p.userId != currentUserUid && !ratedPlayerIds.contains(p.userId))
        .toList();

    if (playersToRate.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You have already rated all players'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Show rate players dialog
    await showDialog(
      context: context,
      builder: (context) => RatePlayersDialog(
        gameId: _model.game!.id,
        players: playersToRate,
        currentUserId: currentUserUid,
      ),
    );
  }

  Future<void> _showTagPlayersDialog() async {
    // Filter out current user
    final playersToTag =
        _model.participants.where((p) => p.userId != currentUserUid).toList();

    if (playersToTag.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('No other players to tag'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Show tag players dialog
    await showDialog(
      context: context,
      builder: (context) => TagPlayersDialog(
        gameId: _model.game!.id,
        players: playersToTag,
        currentUserId: currentUserUid,
      ),
    );
  }

  Future<void> _showAddPlayPalsDialog() async {
    // Get existing play pals
    final existingPlayPalIds = await AfterGameService.getPlayPalIds(
      userId: currentUserUid,
      sportType: _model.game!.sportType,
    );

    // Filter out current user and existing play pals
    final playersToAdd = _model.participants
        .where((p) =>
            p.userId != currentUserUid &&
            !existingPlayPalIds.contains(p.userId))
        .toList();

    if (playersToAdd.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('All players are already in your play pals'),
            backgroundColor: Colors.pink,
          ),
        );
      }
      return;
    }

    if (!mounted) return;

    // Show add play pals dialog
    await showDialog(
      context: context,
      builder: (context) => AddPlayPalsDialog(
        sportType: _model.game!.sportType,
        players: playersToAdd,
        currentUserId: currentUserUid,
      ),
    );
  }

  Widget _buildStickyActionButtons() {
    final game = _model.game!;
    final isCreator = game.createdBy == currentUserUid;
    final hasJoined =
        _model.participants.any((p) => p.userId == currentUserUid);

    return Container(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).padding.bottom + 16,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF121212).withValues(alpha: 0.95),
            const Color(0xFF121212),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: Colors.white.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chat button (if participant)
          if (hasJoined && game.chatRoomId != null) ...[
            _buildActionButton(
              label: 'Game Chat',
              icon: Icons.chat_bubble_rounded,
              onTap: () {
                context.pushNamed(
                  'ChatRoom',
                  queryParameters: {
                    'roomId': game.chatRoomId!,
                  },
                );
              },
              isPrimary: false,
            ),
            const SizedBox(height: 12),
          ],

          // Join/Book button
          if (!isCreator &&
              !hasJoined &&
              game.status == 'open' &&
              !game.isFull)
            _buildActionButton(
              label: _model.isJoining
                  ? 'Processing...'
                  : game.isOfficial
                      ? (game.isFree
                          ? 'Book Now'
                          : 'Book & Pay ₹${game.costPerPlayer?.toStringAsFixed(0)}')
                      : (game.joinType == 'auto'
                          ? 'Join Game'
                          : 'Request to Join'),
              icon: game.isOfficial
                  ? (game.isFree
                      ? Icons.check_circle_rounded
                      : Icons.payments_rounded)
                  : (game.joinType == 'auto'
                      ? Icons.group_add_rounded
                      : Icons.send_rounded),
              onTap: _model.isJoining ? null : _handleJoinOrBookGame,
              isPrimary: true,
              isLoading: _model.isJoining,
            )
          else if (game.isFull && !hasJoined)
            Container(
              height: 56,
              decoration: BoxDecoration(
                color: Colors.grey.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.grey.withValues(alpha: 0.4),
                  width: 1.5,
                ),
              ),
              child: Center(
                child: Text(
                  'Game Full',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onTap,
    required bool isPrimary,
    bool isLoading = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          gradient: isPrimary
              ? LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    FlutterFlowTheme.of(context).primary,
                    FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.85),
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.08),
                  ],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPrimary
                ? FlutterFlowTheme.of(context).primary.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: FlutterFlowTheme.of(context)
                        .primary
                        .withValues(alpha: 0.4),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: Offset(0, 8),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            else
              Icon(
                icon,
                color: Colors.white,
                size: 24,
              ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getGameTypeLabel(String gameType) {
    switch (gameType) {
      case 'singles':
        return 'Singles';
      case 'doubles':
        return 'Doubles';
      case 'mixed_doubles':
        return 'Mixed Doubles';
      default:
        return gameType;
    }
  }

  Color _getSportColor() {
    switch (_model.game?.sportType) {
      case 'badminton':
        return const Color(0xFF00B4D8); // Bright blue
      case 'pickleball':
        return const Color(0xFF00C9A7); // Bright green
      default:
        return const Color(0xFF00B4D8); // Bright blue
    }
  }

  IconData _getSportIcon() {
    switch (_model.game?.sportType) {
      case 'badminton':
        return Icons.sports_tennis_rounded;
      case 'pickleball':
        return Icons.sports_baseball_rounded;
      default:
        return Icons.sports_rounded;
    }
  }

  Color _getStatusColor() {
    final game = _model.game!;
    if (game.isFull) return Colors.red;
    if (game.status == 'in_progress') return Colors.orange;
    if (game.status == 'completed') return Colors.grey;
    if (game.status == 'cancelled') return Colors.grey;
    return Colors.green;
  }

  IconData _getStatusIcon() {
    final game = _model.game!;
    if (game.isFull) return Icons.people_rounded;
    if (game.status == 'in_progress') return Icons.play_arrow_rounded;
    if (game.status == 'completed') return Icons.check_rounded;
    if (game.status == 'cancelled') return Icons.cancel_rounded;
    return Icons.group_add_rounded;
  }

  Future<void> _handleJoinOrBookGame() async {
    final game = _model.game!;

    // Handle official games differently
    if (game.isOfficial) {
      if (game.isFree) {
        // Free official game - direct booking
        await _bookFreeOfficialGame();
      } else {
        // Paid official game - process payment
        await _processPaymentAndBook();
      }
    } else {
      // Regular game - existing join logic
      if (game.joinType == 'request') {
        await _showRequestDialog();
      } else {
        await _joinGame(null);
      }
    }
  }

  Future<void> _bookFreeOfficialGame() async {
    setState(() => _model.isJoining = true);

    final success = await GamePaymentService.createFreeBooking(
      gameId: _model.game!.id,
      userId: currentUserUid,
    );

    if (mounted) {
      setState(() => _model.isJoining = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Booking confirmed!' : 'Failed to book game'),
          backgroundColor: success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      if (success) {
        await _loadGameDetails();
      }
    }
  }

  Future<void> _processPaymentAndBook() async {
    // Get user details
    final userData = await SupaFlow.client
        .from('users')
        .select('first_name, email')
        .eq('user_id', currentUserUid)
        .maybeSingle();

    final userName = userData?['first_name'] as String? ?? 'User';
    final userEmail = userData?['email'] as String?;
    final userContact = currentPhoneNumber.isNotEmpty ? currentPhoneNumber : null;

    if (!mounted) return;

    // Show payment sheet
    final success = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      builder: (context) => GamePaymentSheet(
        game: _model.game!,
        userName: userName,
        userEmail: userEmail,
        userContact: userContact,
      ),
    );

    // Reload game details if payment was successful
    if (success == true) {
      await _loadGameDetails();
    }
  }

  Future<void> _showRequestDialog() async {
    final messageController = TextEditingController();

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Request to Join',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Send a message to the game creator:',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: messageController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Optional message...',
                hintStyle:
                    TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: Colors.white.withValues(alpha: 0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: FlutterFlowTheme.of(context).primary),
                ),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: FlutterFlowTheme.of(context).primary,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send Request',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );

    if (result == true) {
      await _joinGame(
          messageController.text.isEmpty ? null : messageController.text);
    }
  }

  Future<void> _joinGame(String? message) async {
    setState(() => _model.isJoining = true);

    final result = await GameService.joinGame(
      gameId: _model.game!.id,
      userId: currentUserUid,
      message: message,
    );

    if (mounted) {
      setState(() => _model.isJoining = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.success ? Colors.green : Colors.red,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );

      if (result.success) {
        await _loadGameDetails();
      }
    }
  }

  Future<void> _openDirections() async {
    if (_model.venueLatitude == null || _model.venueLongitude == null) {
      // Fallback to address-based search
      if (_model.venueAddress != null) {
        final encodedAddress = Uri.encodeComponent(_model.venueAddress!);
        final url =
            'https://www.google.com/maps/search/?api=1&query=$encodedAddress';
        await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      }
      return;
    }

    // Open Google Maps with coordinates
    final lat = _model.venueLatitude!;
    final lng = _model.venueLongitude!;
    final url = 'https://www.google.com/maps/dir/?api=1&destination=$lat,$lng';

    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to open directions'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _shareGame() async {
    final game = _model.game!;

    // Create deep link URL
    final deepLink = 'funcircle://game/${game.id}';

    // Create a shareable message with game details
    final shareText = '''
🎮 Join my ${game.sportType == 'badminton' ? 'Badminton' : 'Pickleball'} game on FunCircle!

${game.autoTitle}

📍 ${game.locationDisplay}
📅 ${game.formattedDate}
⏰ ${game.formattedTime}
👥 ${game.currentPlayersCount}/${game.playersNeeded} players
${game.isFree ? '💵 Free' : '💵 ${game.costDisplay}'}
${game.description != null && game.description!.isNotEmpty ? '\n📝 ${game.description}' : ''}

🔗 Tap to join directly: $deepLink

🆔 Game ID: ${game.id}

Download FunCircle app to join this game!
''';

    try {
      await Share.share(shareText, subject: 'Join my game on FunCircle');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Game details shared!'),
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
      print('Error sharing game: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to share game'),
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

  Future<void> _showCancelGameDialog() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Cancel Game?',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'Are you sure you want to cancel this game? All participants will be notified.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('No', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.2),
            ),
            child: const Text('Yes, Cancel Game', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      try {
        final success = await GameService.cancelGame(
          gameId: widget.gameId,
          userId: currentUserUid,
          reason: 'Game cancelled by creator',
        );

        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Game cancelled successfully'),
              backgroundColor: Colors.green,
            ),
          );
          // Refresh game data
          await _loadGameDetails();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel game: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _showEditGameDialog() async {
    if (_model.game == null) return;

    await showDialog(
      context: context,
      builder: (context) => EditGameDialog(
        game: _model.game!,
        onSuccess: _loadGameDetails,
      ),
    );
  }
}

// Background pattern painter with enhanced visual effects
class _BackgroundPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Grid lines with reduced opacity
    final gridPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.01)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;

    // Draw vertical lines
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i, size.height),
        gridPaint,
      );
    }

    // Draw horizontal lines
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(
        Offset(0, i),
        Offset(size.width, i),
        gridPaint,
      );
    }

    // Add diagonal lines for more depth with reduced opacity
    final diagonalPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.005)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const diagonalSpacing = 80.0;

    // Diagonal lines top-left to bottom-right
    for (double i = -size.height; i < size.width; i += diagonalSpacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        diagonalPaint,
      );
    }

    // Add subtle dots at grid intersections with reduced opacity
    final dotPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..style = PaintingStyle.fill;

    for (double x = spacing; x < size.width; x += spacing * 3) {
      for (double y = spacing; y < size.height; y += spacing * 3) {
        canvas.drawCircle(Offset(x, y), 1.5, dotPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Custom painter for perforated ticket edge
class _PerforatedEdgePainter extends CustomPainter {
  final Color color;

  _PerforatedEdgePainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.3)
      ..style = PaintingStyle.fill;

    final circlePaint = Paint()
      ..color = const Color(0xFF121212)
      ..style = PaintingStyle.fill;

    // Draw the perforated strip background
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      paint,
    );

    // Draw perforation circles
    const circleRadius = 4.0;
    const circleSpacing = 16.0;

    for (double y = circleRadius; y < size.height; y += circleSpacing) {
      canvas.drawCircle(
        Offset(size.width / 2, y),
        circleRadius,
        circlePaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
