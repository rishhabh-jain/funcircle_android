import 'package:intl/intl.dart';

/// Model for playnow.court_bookings table
class CourtBooking {
  final String id;
  final int venueId;
  final String? venueName;
  final String userId;
  final String? gameId;
  final String bookingDate; // 'YYYY-MM-DD' format
  final String startTime; // 'HH:mm' format
  final String endTime; // 'HH:mm' format
  final int courtNumber;
  final double totalAmount;
  final String status; // 'pending', 'confirmed', 'cancelled', 'completed'
  final String? paymentId;
  final String? paymentStatus;
  final DateTime createdAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;

  CourtBooking({
    required this.id,
    required this.venueId,
    this.venueName,
    required this.userId,
    this.gameId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.courtNumber,
    required this.totalAmount,
    this.status = 'pending',
    this.paymentId,
    this.paymentStatus,
    required this.createdAt,
    this.cancelledAt,
    this.cancellationReason,
  });

  factory CourtBooking.fromJson(Map<String, dynamic> json) {
    return CourtBooking(
      id: json['id'] as String,
      venueId: json['venue_id'] as int,
      venueName: json['venue_name'] as String?,
      userId: json['user_id'] as String,
      gameId: json['game_id'] as String?,
      bookingDate: json['booking_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      courtNumber: json['court_number'] as int,
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: json['status'] as String? ?? 'pending',
      paymentId: json['payment_id'] as String?,
      paymentStatus: json['payment_status'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.parse(json['cancelled_at'] as String)
          : null,
      cancellationReason: json['cancellation_reason'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'venue_id': venueId,
      'user_id': userId,
      'game_id': gameId,
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'court_number': courtNumber,
      'total_amount': totalAmount,
      'status': status,
      'payment_id': paymentId,
      'payment_status': paymentStatus,
      'created_at': createdAt.toIso8601String(),
      'cancelled_at': cancelledAt?.toIso8601String(),
      'cancellation_reason': cancellationReason,
    };
  }

  // Computed properties
  DateTime get startDateTime {
    final date = DateTime.parse(bookingDate);
    final timeParts = startTime.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  DateTime get endDateTime {
    final date = DateTime.parse(bookingDate);
    final timeParts = endTime.split(':');
    return DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
    );
  }

  String get formattedDate => DateFormat('MMM dd, yyyy').format(startDateTime);
  String get formattedTimeRange => '$formattedStartTime - $formattedEndTime';

  String get formattedStartTime {
    try {
      final timeParts = startTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return startTime;
    }
  }

  String get formattedEndTime {
    try {
      final timeParts = endTime.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return endTime;
    }
  }

  bool get isUpcoming => startDateTime.isAfter(DateTime.now()) && status == 'confirmed';
  bool get isPast => endDateTime.isBefore(DateTime.now());
  bool get isCancelled => status == 'cancelled';
  bool get canCancel => isUpcoming && !isCancelled;

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'confirmed':
        return 'Confirmed';
      case 'pending':
        return 'Pending Payment';
      case 'cancelled':
        return 'Cancelled';
      case 'completed':
        return 'Completed';
      default:
        return status;
    }
  }

  Duration get duration => endDateTime.difference(startDateTime);
}

/// Request model for creating a court booking
class CreateCourtBookingRequest {
  final int venueId;
  final String userId;
  final String? gameId;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final int courtNumber;
  final double totalAmount;

  CreateCourtBookingRequest({
    required this.venueId,
    required this.userId,
    this.gameId,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.courtNumber,
    required this.totalAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'venue_id': venueId,
      'user_id': userId,
      'game_id': gameId,
      'booking_date': bookingDate,
      'start_time': startTime,
      'end_time': endTime,
      'court_number': courtNumber,
      'total_amount': totalAmount,
      'status': 'pending',
    };
  }
}

/// Time slot model for booking
class TimeSlot {
  final String startTime;
  final String endTime;
  final double price;
  final bool isAvailable;
  final List<int>? availableCourts;

  TimeSlot({
    required this.startTime,
    required this.endTime,
    required this.price,
    this.isAvailable = true,
    this.availableCourts,
  });

  String get displayTime {
    final start = _formatTime(startTime);
    final end = _formatTime(endTime);
    return '$start - $end';
  }

  String _formatTime(String time) {
    try {
      final timeParts = time.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time;
    }
  }
}
