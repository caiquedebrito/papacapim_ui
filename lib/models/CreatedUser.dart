class Createduser {
  final String login;
  final String name;
  final String created_at;
  final String updated_at;

  Createduser({required this.login, required this.name, required this.created_at, required this.updated_at}); 

  factory Createduser.fromJson(Map<String, dynamic> json) {
    return switch (json) {
      {'login': String login, 'name': String name, 'created_at': String created_at, 'updated_at': String updated_at} => Createduser(
        login: login, 
        name: name,
        created_at: created_at,
        updated_at: updated_at,
      ),
      _ => throw const FormatException('Failed to create user.'),
    };
  }
}