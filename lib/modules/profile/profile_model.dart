class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isMember;
  final String? avatarUrl;
  final List<String> preferredTopics;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.isMember,
    this.avatarUrl,
    required this.preferredTopics,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Anonymous',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      isMember: json['is_member'] as bool? ?? false,
      avatarUrl: json['avatar_url'] as String?,
      preferredTopics: List<String>.from(json['preferred_topics'] ?? []),
    );
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    List<String>? preferredTopics,
  }) {
    return UserModel(
      id: id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      isMember: isMember,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      preferredTopics: preferredTopics ?? this.preferredTopics,
    );
  }
}
