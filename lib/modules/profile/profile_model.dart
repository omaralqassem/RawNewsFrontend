class UserModel {
  final String id;
  final String username;
  final String email;
  final String phone;
  final bool isVerified;
  final String? avatarUrl;
  final List<String> preferredTopics;

  UserModel({
    required this.id,
    required this.username,
    required this.email,
    required this.phone,
    required this.isVerified,
    this.avatarUrl,
    required this.preferredTopics,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      isVerified: json['is_verified'] ?? false,
      avatarUrl: json['avatar_url'],
      preferredTopics: List<String>.from(json['preferred_topics'] ?? []),
    );
  }

  UserModel copyWith({
    String? username,
    String? email,
    String? phone,
    String? avatarUrl,
    List<String>? preferredTopics,
  }) {
    return UserModel(
      id: id,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isVerified: isVerified,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredTopics: preferredTopics ?? this.preferredTopics,
    );
  }
}