class UserSettings {
  final String userId;

  // Notification settings
  final bool pushNotifications;
  final bool emailNotifications;
  final bool gameRequestNotifications;
  final bool bookingNotifications;
  final bool chatNotifications;
  final bool friendRequestNotifications;

  // Appearance settings
  final String theme; // light, dark, system
  final String language; // en, hi, etc.

  // Privacy settings
  final bool profileVisible;
  final bool showOnlineStatus;
  final bool showLocation;
  final bool allowFriendRequests;

  final DateTime updatedAt;

  UserSettings({
    required this.userId,
    this.pushNotifications = true,
    this.emailNotifications = true,
    this.gameRequestNotifications = true,
    this.bookingNotifications = true,
    this.chatNotifications = true,
    this.friendRequestNotifications = true,
    this.theme = 'system',
    this.language = 'en',
    this.profileVisible = true,
    this.showOnlineStatus = true,
    this.showLocation = true,
    this.allowFriendRequests = true,
    required this.updatedAt,
  });

  factory UserSettings.fromJson(Map<String, dynamic> json) {
    return UserSettings(
      userId: json['user_id'] as String,
      pushNotifications: json['push_notifications'] as bool? ?? true,
      emailNotifications: json['email_notifications'] as bool? ?? true,
      gameRequestNotifications: json['game_request_notifications'] as bool? ?? true,
      bookingNotifications: json['booking_notifications'] as bool? ?? true,
      chatNotifications: json['chat_notifications'] as bool? ?? true,
      friendRequestNotifications: json['friend_request_notifications'] as bool? ?? true,
      theme: json['theme'] as String? ?? 'system',
      language: json['language'] as String? ?? 'en',
      profileVisible: json['profile_visible'] as bool? ?? true,
      showOnlineStatus: json['show_online_status'] as bool? ?? true,
      showLocation: json['show_location'] as bool? ?? true,
      allowFriendRequests: json['allow_friend_requests'] as bool? ?? true,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'push_notifications': pushNotifications,
      'email_notifications': emailNotifications,
      'game_request_notifications': gameRequestNotifications,
      'booking_notifications': bookingNotifications,
      'chat_notifications': chatNotifications,
      'friend_request_notifications': friendRequestNotifications,
      'theme': theme,
      'language': language,
      'profile_visible': profileVisible,
      'show_online_status': showOnlineStatus,
      'show_location': showLocation,
      'allow_friend_requests': allowFriendRequests,
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  UserSettings copyWith({
    bool? pushNotifications,
    bool? emailNotifications,
    bool? gameRequestNotifications,
    bool? bookingNotifications,
    bool? chatNotifications,
    bool? friendRequestNotifications,
    String? theme,
    String? language,
    bool? profileVisible,
    bool? showOnlineStatus,
    bool? showLocation,
    bool? allowFriendRequests,
  }) {
    return UserSettings(
      userId: this.userId,
      pushNotifications: pushNotifications ?? this.pushNotifications,
      emailNotifications: emailNotifications ?? this.emailNotifications,
      gameRequestNotifications: gameRequestNotifications ?? this.gameRequestNotifications,
      bookingNotifications: bookingNotifications ?? this.bookingNotifications,
      chatNotifications: chatNotifications ?? this.chatNotifications,
      friendRequestNotifications: friendRequestNotifications ?? this.friendRequestNotifications,
      theme: theme ?? this.theme,
      language: language ?? this.language,
      profileVisible: profileVisible ?? this.profileVisible,
      showOnlineStatus: showOnlineStatus ?? this.showOnlineStatus,
      showLocation: showLocation ?? this.showLocation,
      allowFriendRequests: allowFriendRequests ?? this.allowFriendRequests,
      updatedAt: DateTime.now(),
    );
  }
}
