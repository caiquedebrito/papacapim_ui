class User {
  final int id;
  final String login;
  final String name;
  final DateTime createdAt;

  User({
    required this.id,
    required this.login,
    required this.name,
    required this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is int ? json['id'] : 0,
      login: json['login'] as String ?? '',
      name: json['name'] as String ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
    );
  }
}
