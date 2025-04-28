import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim_ui/states/global_state.dart';
import '../components/bottom_navegation.dart';
import '../components/post_card.dart';
import 'package:http/http.dart' as http;

class RepliesScreen extends StatefulWidget {
  final String postId;
  final String userName;
  final String userLogin;
  final String postContent;

  const RepliesScreen({
    Key? key,
    required this.postId,
    required this.userName,
    required this.userLogin,
    required this.postContent,
  }) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  final TextEditingController _replyController = TextEditingController();
  late Future<List<Reply>> _replies;

  @override
  void initState() {
    super.initState();
    _replies = _loadReplies();
  }  

  Future<List<Reply>> _loadReplies() async {
    try {
      final token = GlobalSession().session?.token ?? "";
      final url = Uri.parse('https://api.papacapim.just.pro.br/posts/${widget.postId}/replies');

      final response = await http.get(
        url,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((e) => Reply.fromJson(e)).toList();
      } else {
        throw Exception('Falha ao carregar respostas (status ${response.statusCode})');
      }
    } catch (e) {
      print("Erro ao carregar respostas: $e");
      return [];
    }
  }

  void _sendReply() async {
    String message = _replyController.text.trim();
    if (message.isNotEmpty) {
      final token = GlobalSession().session?.token ?? "";
      final url = Uri.parse('https://api.papacapim.just.pro.br/posts/${widget.postId}/replies');

      try {
        final response = await http.post(
          url,
          headers: {
            'x-session-token': token,
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            'reply': {
              'message': message,
            }
          }),
        );

        if (response.statusCode == 201 || response.statusCode == 200) {
          final currentReplies = await _replies;
          final newReply = Reply.fromJson(jsonDecode(response.body));
          setState(() {
          _replyController.clear();
          _replies = Future.value([...currentReplies, newReply]);
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Comentário enviado!")),
          );
          
        } else {
          final error = jsonDecode(response.body)['error'] ?? 'Erro desconhecido';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Falha ao postar: $error')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Não foi possível conectar: $e')),
        );
      } finally {

      }
      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Respostas")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: PostCard(
              postId: "1",
              userLogin: widget.userLogin,
              postContent: widget.postContent,
            ),
          ),

          const Divider(),

            Expanded(
            child: FutureBuilder<List<Reply>>(
              future: _replies,
              builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Erro: ${snapshot.error}'));
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text("Nenhuma resposta ainda"));
              } else if (snapshot.hasData) {
                final replies = snapshot.data!;
                return ListView.builder(
                itemCount: replies.length,
                itemBuilder: (context, index) {
                  final reply = replies[index];
                  return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                    reply.message,
                    style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  );
                },
                );
              }
              return Container();
              },
            ),
            ),

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _replyController,
                    decoration: const InputDecoration(
                      hintText: "Escreva um comentário...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendReply,
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}

class Reply {
  final int id;
  final String userLogin;
  final String message;
  final int postId;
  final String createdAt;
  final String updatedAt;

  Reply({
    required this.id,
    required this.userLogin,
    required this.message,
    required this.postId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    return Reply(
      id: json['id'],
      userLogin: json['user_login'],
      message: json['message'],
      postId: json['post_id'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}