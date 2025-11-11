import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/my_game_item.dart';

/// Service for fetching ALL games and requests (paid or free) for "My Games" screen
class MyGamesService {
  final SupabaseClient _supabase;

  MyGamesService(this._supabase);

  /// Fetches all games and requests user is involved in
  Future<List<MyGameItem>> getUserGames(String userId, {String? filter}) async {
    try {
      print('Fetching all games for user: $userId, filter: $filter');

      final now = DateTime.now();
      final allGames = <MyGameItem>[];

      // ============ FETCH FIND PLAYERS REQUESTS ============
      try {
        print('Fetching FindPlayers requests...');

        var requestsQuery = _supabase
            .schema('findplayers')
            .from('player_requests')
            .select('*')
            .eq('user_id', userId);

        // Apply status filters (only for cancelled, date-based filtering handles upcoming/past)
        if (filter != null && filter != 'all') {
          switch (filter.toLowerCase()) {
            case 'cancelled':
              requestsQuery = requestsQuery.eq('status', 'cancelled');
              break;
            case 'upcoming':
            case 'past':
              // Don't filter by status at DB level - let date-based filtering handle it
              // This ensures all games (active, fulfilled, expired) show up if they match the date criteria
              requestsQuery = requestsQuery.neq('status', 'cancelled');
              break;
          }
        }

        final requestsResults = await requestsQuery.order('created_at', ascending: false);
        print('Received ${(requestsResults as List).length} FindPlayers requests');

        // Transform requests into game items
        for (final request in requestsResults) {
          try {
            final scheduledTime = DateTime.parse(request['scheduled_time'] as String);
            final createdAt = DateTime.parse(request['created_at'] as String);

            // Apply date-based filters
            if (filter == 'upcoming' && !scheduledTime.isAfter(now)) continue;
            if (filter == 'past' && !scheduledTime.isBefore(now)) continue;

            // Determine status
            String itemStatus;
            switch ((request['status'] as String?)?.toLowerCase()) {
              case 'active':
                itemStatus = 'open';
                break;
              case 'fulfilled':
                itemStatus = 'completed';
                break;
              case 'expired':
                itemStatus = 'expired';
                break;
              case 'cancelled':
                itemStatus = 'cancelled';
                break;
              default:
                itemStatus = 'open';
            }

            // Fetch venue details if venue_id exists
            String? venueName;
            String? venueLocation;
            final venueId = request['venue_id'];
            if (venueId != null) {
              try {
                final venueData = await _supabase
                    .from('venues')
                    .select('venue_name, location')
                    .eq('id', venueId)
                    .maybeSingle();
                if (venueData != null) {
                  venueName = venueData['venue_name'] as String?;
                  venueLocation = venueData['location'] as String?;
                }
              } catch (e) {
                print('Error fetching venue $venueId: $e');
              }
            }

            final gameItem = MyGameItem(
              id: request['id'].toString(),
              source: 'findplayers',
              title: '${request['sport_type'] ?? 'Game'} - ${request['players_needed']} Players Needed',
              sportType: request['sport_type'] ?? 'Badminton',
              venueId: venueId?.toString(),
              venueName: venueName ?? request['custom_location'] ?? 'Location',
              venueLocation: venueLocation ?? request['custom_location'] ?? 'TBD',
              scheduledDateTime: scheduledTime,
              createdAt: createdAt,
              status: itemStatus,
              playersNeeded: request['players_needed'] ?? 1,
              currentPlayers: 1, // Creator is always one player
              skillLevel: request['skill_level'],
              description: request['description'],
              isPaid: false, // FindPlayers requests are always free
              paymentAmount: 0.0,
            );

            allGames.add(gameItem);
          } catch (e) {
            print('Error parsing FindPlayers request: $e');
          }
        }
      } catch (e) {
        print('Error fetching FindPlayers requests: $e');
      }

      // ============ FETCH FINDPLAYERS INTERESTED REQUESTS ============
      try {
        print('Fetching FindPlayers interested requests...');

        // First get all response IDs where user showed interest
        var responsesQuery = _supabase
            .schema('findplayers')
            .from('player_request_responses')
            .select('request_id, created_at')
            .eq('responder_id', userId);

        final responsesResults = await responsesQuery.order('created_at', ascending: false);
        print('Received ${(responsesResults as List).length} interested requests');

        // Transform interested requests into game items
        for (final response in responsesResults) {
          try {
            final requestId = response['request_id'] as String?;
            if (requestId == null) continue;

            // Fetch the actual request details
            final requestData = await _supabase
                .schema('findplayers')
                .from('player_requests')
                .select('*')
                .eq('id', requestId)
                .maybeSingle();

            if (requestData == null) continue;
            final request = requestData;

            final scheduledTime = DateTime.parse(request['scheduled_time'] as String);
            final createdAt = DateTime.parse(request['created_at'] as String);
            final interestedAt = DateTime.parse(response['created_at'] as String);

            // Apply date-based filters
            if (filter == 'upcoming' && !scheduledTime.isAfter(now)) continue;
            if (filter == 'past' && !scheduledTime.isBefore(now)) continue;

            // Determine status
            String itemStatus;
            switch ((request['status'] as String?)?.toLowerCase()) {
              case 'active':
                itemStatus = 'open';
                break;
              case 'fulfilled':
                itemStatus = 'completed';
                break;
              case 'expired':
                itemStatus = 'expired';
                break;
              case 'cancelled':
                itemStatus = 'cancelled';
                break;
              default:
                itemStatus = 'open';
            }

            // Apply status filters (cancelled only, date filtering already handled)
            if (filter == 'cancelled' && itemStatus != 'cancelled') continue;
            if (filter != 'cancelled' && filter != 'all' && itemStatus == 'cancelled') continue;

            // Fetch venue details if venue_id exists
            String? venueName;
            String? venueLocation;
            final venueId = request['venue_id'];
            if (venueId != null) {
              try {
                final venueData = await _supabase
                    .from('venues')
                    .select('venue_name, location')
                    .eq('id', venueId)
                    .maybeSingle();
                if (venueData != null) {
                  venueName = venueData['venue_name'] as String?;
                  venueLocation = venueData['location'] as String?;
                }
              } catch (e) {
                print('Error fetching venue $venueId: $e');
              }
            }

            final gameItem = MyGameItem(
              id: request['id'].toString(),
              source: 'findplayers',
              title: '${request['sport_type'] ?? 'Game'} - ${request['players_needed']} Players Needed',
              sportType: request['sport_type'] ?? 'Badminton',
              venueId: venueId?.toString(),
              venueName: venueName ?? request['custom_location'] ?? 'Location',
              venueLocation: venueLocation ?? request['custom_location'] ?? 'TBD',
              scheduledDateTime: scheduledTime,
              createdAt: createdAt,
              joinedAt: interestedAt, // Use interest timestamp as joined date
              status: itemStatus,
              playersNeeded: request['players_needed'] ?? 1,
              currentPlayers: 1, // We don't track total interested users
              skillLevel: request['skill_level'],
              description: request['description'],
              isPaid: false,
              paymentAmount: 0.0,
            );

            allGames.add(gameItem);
          } catch (e) {
            print('Error parsing interested request: $e');
          }
        }
      } catch (e) {
        print('Error fetching interested requests: $e');
      }

      // ============ FETCH PLAYNOW GAMES ============
      try {
        print('Fetching PlayNow games...');

        var gamesQuery = _supabase
            .schema('playnow')
            .from('game_participants')
            .select('''
              game_id,
              joined_at,
              payment_status,
              payment_amount,
              games:game_id!inner(
                id,
                sport_type,
                game_date,
                start_time,
                end_time,
                venue_id,
                custom_location,
                players_needed,
                current_players_count,
                game_type,
                skill_level,
                cost_per_player,
                description,
                status,
                created_at
              )
            ''')
            .eq('user_id', userId);

        // Apply status filters (only for cancelled, date-based filtering handles upcoming/past)
        if (filter != null && filter != 'all') {
          switch (filter.toLowerCase()) {
            case 'cancelled':
              gamesQuery = gamesQuery.eq('games.status', 'cancelled');
              break;
            case 'upcoming':
            case 'past':
              // Don't filter by status at DB level - let date-based filtering handle it
              // This ensures all games (open, full, completed, etc.) show up if they match the date criteria
              gamesQuery = gamesQuery.neq('games.status', 'cancelled');
              break;
          }
        }

        final gamesResults = await gamesQuery.order('joined_at', ascending: false);
        print('Received ${(gamesResults as List).length} PlayNow games');

        // Transform games into game items
        for (final participant in gamesResults) {
          try {
            final game = participant['games'];
            if (game == null) continue;

            final gameDate = game['game_date'] as String;
            final startTime = game['start_time'] as String;

            final scheduledDateTime = DateTime.parse('$gameDate $startTime');
            final createdAt = DateTime.parse(game['created_at'] as String);
            final joinedAt = DateTime.parse(participant['joined_at'] as String);

            // Apply date-based filters
            if (filter == 'upcoming' && !scheduledDateTime.isAfter(now)) continue;
            if (filter == 'past' && !scheduledDateTime.isBefore(now)) continue;

            // Determine status
            String itemStatus;
            switch ((game['status'] as String?)?.toLowerCase()) {
              case 'open':
                itemStatus = 'open';
                break;
              case 'full':
                itemStatus = 'full';
                break;
              case 'in_progress':
                itemStatus = 'in_progress';
                break;
              case 'completed':
                itemStatus = 'completed';
                break;
              case 'cancelled':
                itemStatus = 'cancelled';
                break;
              default:
                itemStatus = 'open';
            }

            // Fetch venue details if venue_id exists
            String? venueName;
            String? venueLocation;
            final venueId = game['venue_id'];
            if (venueId != null) {
              try {
                final venueData = await _supabase
                    .from('venues')
                    .select('venue_name, location')
                    .eq('id', venueId)
                    .maybeSingle();
                if (venueData != null) {
                  venueName = venueData['venue_name'] as String?;
                  venueLocation = venueData['location'] as String?;
                }
              } catch (e) {
                print('Error fetching venue $venueId: $e');
              }
            }

            final isPaid = participant['payment_status'] == 'paid';
            final paymentAmount = (participant['payment_amount'] as num?)?.toDouble() ??
                                 (game['cost_per_player'] as num?)?.toDouble() ?? 0.0;

            final gameItem = MyGameItem(
              id: game['id'].toString(),
              source: 'playnow',
              title: '${game['game_type'] ?? 'Game'} - ${game['sport_type'] ?? 'Badminton'}',
              sportType: game['sport_type'] ?? 'Badminton',
              venueId: venueId?.toString(),
              venueName: venueName ?? game['custom_location'] ?? 'Venue',
              venueLocation: venueLocation ?? game['custom_location'] ?? 'TBD',
              scheduledDateTime: scheduledDateTime,
              createdAt: createdAt,
              joinedAt: joinedAt,
              status: itemStatus,
              playersNeeded: game['players_needed'] ?? 4,
              currentPlayers: game['current_players_count'] ?? 1,
              skillLevel: game['skill_level'],
              description: game['description'],
              isPaid: isPaid,
              paymentAmount: paymentAmount,
              paymentStatus: participant['payment_status'],
            );

            allGames.add(gameItem);
          } catch (e) {
            print('Error parsing PlayNow game: $e');
          }
        }
      } catch (e) {
        print('Error fetching PlayNow games: $e');
      }

      // Sort all games: paid games first, then by scheduled date (latest first)
      allGames.sort((a, b) {
        // First priority: paid games come before free games
        if (a.isPaid && !b.isPaid) return -1;
        if (!a.isPaid && b.isPaid) return 1;

        // Second priority: sort by scheduled date (descending - latest first)
        return b.scheduledDateTime.compareTo(a.scheduledDateTime);
      });

      print('Successfully fetched ${allGames.length} total games (FindPlayers + PlayNow)');
      return allGames;
    } catch (e, stackTrace) {
      print('Error in getUserGames: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load games: $e');
    }
  }
}
