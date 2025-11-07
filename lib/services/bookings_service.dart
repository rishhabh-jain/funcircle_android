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

      // ============ FETCH FROM OLD SYSTEM (orders/tickets) ============
      try {
        print('Fetching from OLD system (orders/tickets)...');

        var oldQuery = _supabase
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
            .eq('user_id', userId);

        // Apply status filters for old system
        if (filter != null && filter != 'all') {
          switch (filter.toLowerCase()) {
            case 'upcoming':
              oldQuery = oldQuery.eq('status', 'confirmed');
              break;
            case 'cancelled':
              oldQuery = oldQuery.eq('status', 'cancelled');
              break;
          }
        }

        final oldResults = await oldQuery.order('created_at', ascending: false);
        print('Received ${(oldResults as List).length} old system orders');

        // Transform old system orders into bookings
        for (final order in oldResults) {
          try {
            final orderId = order['id'];
            final orderStatus = order['status'] ?? 'confirmed';
            final bookedAt = DateTime.parse(order['created_at'] as String);

            final orderItems = order['Orderitems'] as List? ?? [];

            for (final item in orderItems) {
              final ticket = item['tickets'];
              if (ticket == null) continue;

              final venue = ticket['venues'];
              final startDateTime = DateTime.parse(ticket['startdatetime'] as String);
              final endDateTime = DateTime.parse(ticket['enddatetime'] as String);

              // Apply date-based filters
              if (filter == 'upcoming' && !startDateTime.isAfter(now)) continue;
              if (filter == 'past' && !endDateTime.isBefore(now)) continue;

              final booking = Booking(
                orderId: 'ticket-${orderId}',
                gameTitle: ticket['title'] ?? 'Game',
                gameSport: ticket['type'] ?? 'Badminton',
                venueId: venue?['id']?.toString() ?? '',
                venueName: venue?['venue_name'] ?? 'Venue',
                venueLocation: venue?['location'] ?? 'Location',
                startDateTime: startDateTime,
                endDateTime: endDateTime,
                bookedAt: bookedAt,
                bookingStatus: orderStatus,
                totalAmount: double.tryParse(item['sub_price']?.toString() ?? '0') ?? 0.0,
                totalTickets: (item['quantity'] as int?) ?? 1,
              );

              bookings.add(booking);
            }
          } catch (e) {
            print('Error parsing old system order: $e');
          }
        }
      } catch (e) {
        print('Error fetching from old system: $e');
      }

      // ============ FETCH FROM NEW SYSTEM (playnow/games) ============
      // NOTE: Only fetch OFFICIAL FUNCIRCLE games for bookings (is_official = TRUE)
      try {
        print('Fetching from NEW system (playnow/games)... OFFICIAL FUNCIRCLE GAMES ONLY');

        // First, get all participants for this user to see what we have
        final allParticipants = await _supabase
            .schema('playnow')
            .from('game_participants')
            .select('game_id, payment_status, payment_amount')
            .eq('user_id', userId);

        print('DEBUG: Total game_participants for user: ${(allParticipants as List).length}');
        for (final p in allParticipants) {
          print('  - game_id: ${p['game_id']}, payment_status: ${p['payment_status']}, amount: ${p['payment_amount']}');
        }

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
            .filter('games.is_official', 'eq', true) // Only official FunCircle games
            .eq('payment_status', 'paid'); // And must be paid

        // Apply status filters for new system
        if (filter != null && filter != 'all') {
          switch (filter.toLowerCase()) {
            case 'upcoming':
              newQuery = newQuery.filter('games.status', 'in', '(open,full)');
              break;
            case 'past':
              newQuery = newQuery.eq('games.status', 'completed');
              break;
            case 'cancelled':
              newQuery = newQuery.eq('games.status', 'cancelled');
              break;
          }
        }

        final newResults = await newQuery.order('joined_at', ascending: false);
        print('Received ${(newResults as List).length} new system games');

        // Transform new system games into bookings
        for (final participant in newResults) {
          try {
            final game = participant['games'];
            if (game == null) continue;

            final gameDate = game['game_date'] as String;
            final startTime = game['start_time'] as String;
            final endTime = game['end_time'] as String;

            final startDateTime = DateTime.parse('$gameDate $startTime');
            final endDateTime = DateTime.parse('$gameDate $endTime');
            final joinedAt = DateTime.parse(participant['joined_at'] as String);

            // Apply date-based filters
            if (filter == 'upcoming' && !startDateTime.isAfter(now)) continue;
            if (filter == 'past' && !endDateTime.isBefore(now)) continue;

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
          } catch (e) {
            print('Error parsing new system game: $e');
            print('Problematic game data: $participant');
          }
        }
      } catch (e) {
        print('Error fetching from new system: $e');
      }

      // Sort all bookings by booked date (most recent first)
      bookings.sort((a, b) => b.bookedAt.compareTo(a.bookedAt));

      print('Successfully fetched ${bookings.length} total bookings (old + new system)');
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
