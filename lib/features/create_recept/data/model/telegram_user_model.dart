class TelegramUserModel {
  final int? id;
  final String? type;
  final String? firstName;
  final String? username;
  final String? bio;
  final bool? hasPrivateForwards;
  final List<String>? activeUsernames;
  final String? emojiStatusCustomEmojiId;

  TelegramUserModel({
    this.id,
    this.type,
    this.firstName,
    this.username,
    this.bio,
    this.hasPrivateForwards,
    this.activeUsernames,
    this.emojiStatusCustomEmojiId,
  });

  /// JSON'dan obyekt yaratish (fromJson)
  factory TelegramUserModel.fromJson(Map<String, dynamic> json) {
    return TelegramUserModel(
      id: json['id'],
      type: json['type'],
      firstName: json['first_name'],
      username: json['username'],
      bio: json['bio'],
      hasPrivateForwards: json['has_private_forwards'],
      activeUsernames: (json['active_usernames'] as List<dynamic>?)
          ?.map((item) => item as String)
          .toList(),
      emojiStatusCustomEmojiId: json['emoji_status_custom_emoji_id'],
    );
  }

  /// Obyektdan JSON yaratish (toJson)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'first_name': firstName,
      'username': username,
      'bio': bio,
      'has_private_forwards': hasPrivateForwards,
      'active_usernames': activeUsernames,
      'emoji_status_custom_emoji_id': emojiStatusCustomEmojiId,
    };
  }
}
