class UserProfile {
  final String login;
  final String name;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.login,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      login: json['login'] as String ?? '',
      name: json['name'] as String ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
    );
  }
}
