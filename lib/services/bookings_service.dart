import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/booking.dart';

class BookingsService {
  final SupabaseClient _supabase;

  BookingsService(this._supabase);

  Future<List<Booking>> getUserBookings(String userId, {String? filter}) async {
    try {
      print('Fetching bookings for user: $userId, filter: $filter');

      final now = DateTime.now();
      final bookings = <Booking>[];

      // ============ FETCH PAID PLAYNOW GAMES ============
      // NOTE: Only show paid games (both official and user-created)
      try {
        print('Fetching paid PlayNow games...');

        // First, get all participants for this user to see what we have
        final allParticipants = await _supabase
            .schema('playnow')
            .from('game_participants')
            .select('game_id, payment_status, payment_amount')
            .eq('user_id', userId);

        print('DEBUG BOOKINGS: Total game_participants for user: ${(allParticipants as List).length}');
        for (final p in allParticipants) {
          print('  - game_id: ${p['game_id']}, payment_status: "${p['payment_status']}", amount: ${p['payment_amount']}');
        }
        print('DEBUG BOOKINGS: Looking for payment_status == "paid"');

        var newQuery = _supabase
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
                status,
                game_type,
                cost_per_player,
                is_official
              )
            ''')
            .eq('user_id', userId)
            .eq('payment_status', 'paid'); // Only show paid games in bookings

        // Apply status filters for new system (match My Games logic)
        if (filter != null && filter != 'all') {
          switch (filter.toLowerCase()) {
            case 'cancelled':
              newQuery = newQuery.eq('games.status', 'cancelled');
              break;
            case 'upcoming':
            case 'past':
              // Don't filter by status at DB level - let date-based filtering handle it
              // This ensures all games (open, full, completed, etc.) show up if they match the date criteria
              newQuery = newQuery.neq('games.status', 'cancelled');
              break;
          }
        }

        final newResults = await newQuery.order('joined_at', ascending: false);
        print('DEBUG BOOKINGS: Received ${(newResults as List).length} paid games after filtering');
        if ((newResults as List).isEmpty) {
          print('DEBUG BOOKINGS: No paid games found! Check if payment_status values match "paid"');
        }

        // Transform new system games into bookings
        for (final participant in newResults) {
          try {
            final game = participant['games'];
            if (game == null) {
              print('DEBUG BOOKINGS: Skipping participant - game is null');
              continue;
            }

            final gameDate = game['game_date'] as String;
            final startTime = game['start_time'] as String;
            final endTime = game['end_time'] as String?; // Nullable

            final startDateTime = DateTime.parse('$gameDate $startTime');
            // If end_time is null, default to 1 hour after start time
            final endDateTime = endTime != null
                ? DateTime.parse('$gameDate $endTime')
                : startDateTime.add(Duration(hours: 1));
            final joinedAt = DateTime.parse(participant['joined_at'] as String);

            print('DEBUG BOOKINGS: Processing game ${game['id']}, date: $startDateTime, filter: $filter');

            // Apply date-based filters
            if (filter == 'upcoming' && !startDateTime.isAfter(now)) {
              print('DEBUG BOOKINGS: Skipping game ${game['id']} - not upcoming (date: $startDateTime vs now: $now)');
              continue;
            }
            if (filter == 'past' && !endDateTime.isBefore(now)) {
              print('DEBUG BOOKINGS: Skipping game ${game['id']} - not past (endDate: $endDateTime vs now: $now)');
              continue;
            }

            // Map game status to booking status
            String bookingStatus;
            switch ((game['status'] as String?)?.toLowerCase()) {
              case 'open':
              case 'full':
                bookingStatus = 'confirmed';
                break;
              case 'completed':
                bookingStatus = 'completed';
                break;
              case 'cancelled':
                bookingStatus = 'cancelled';
                break;
              default:
                bookingStatus = 'confirmed';
            }

            // Fetch venue details if venue_id exists
            String venueName = 'Venue';
            String venueLocation = 'Location';
            String venueIdStr = '';
            final venueId = game['venue_id'];
            if (venueId != null) {
              try {
                final venueData = await _supabase
                    .from('venues')
                    .select('id, venue_name, location')
                    .eq('id', venueId)
                    .maybeSingle();
                if (venueData != null) {
                  venueIdStr = venueData['id']?.toString() ?? '';
                  venueName = venueData['venue_name'] as String? ?? 'Venue';
                  venueLocation = venueData['location'] as String? ?? 'Location';
                }
              } catch (e) {
                print('Error fetching venue $venueId: $e');
              }
            }

            final booking = Booking(
              orderId: 'game-${game['id']}',
              gameTitle: game['title'] ?? '${game['game_type'] ?? 'Game'} Match',
              gameSport: game['sport_type'] ?? 'Badminton',
              venueId: venueIdStr,
              venueName: venueName,
              venueLocation: venueLocation,
              startDateTime: startDateTime,
              endDateTime: endDateTime,
              bookedAt: joinedAt,
              bookingStatus: bookingStatus,
              totalAmount: (participant['payment_amount'] as num?)?.toDouble() ??
                          (game['cost_per_player'] as num?)?.toDouble() ?? 0.0,
              totalTickets: 1, // Games are per-player, not tickets
            );

            bookings.add(booking);
            print('DEBUG BOOKINGS: Added booking for game ${game['id']} - ${booking.gameTitle}');
          } catch (e) {
            print('Error parsing PlayNow game: $e');
            print('Problematic game data: $participant');
          }
        }
      } catch (e) {
        print('Error fetching PlayNow games: $e');
      }

      // Sort all bookings by booked date (most recent first)
      bookings.sort((a, b) => b.bookedAt.compareTo(a.bookedAt));

      print('Successfully fetched ${bookings.length} paid game bookings');
      return bookings;
    } catch (e, stackTrace) {
      print('Error in getUserBookings: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to load bookings: $e');
    }
  }

  Future<Booking> getBookingDetails(String orderId) async {
    try {
      final result = await _supabase
          .from('orders')
          .select('''
            id,
            created_at,
            status,
            Orderitems!inner(
              id,
              ticket_id,
              quantity,
              sub_price,
              status,
              tickets!inner(
                id,
                title,
                type,
                startdatetime,
                enddatetime,
                price,
                venueid,
                venues!venueid(
                  id,
                  venue_name,
                  location
                )
              )
            )
          ''')
          .eq('id', orderId)
          .single();

      // Get first order item and ticket
      final orderItems = result['Orderitems'] as List;
      if (orderItems.isEmpty) {
        throw Exception('No order items found');
      }

      final item = orderItems.first;
      final ticket = item['tickets'];
      final venue = ticket['venues'];

      return Booking(
        orderId: result['id'].toString(),
        gameTitle: ticket['title'] ?? 'Game',
        gameSport: ticket['type'] ?? 'Badminton',
        venueId: venue['id']?.toString() ?? '',
        venueName: venue['venue_name'] ?? 'Venue',
        venueLocation: venue['location'] ?? 'Location',
        startDateTime: DateTime.parse(ticket['startdatetime'] as String),
        endDateTime: DateTime.parse(ticket['enddatetime'] as String),
        bookedAt: DateTime.parse(result['created_at'] as String),
        bookingStatus: result['status'] ?? 'confirmed',
        totalAmount: double.tryParse(item['sub_price']?.toString() ?? '0') ?? 0.0,
        totalTickets: (item['quantity'] as int?) ?? 1,
      );
    } catch (e) {
      throw Exception('Failed to load booking details: $e');
    }
  }

  Future<void> cancelBooking(String orderId, String reason) async {
    try {
      await _supabase.from('orders').update({
        'status': 'cancelled',
        // Note: cancellation_reason and cancelled_at columns may not exist in orders table
        // Add them if needed or store in a separate cancellations table
      }).eq('id', orderId);
    } catch (e) {
      throw Exception('Failed to cancel booking: $e');
    }
  }

  Future<void> rateBooking(String orderId, double rating, String? review) async {
    try {
      // This would typically update a ratings table
      // Assuming there's a reviews table linked to bookings
      await _supabase.from('reviews').insert({
        'order_id': orderId,
        'rating': rating,
        'review': review,
        'created_at': DateTime.now().toIso8601String(),
      });

      // Note: orders table may not have is_rated column
      // Add it if needed or track ratings separately
    } catch (e) {
      throw Exception('Failed to rate booking: $e');
    }
  }
}
