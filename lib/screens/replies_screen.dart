import 'package:flutter/material.dart';
import '../components/bottom_navegation.dart';
import '../components/post_card.dart';

class RepliesScreen extends StatefulWidget {
  final String userName;
  final String userLogin;
  final String postContent;

  const RepliesScreen({
    Key? key,
    required this.userName,
    required this.userLogin,
    required this.postContent,
  }) : super(key: key);

  @override
  _RepliesScreenState createState() => _RepliesScreenState();
}

class _RepliesScreenState extends State<RepliesScreen> {
  final TextEditingController _replyController = TextEditingController();
  List<String> _replies = [];

  // Simula o envio de uma resposta
  void _sendReply() {
    if (_replyController.text.isNotEmpty) {
      setState(() {
        _replies.add(_replyController.text);
        _replyController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Comentário enviado!")),
      );
    }
  }

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
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
              userName: widget.userName,
              userLogin: widget.userLogin,
              postContent: widget.postContent,
            ),
          ),

          const Divider(),

          Expanded(
            child: _replies.isEmpty
                ? const Center(child: Text("Nenhuma resposta ainda"))
                : ListView.builder(
                    itemCount: _replies.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            _replies[index],
                            style: const TextStyle(fontSize: 16),
                          ),
                        ),
                      );
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
