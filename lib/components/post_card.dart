import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/like_button.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';
import 'package:papacapim_ui/states/global_state.dart';
import '../screens/replies_screen.dart';
import 'package:http/http.dart' as http;

class PostCard extends StatefulWidget {
  final String postId;
  final String userLogin;
  final String postContent;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onDelete;
  final VoidCallback? onUserTap; 
  final bool showDeleteButton;
  final bool showFollowerButton;

  const PostCard({
    Key? key,
    required this.postId,
    required this.userLogin,
    required this.postContent,
    this.onLike,
    this.onComment,
    this.onDelete,
    this.onUserTap,
    this.showDeleteButton = false, 
    this.showFollowerButton = true,
  }) : super(key: key);

  @override
  _PostCardState createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Future<List<Likes>> _likesFuture;
  bool _isLiked = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _likesFuture = _loadLikes();
    _isLoading = false;
  }

  Future<List<Likes>> _loadLikes() async {
    try {
      final token = GlobalSession().session?.token ?? "";
      final url = Uri.parse('https://api.papacapim.just.pro.br/posts/${widget.postId}/likes');

      final response = await http.get(
        url,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);

        jsonList.forEach((e) {
          if (e['user_login'] == GlobalSession().session?.userLogin) {
            _isLiked = true;
          }
        });

        setState(() {
          _isLiked = _isLiked;
        });

        return jsonList.map((e) => Likes.fromJson(e)).toList();
      } else {
        throw Exception('Falha ao carregar curtidas (status ${response.statusCode})');
      }
    } catch (e) {
      print("Erro ao carregar curtidas: $e");
      return [];
    }
  }

  Future<void> _toggleLike() async {
    final token = GlobalSession().session?.token ?? "";
    final url = Uri.parse('https://api.papacapim.just.pro.br/posts/${widget.postId}/likes');
    final deleteUrl = Uri.parse('${url.toString()}/1');

    try {
      final response = _isLiked
        ? await http.delete(deleteUrl, headers: {
            'x-session-token': token,
            'Content-Type': 'application/json',
          })
        : await http.post(url, headers: {
            'x-session-token': token,
            'Content-Type': 'application/json',
          });

      final success = (_isLiked && response.statusCode == 204) ||
      (!_isLiked && response.statusCode == 201);

      if (!success) {
        throw Exception(
          _isLiked
            ? 'Falha ao descurtir (status ${response.statusCode})'
            : 'Falha ao curtir (status ${response.statusCode})'
        );
      }

      setState(() {
        _isLiked = !_isLiked;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        color: Theme.of(context).colorScheme.primary,
        elevation: 8.0,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen()));
                        },
                        child: Text(
                          "@${widget.userLogin}",
                          style: TextStyle(
                              fontSize: 16, color: const Color.fromARGB(255, 236, 236, 236)),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 13.0, bottom: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.fiber_manual_record,
                              size: 8.0,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              "há 2 horas",
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  if (widget.showFollowerButton)
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.secondary,
                      ),
                      child: const Text("Seguir",
                          style: TextStyle(color: Colors.black)),
                    ),
                  if (widget.showDeleteButton && widget.onDelete != null)
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: widget.onDelete,
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 13.0),
                child: Text(
                  widget.postContent,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 5.0),
                    child: LikeButton(isLiked: _isLiked, onTap: _toggleLike),
                  ),
                  IconButton(
                    icon: const Icon(Icons.comment_outlined,
                        color: Color.fromARGB(255, 221, 221, 221)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RepliesScreen(
                            postId: widget.postId,
                            userName: widget.userLogin,
                            userLogin: widget.userLogin,
                            postContent: widget.postContent,
                          )
                        )
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Likes {
  final int id;
  final String userLogin;
  final int postId;
  final String createdAt;
  final String updatedAt;

  Likes({
    required this.id,
    required this.userLogin,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Likes.fromJson(Map<String, dynamic> json) {
    return Likes(
      id: json['id'],
      userLogin: json['user_login'],
      postId: json['post_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}