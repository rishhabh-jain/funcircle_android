import 'package:intl/intl.dart';

/// Model for chat room invite
class RoomInvite {
  final String id;
  final String roomId;
  final String createdBy;
  final String inviteCode;
  final String inviteLink;
  final int? maxUses; // null means unlimited
  final int currentUses;
  final DateTime? expiresAt; // null means never expires
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Joined fields from view
  final String? creatorName;
  final String? creatorImage;
  final String? roomName;
  final String? roomType;
  final String? sportType;
  final int? memberCount;

  RoomInvite({
    required this.id,
    required this.roomId,
    required this.createdBy,
    required this.inviteCode,
    required this.inviteLink,
    this.maxUses,
    required this.currentUses,
    this.expiresAt,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    this.creatorName,
    this.creatorImage,
    this.roomName,
    this.roomType,
    this.sportType,
    this.memberCount,
  });

  factory RoomInvite.fromJson(Map<String, dynamic> json) {
    return RoomInvite(
      id: json['id'] as String,
      roomId: json['room_id'] as String,
      createdBy: json['created_by'] as String,
      inviteCode: json['invite_code'] as String,
      inviteLink: json['invite_link'] as String,
      maxUses: json['max_uses'] as int?,
      currentUses: (json['current_uses'] as num?)?.toInt() ?? 0,
      expiresAt: json['expires_at'] != null
          ? DateTime.parse(json['expires_at'] as String)
          : null,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      creatorName: json['creator_name'] as String?,
      creatorImage: json['creator_image'] as String?,
      roomName: json['room_name'] as String?,
      roomType: json['room_type'] as String?,
      sportType: json['sport_type'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_id': roomId,
      'created_by': createdBy,
      'invite_code': inviteCode,
      'invite_link': inviteLink,
      'max_uses': maxUses,
      'current_uses': currentUses,
      'expires_at': expiresAt?.toIso8601String(),
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  /// Check if invite is expired
  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  /// Check if invite has reached max uses
  bool get isMaxedOut {
    if (maxUses == null) return false;
    return currentUses >= maxUses!;
  }

  /// Check if invite is currently valid
  bool get isValid {
    return isActive && !isExpired && !isMaxedOut;
  }

  /// Get status as string
  String get status {
    if (!isActive) return 'inactive';
    if (isExpired) return 'expired';
    if (isMaxedOut) return 'maxed';
    return 'active';
  }

  /// Get status display text
  String get statusDisplay {
    switch (status) {
      case 'active':
        return 'Active';
      case 'expired':
        return 'Expired';
      case 'maxed':
        return 'Max Uses Reached';
      case 'inactive':
        return 'Inactive';
      default:
        return 'Unknown';
    }
  }

  /// Get usage display text
  String get usageDisplay {
    if (maxUses == null) {
      return '$currentUses uses';
    }
    return '$currentUses / $maxUses uses';
  }

  /// Get expiry display text
  String get expiryDisplay {
    if (expiresAt == null) {
      return 'Never expires';
    }
    final now = DateTime.now();
    final difference = expiresAt!.difference(now);

    if (difference.isNegative) {
      return 'Expired';
    }

    if (difference.inDays > 0) {
      return 'Expires in ${difference.inDays} days';
    } else if (difference.inHours > 0) {
      return 'Expires in ${difference.inHours} hours';
    } else if (difference.inMinutes > 0) {
      return 'Expires in ${difference.inMinutes} minutes';
    } else {
      return 'Expires soon';
    }
  }

  /// Get formatted created date
  String get formattedCreatedDate {
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  /// Get formatted expiry date
  String? get formattedExpiryDate {
    if (expiresAt == null) return null;
    return DateFormat('MMM d, yyyy h:mm a').format(expiresAt!);
  }

  RoomInvite copyWith({
    String? id,
    String? roomId,
    String? createdBy,
    String? inviteCode,
    String? inviteLink,
    int? maxUses,
    int? currentUses,
    DateTime? expiresAt,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? creatorName,
    String? creatorImage,
    String? roomName,
    String? roomType,
    String? sportType,
    int? memberCount,
  }) {
    return RoomInvite(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      createdBy: createdBy ?? this.createdBy,
      inviteCode: inviteCode ?? this.inviteCode,
      inviteLink: inviteLink ?? this.inviteLink,
      maxUses: maxUses ?? this.maxUses,
      currentUses: currentUses ?? this.currentUses,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      creatorName: creatorName ?? this.creatorName,
      creatorImage: creatorImage ?? this.creatorImage,
      roomName: roomName ?? this.roomName,
      roomType: roomType ?? this.roomType,
      sportType: sportType ?? this.sportType,
      memberCount: memberCount ?? this.memberCount,
    );
  }
}

/// Model for invite details when joining
class RoomInviteDetails {
  final String roomId;
  final String roomName;
  final String roomType;
  final String? sportType;
  final String? avatarUrl;
  final int memberCount;
  final int maxMembers;
  final String createdByName;
  final String? createdByImage;
  final bool isValid;

  RoomInviteDetails({
    required this.roomId,
    required this.roomName,
    required this.roomType,
    this.sportType,
    this.avatarUrl,
    required this.memberCount,
    required this.maxMembers,
    required this.createdByName,
    this.createdByImage,
    required this.isValid,
  });

  factory RoomInviteDetails.fromJson(Map<String, dynamic> json) {
    return RoomInviteDetails(
      roomId: json['room_id'] as String,
      roomName: json['room_name'] as String? ?? 'Chat Room',
      roomType: json['room_type'] as String,
      sportType: json['sport_type'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      memberCount: (json['member_count'] as num?)?.toInt() ?? 0,
      maxMembers: (json['max_members'] as num?)?.toInt() ?? 50,
      createdByName: json['created_by_name'] as String? ?? 'Someone',
      createdByImage: json['created_by_image'] as String?,
      isValid: json['is_valid'] as bool? ?? false,
    );
  }

  bool get isFull => memberCount >= maxMembers;

  String get memberCountDisplay => '$memberCount / $maxMembers members';
}
