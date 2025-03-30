class Session {
  final int id;
  final String userLogin;
  final String token;
  final String ip;
  final DateTime createdAt;
  final DateTime updatedAt;

  Session({
    required this.id,
    required this.userLogin,
    required this.token,
    required this.ip,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json["id"],
      userLogin: json["user_login"],
      token: json["token"],
      ip: json["ip"],
      createdAt: DateTime.parse(json["created_at"]),
      updatedAt: DateTime.parse(json["updated_at"]),
    );
  }
}

class GlobalSession {
  static final GlobalSession _instance = GlobalSession._internal();
  Session? session;

  factory GlobalSession() {
    return _instance;
  }

  GlobalSession._internal();
}
