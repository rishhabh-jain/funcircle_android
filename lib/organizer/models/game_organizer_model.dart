import 'package:flutter/material.dart';

/// Model for game organizer from playnow.game_organizers table
class GameOrganizerModel {
  final String id;
  final String userId;
  final String sportType; // 'badminton' or 'pickleball'
  final int venueId;
  final String? venueName;
  final List<String> availableDays; // ['monday', 'tuesday', etc.]
  final List<TimeSlotModel> availableTimeSlots;
  final int skillLevel; // 1-5
  final String mobileNumber;
  final String? bio;
  final String? experience;
  final String status; // 'pending', 'approved', 'rejected', 'suspended'
  final DateTime applicationDate;
  final DateTime? approvedDate;
  final String? approvedBy;
  final String? rejectionReason;
  final DateTime? rejectionDate;
  final String? rejectedBy;
  final String? suspendedReason;
  final DateTime? suspendedDate;
  final String? suspendedBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  // For displaying user info in admin panel
  final String? userName;
  final String? userEmail;
  final String? userProfilePicture;

  GameOrganizerModel({
    required this.id,
    required this.userId,
    required this.sportType,
    required this.venueId,
    this.venueName,
    required this.availableDays,
    required this.availableTimeSlots,
    required this.skillLevel,
    required this.mobileNumber,
    this.bio,
    this.experience,
    required this.status,
    required this.applicationDate,
    this.approvedDate,
    this.approvedBy,
    this.rejectionReason,
    this.rejectionDate,
    this.rejectedBy,
    this.suspendedReason,
    this.suspendedDate,
    this.suspendedBy,
    required this.createdAt,
    required this.updatedAt,
    this.userName,
    this.userEmail,
    this.userProfilePicture,
  });

  /// Create from Supabase JSON
  factory GameOrganizerModel.fromJson(Map<String, dynamic> json) {
    // Parse time slots from JSONB
    List<TimeSlotModel> timeSlots = [];
    if (json['available_time_slots'] is List) {
      timeSlots = (json['available_time_slots'] as List)
          .map((slot) => TimeSlotModel.fromJson(slot as Map<String, dynamic>))
          .toList();
    }

    // Parse available days from text array
    List<String> days = [];
    if (json['available_days'] is List) {
      days = (json['available_days'] as List).cast<String>();
    }

    // Get user info if joined
    String? userName;
    String? userEmail;
    String? userProfilePicture;
    if (json['user'] is Map) {
      final user = json['user'] as Map<String, dynamic>;
      userName = user['first_name'] as String?;
      userEmail = user['email'] as String?;
      userProfilePicture = user['profile_picture'] as String?;
    }

    // Get venue name if joined
    String? venueName;
    if (json['venue'] is Map) {
      final venue = json['venue'] as Map<String, dynamic>;
      venueName = venue['venue_name'] as String?;
    }

    return GameOrganizerModel(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      sportType: json['sport_type'] as String,
      venueId: json['venue_id'] as int,
      venueName: venueName,
      availableDays: days,
      availableTimeSlots: timeSlots,
      skillLevel: json['skill_level'] as int,
      mobileNumber: json['mobile_number'] as String,
      bio: json['bio'] as String?,
      experience: json['experience'] as String?,
      status: json['status'] as String,
      applicationDate: DateTime.parse(json['application_date'] as String),
      approvedDate: json['approved_date'] != null
          ? DateTime.parse(json['approved_date'] as String)
          : null,
      approvedBy: json['approved_by'] as String?,
      rejectionReason: json['rejection_reason'] as String?,
      rejectionDate: json['rejection_date'] != null
          ? DateTime.parse(json['rejection_date'] as String)
          : null,
      rejectedBy: json['rejected_by'] as String?,
      suspendedReason: json['suspended_reason'] as String?,
      suspendedDate: json['suspended_date'] != null
          ? DateTime.parse(json['suspended_date'] as String)
          : null,
      suspendedBy: json['suspended_by'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      userName: userName,
      userEmail: userEmail,
      userProfilePicture: userProfilePicture,
    );
  }

  /// Convert to JSON for Supabase insert/update
  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'sport_type': sportType,
      'venue_id': venueId,
      'available_days': availableDays,
      'available_time_slots':
          availableTimeSlots.map((slot) => slot.toJson()).toList(),
      'skill_level': skillLevel,
      'mobile_number': mobileNumber,
      'bio': bio,
      'experience': experience,
      'status': status,
    };
  }

  /// Get status badge color
  Color getStatusColor() {
    switch (status) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  /// Get status display text
  String getStatusText() {
    switch (status) {
      case 'approved':
        return 'APPROVED';
      case 'pending':
        return 'PENDING';
      case 'rejected':
        return 'REJECTED';
      case 'suspended':
        return 'SUSPENDED';
      default:
        return status.toUpperCase();
    }
  }

  /// Get formatted available days
  String getFormattedDays() {
    if (availableDays.isEmpty) return 'Not specified';

    // Capitalize first letter
    return availableDays.map((day) {
      return day.substring(0, 3).toUpperCase();
    }).join(', ');
  }

  /// Get sport emoji
  String getSportEmoji() {
    return sportType == 'badminton' ? '🏸' : '🎾';
  }
}

/// Time slot model for available_time_slots JSONB field
class TimeSlotModel {
  final String startTime; // "HH:mm" format
  final String endTime; // "HH:mm" format

  TimeSlotModel({
    required this.startTime,
    required this.endTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  /// Format time slot for display
  String format() {
    return '$startTime - $endTime';
  }

  /// Get time of day slot label
  String getTimeSlotLabel() {
    final hour = int.parse(startTime.split(':')[0]);

    if (hour >= 6 && hour < 12) {
      return 'Morning';
    } else if (hour >= 12 && hour < 18) {
      return 'Afternoon';
    } else {
      return 'Evening';
    }
  }
}
