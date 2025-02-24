import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/post_card.dart';
import '../components/bottom_navegation.dart'; // Importação da navegação reutilizável

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  bool _showFollowing = false; // Alterna entre "Meu Feed" e "Seguindo"
  List<Map<String, String>> posts = [
    {"userName": "João Silva", "userLogin": "joaosilva", "content": "Minha primeira postagem!"},
    {"userName": "Maria Oliveira", "userLogin": "maria_oliveira", "content": "Curtindo essa nova rede!"},
    {"userName": "Carlos Souza", "userLogin": "carlossouza", "content": "O dia está lindo hoje!"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Papacapim Feed"),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implementar ação do perfil do usuário
            },
            icon: const Icon(Icons.account_circle),
          )
        ],
      ),
      body: Column(
        children: [
          // Botões para alternar entre "Meu Feed" e "Seguindo"
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFollowing = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !_showFollowing ? Colors.blue : Colors.grey[300],
                    foregroundColor: !_showFollowing ? Colors.white : Colors.black,
                  ),
                  child: const Text("Meu Feed"),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _showFollowing = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _showFollowing ? Colors.blue : Colors.grey[300],
                    foregroundColor: _showFollowing ? Colors.white : Colors.black,
                  ),
                  child: const Text("Seguindo"),
                ),
              ],
            ),
          ),

          // Campo de pesquisa e botão de seguir usuário
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Usuário nome",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 10.0),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Implementar funcionalidade de seguir usuário
                  },
                  child: const Text("Seguir"),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Lista de postagens
          Expanded(
            child: ListView.builder(
              itemCount: posts.length, // TODO: Atualizar com os dados da API
              itemBuilder: (context, index) {
                final post = posts[index];
                return PostCard(
                  userName: post["userName"]!,
                  userLogin: post["userLogin"]!,
                  postContent: post["content"]!,
                  onLike: () => print("Curtir ${post["content"]}"),
                  onComment: () => print("Comentar em ${post["content"]}"),
                );
              },
            ),
          ),
        ],
      ),

      // Barra de navegação inferior
      bottomNavigationBar: const BottomNavigation(currentIndex: 0),
    );
  }
}
