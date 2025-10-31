import 'package:intl/intl.dart';

class Booking {
  final String orderId;
  final String gameTitle;
  final String gameSport;
  final String venueId;
  final String venueName;
  final String venueLocation;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final DateTime bookedAt;
  final String bookingStatus;
  final double totalAmount;
  final int totalTickets;
  final String? cancellationReason;
  final DateTime? cancelledAt;
  final bool isRated;

  Booking({
    required this.orderId,
    required this.gameTitle,
    required this.gameSport,
    required this.venueId,
    required this.venueName,
    required this.venueLocation,
    required this.startDateTime,
    required this.endDateTime,
    required this.bookedAt,
    required this.bookingStatus,
    required this.totalAmount,
    required this.totalTickets,
    this.cancellationReason,
    this.cancelledAt,
    this.isRated = false,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    try {
      return Booking(
        orderId: json['order_id']?.toString() ?? '',
        gameTitle: json['game_title']?.toString() ?? 'Game',
        gameSport: json['game_sport']?.toString() ?? 'Badminton',
        venueId: json['venue_id']?.toString() ?? '',
        venueName: json['venue_name']?.toString() ?? 'Venue',
        venueLocation: json['venue_location']?.toString() ?? 'Location',
        startDateTime: _parseDateTime(json['start_date_time']) ?? DateTime.now(),
        endDateTime: _parseDateTime(json['end_date_time']) ?? DateTime.now(),
        bookedAt: _parseDateTime(json['booked_at']) ?? DateTime.now(),
        bookingStatus: json['booking_status']?.toString() ?? 'pending',
        totalAmount: _parseDouble(json['total_amount']),
        totalTickets: _parseInt(json['total_tickets']),
        cancellationReason: json['cancellation_reason']?.toString(),
        cancelledAt: _parseDateTime(json['cancelled_at']),
        isRated: json['is_rated'] == true || json['is_rated']?.toString().toLowerCase() == 'true',
      );
    } catch (e) {
      print('Error parsing booking: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    try {
      if (value is DateTime) return value;
      if (value is String) return DateTime.parse(value);
      return null;
    } catch (e) {
      print('Error parsing DateTime from: $value');
      return null;
    }
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  Map<String, dynamic> toJson() {
    return {
      'order_id': orderId,
      'game_title': gameTitle,
      'game_sport': gameSport,
      'venue_id': venueId,
      'venue_name': venueName,
      'venue_location': venueLocation,
      'start_date_time': startDateTime.toIso8601String(),
      'end_date_time': endDateTime.toIso8601String(),
      'booked_at': bookedAt.toIso8601String(),
      'booking_status': bookingStatus,
      'total_amount': totalAmount,
      'total_tickets': totalTickets,
      'cancellation_reason': cancellationReason,
      'cancelled_at': cancelledAt?.toIso8601String(),
      'is_rated': isRated,
    };
  }

  // Computed properties
  bool get isUpcoming => startDateTime.isAfter(DateTime.now()) && bookingStatus == 'confirmed';
  bool get isPast => endDateTime.isBefore(DateTime.now());
  bool get isCancelled => bookingStatus == 'cancelled';
  bool get canCancel => isUpcoming && !isCancelled;
  bool get canRate => isPast && bookingStatus == 'confirmed' && !isRated;

  String get formattedDate => DateFormat('MMM dd, yyyy').format(startDateTime);
  String get formattedTime => '${DateFormat('hh:mm a').format(startDateTime)} - ${DateFormat('hh:mm a').format(endDateTime)}';
  String get formattedDateTime => '${formattedDate} at ${DateFormat('hh:mm a').format(startDateTime)}';

  String get statusDisplay {
    switch (bookingStatus.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return bookingStatus;
    }
  }
}

class UserQuickStats {
  final int totalBookings;
  final int upcomingBookings;
  final int totalFriends;
  final int totalGamesPlayed;

  UserQuickStats({
    required this.totalBookings,
    required this.upcomingBookings,
    required this.totalFriends,
    required this.totalGamesPlayed,
  });

  factory UserQuickStats.fromJson(Map<String, dynamic> json) {
    return UserQuickStats(
      totalBookings: json['total_bookings'] as int? ?? 0,
      upcomingBookings: json['upcoming_bookings'] as int? ?? 0,
      totalFriends: json['total_friends'] as int? ?? 0,
      totalGamesPlayed: json['total_games_played'] as int? ?? 0,
    );
  }
}
