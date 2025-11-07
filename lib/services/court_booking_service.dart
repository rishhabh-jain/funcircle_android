import '/backend/supabase/supabase.dart';
import '../models/court_booking_model.dart';
import 'notifications_service.dart';

/// Service for managing court bookings in playnow.court_bookings
class CourtBookingService {
  static SupabaseClient get _client => SupaFlow.client;
  static NotificationsService get _notificationService => NotificationsService(_client);

  /// Create a new court booking
  static Future<CourtBooking?> createBooking(
      CreateCourtBookingRequest request) async {
    try {
      print('Creating court booking...');

      final bookingData = await _client
          .schema('playnow')
          .from('court_bookings')
          .insert(request.toJson())
          .select()
          .single();

      print('✓ Court booking created successfully!');

      final booking = CourtBooking.fromJson(bookingData);

      // Send booking confirmation notification
      try {
        // Get venue name
        final venueData = await _client
            .from('venues')
            .select('venue_name, location')
            .eq('id', booking.venueId)
            .maybeSingle();

        if (venueData != null) {
          final venueName = venueData['venue_name'] as String? ?? 'Venue';
          final location = venueData['location'] as String? ?? '';
          final timeSlot = '${booking.startTime} - ${booking.endTime}';

          await _notificationService.notifyBookingConfirmation(
            userId: booking.userId,
            venueName: venueName,
            location: location,
            date: DateTime.parse(booking.bookingDate),
            timeSlot: timeSlot,
          );
          print('✓ Booking confirmation notification sent');
        }
      } catch (e) {
        print('✗ Error sending booking notification: $e');
        // Don't fail the booking if notification fails
      }

      return booking;
    } catch (e) {
      print('✗ Error creating court booking: $e');
      return null;
    }
  }

  /// Get user's bookings
  static Future<List<CourtBooking>> getUserBookings(String userId,
      {String? filter}) async {
    try {
      var query = _client
          .schema('playnow')
          .from('court_bookings')
          .select()
          .eq('user_id', userId);

      // Apply filters
      if (filter != null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        switch (filter.toLowerCase()) {
          case 'upcoming':
            query = query
                .gte('booking_date', today.toIso8601String().split('T')[0])
                .eq('status', 'confirmed');
            break;
          case 'past':
            query = query
                .lt('booking_date', today.toIso8601String().split('T')[0]);
            break;
          case 'cancelled':
            query = query.eq('status', 'cancelled');
            break;
        }
      }

      final results =
          await query.order('booking_date', ascending: false) as List;

      return results
          .map((json) => CourtBooking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting user bookings: $e');
      return [];
    }
  }

  /// Get booking by ID
  static Future<CourtBooking?> getBookingById(String bookingId) async {
    try {
      final result = await _client
          .schema('playnow')
          .from('court_bookings')
          .select()
          .eq('id', bookingId)
          .single();

      return CourtBooking.fromJson(result);
    } catch (e) {
      print('Error getting booking: $e');
      return null;
    }
  }

  /// Cancel a booking
  static Future<bool> cancelBooking(
      String bookingId, String cancellationReason) async {
    try {
      await _client.schema('playnow').from('court_bookings').update({
        'status': 'cancelled',
        'cancelled_at': DateTime.now().toIso8601String(),
        'cancellation_reason': cancellationReason,
      }).eq('id', bookingId);

      return true;
    } catch (e) {
      print('Error cancelling booking: $e');
      return false;
    }
  }

  /// Update payment status
  static Future<bool> updatePaymentStatus(
      String bookingId, String paymentId, String paymentStatus) async {
    try {
      await _client.schema('playnow').from('court_bookings').update({
        'payment_id': paymentId,
        'payment_status': paymentStatus,
        'status':
            paymentStatus == 'success' ? 'confirmed' : 'pending',
      }).eq('id', bookingId);

      return true;
    } catch (e) {
      print('Error updating payment status: $e');
      return false;
    }
  }

  /// Check if a time slot is available
  static Future<List<int>> getAvailableCourts({
    required int venueId,
    required String bookingDate,
    required String startTime,
    required String endTime,
    required int totalCourts,
  }) async {
    try {
      // Get all bookings for this venue on this date that overlap with the requested time
      final bookings = await _client
          .schema('playnow')
          .from('court_bookings')
          .select('court_number')
          .eq('venue_id', venueId)
          .eq('booking_date', bookingDate)
          .neq('status', 'cancelled') as List;

      // Filter bookings that overlap with requested time
      final bookedCourts = <int>{};
      for (final booking in bookings) {
        final bookingStart = booking['start_time'] as String;
        final bookingEnd = booking['end_time'] as String;

        // Check if times overlap
        if (_timesOverlap(startTime, endTime, bookingStart, bookingEnd)) {
          bookedCourts.add(booking['court_number'] as int);
        }
      }

      // Return list of available courts
      final availableCourts = <int>[];
      for (int i = 1; i <= totalCourts; i++) {
        if (!bookedCourts.contains(i)) {
          availableCourts.add(i);
        }
      }

      return availableCourts;
    } catch (e) {
      print('Error checking availability: $e');
      return [];
    }
  }

  /// Generate time slots for a day
  static List<TimeSlot> generateTimeSlots({
    required double pricePerHour,
    String startHour = '06:00',
    String endHour = '23:00',
    int slotDurationMinutes = 60,
  }) {
    final slots = <TimeSlot>[];

    // Parse start time
    final startParts = startHour.split(':');
    int currentHour = int.parse(startParts[0]);
    int currentMinute = int.parse(startParts[1]);

    // Parse end time
    final endParts = endHour.split(':');
    final endHourInt = int.parse(endParts[0]);
    final endMinuteInt = int.parse(endParts[1]);

    while (currentHour < endHourInt ||
        (currentHour == endHourInt && currentMinute < endMinuteInt)) {
      final slotStart =
          '${currentHour.toString().padLeft(2, '0')}:${currentMinute.toString().padLeft(2, '0')}';

      // Calculate end time
      int endMinute = currentMinute + slotDurationMinutes;
      int endHour = currentHour;
      if (endMinute >= 60) {
        endHour += endMinute ~/ 60;
        endMinute = endMinute % 60;
      }

      // Don't create slot if it goes past closing time
      if (endHour > endHourInt ||
          (endHour == endHourInt && endMinute > endMinuteInt)) {
        break;
      }

      final slotEnd =
          '${endHour.toString().padLeft(2, '0')}:${endMinute.toString().padLeft(2, '0')}';

      // Calculate price based on duration
      final durationHours = slotDurationMinutes / 60.0;
      final price = pricePerHour * durationHours;

      slots.add(TimeSlot(
        startTime: slotStart,
        endTime: slotEnd,
        price: price,
      ));

      // Move to next slot
      currentMinute += slotDurationMinutes;
      if (currentMinute >= 60) {
        currentHour += currentMinute ~/ 60;
        currentMinute = currentMinute % 60;
      }
    }

    return slots;
  }

  /// Get bookings for a specific venue and date
  static Future<List<CourtBooking>> getVenueBookings({
    required int venueId,
    required String bookingDate,
  }) async {
    try {
      final results = await _client
          .schema('playnow')
          .from('court_bookings')
          .select()
          .eq('venue_id', venueId)
          .eq('booking_date', bookingDate)
          .neq('status', 'cancelled')
          .order('start_time', ascending: true) as List;

      return results
          .map((json) => CourtBooking.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error getting venue bookings: $e');
      return [];
    }
  }

  // Private helper methods

  /// Check if two time ranges overlap
  static bool _timesOverlap(
      String start1, String end1, String start2, String end2) {
    final start1Minutes = _timeToMinutes(start1);
    final end1Minutes = _timeToMinutes(end1);
    final start2Minutes = _timeToMinutes(start2);
    final end2Minutes = _timeToMinutes(end2);

    return start1Minutes < end2Minutes && end1Minutes > start2Minutes;
  }

  /// Convert time string to minutes since midnight
  static int _timeToMinutes(String time) {
    final parts = time.split(':');
    return int.parse(parts[0]) * 60 + int.parse(parts[1]);
  }
}
