class Post {
  final int id;
  final String userLogin;
  final String message;
  final DateTime createdAt;
  final int? postId;

  Post({
    required this.id,
    required this.userLogin,
    required this.message,
    required this.createdAt,
    this.postId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userLogin: json['user_login'] as String,
      message: json['message'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      postId: json['post_id'] as int?,
    );
  }
}
