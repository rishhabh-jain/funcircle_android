import 'package:intl/intl.dart';

class GameRequest {
  final String requestId;
  final String senderId;
  final String senderName;
  final String? senderImage;
  final String? senderLevel;
  final String receiverId;
  final String receiverName;
  final String? receiverImage;
  final String? receiverLevel;
  final String sportType;
  final String? message;
  final String status; // pending, accepted, rejected, cancelled
  final DateTime requestedAt;
  final DateTime? respondedAt;
  final String? venueId;
  final String? venueName;
  final DateTime? proposedDateTime;

  GameRequest({
    required this.requestId,
    required this.senderId,
    required this.senderName,
    this.senderImage,
    this.senderLevel,
    required this.receiverId,
    required this.receiverName,
    this.receiverImage,
    this.receiverLevel,
    required this.sportType,
    this.message,
    required this.status,
    required this.requestedAt,
    this.respondedAt,
    this.venueId,
    this.venueName,
    this.proposedDateTime,
  });

  factory GameRequest.fromJson(Map<String, dynamic> json) {
    return GameRequest(
      requestId: json['request_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: json['sender_name'] as String? ?? 'User',
      senderImage: json['sender_image'] as String?,
      senderLevel: json['sender_level'] as String?,
      receiverId: json['receiver_id'] as String,
      receiverName: json['receiver_name'] as String? ?? 'User',
      receiverImage: json['receiver_image'] as String?,
      receiverLevel: json['receiver_level'] as String?,
      sportType: json['sport_type'] as String? ?? 'Badminton',
      message: json['message'] as String?,
      status: json['status'] as String? ?? 'pending',
      requestedAt: DateTime.parse(json['requested_at'] as String),
      respondedAt: json['responded_at'] != null
          ? DateTime.parse(json['responded_at'] as String)
          : null,
      venueId: json['venue_id'] as String?,
      venueName: json['venue_name'] as String?,
      proposedDateTime: json['proposed_date_time'] != null
          ? DateTime.parse(json['proposed_date_time'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'request_id': requestId,
      'sender_id': senderId,
      'sender_name': senderName,
      'sender_image': senderImage,
      'sender_level': senderLevel,
      'receiver_id': receiverId,
      'receiver_name': receiverName,
      'receiver_image': receiverImage,
      'receiver_level': receiverLevel,
      'sport_type': sportType,
      'message': message,
      'status': status,
      'requested_at': requestedAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'venue_id': venueId,
      'venue_name': venueName,
      'proposed_date_time': proposedDateTime?.toIso8601String(),
    };
  }

  // Computed properties
  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isRejected => status == 'rejected';
  bool get isCancelled => status == 'cancelled';

  String get formattedRequestDate => DateFormat('MMM dd, yyyy').format(requestedAt);
  String get timeAgo {
    final difference = DateTime.now().difference(requestedAt);
    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  String get statusDisplay {
    switch (status.toLowerCase()) {
      case 'pending':
        return 'Pending';
      case 'accepted':
        return 'Accepted';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status;
    }
  }
}
