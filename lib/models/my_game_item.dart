/// Model representing a game or request from either FindPlayers or PlayNow
class MyGameItem {
  final String id;
  final String source; // 'findplayers' or 'playnow'
  final String title;
  final String sportType;
  final String? venueId;
  final String venueName;
  final String venueLocation;
  final DateTime scheduledDateTime;
  final DateTime createdAt;
  final DateTime? joinedAt; // Only for PlayNow games
  final String status; // 'open', 'full', 'completed', 'cancelled', 'expired'
  final int playersNeeded;
  final int currentPlayers;
  final int? skillLevel;
  final String? description;
  final bool isPaid;
  final double paymentAmount;
  final String? paymentStatus; // 'pending', 'paid', 'waived'

  MyGameItem({
    required this.id,
    required this.source,
    required this.title,
    required this.sportType,
    this.venueId,
    required this.venueName,
    required this.venueLocation,
    required this.scheduledDateTime,
    required this.createdAt,
    this.joinedAt,
    required this.status,
    required this.playersNeeded,
    required this.currentPlayers,
    this.skillLevel,
    this.description,
    required this.isPaid,
    required this.paymentAmount,
    this.paymentStatus,
  });

  /// Whether this is from FindPlayers schema
  bool get isFindPlayers => source == 'findplayers';

  /// Whether this is from PlayNow schema
  bool get isPlayNow => source == 'playnow';

  /// Display badge for payment status
  String get paymentBadge {
    if (!isPaid) return 'Free';
    if (paymentStatus == 'paid') return 'Paid';
    if (paymentStatus == 'pending') return 'Payment Pending';
    return 'Free';
  }

  /// Color for status badge
  String get statusColor {
    switch (status.toLowerCase()) {
      case 'open':
        return 'green';
      case 'full':
        return 'blue';
      case 'in_progress':
        return 'orange';
      case 'completed':
        return 'grey';
      case 'cancelled':
        return 'red';
      case 'expired':
        return 'grey';
      default:
        return 'grey';
    }
  }

  /// Display text for status
  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'open':
        return 'Open';
      case 'full':
        return 'Full';
      case 'in_progress':
        return 'In Progress';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      case 'expired':
        return 'Expired';
      default:
        return status;
    }
  }

  /// Whether the game is in the future
  bool get isUpcoming => scheduledDateTime.isAfter(DateTime.now());

  /// Whether the game is in the past
  bool get isPast => scheduledDateTime.isBefore(DateTime.now());

  /// Format for display
  String get playersDisplay => '$currentPlayers/$playersNeeded';
}
