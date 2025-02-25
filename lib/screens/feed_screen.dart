import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/post_card.dart';
import '../components/bottom_navegation.dart'; // Importação da navegação reutilizável

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemplos de posts para cada aba
    final List<Map<String, String>> myFeedPosts = [
      {"userName": "João Silva", "userLogin": "joaosilva", "content": "Bem-vindo ao meu feed!"},
      {"userName": "João Silva", "userLogin": "joaosilva", "content": "Mais um post no meu feed..."},
    ];

    final List<Map<String, String>> followingPosts = [
      {"userName": "Maria Oliveira", "userLogin": "maria_oliveira", "content": "Curtindo essa rede!"},
      {"userName": "Carlos Souza", "userLogin": "carlossouza", "content": "Segue mais um post por aqui."},
    ];

    return DefaultTabController(
      length: 2, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Papacapim Feed"),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Meu Feed"),
              Tab(text: "Seguindo"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // ABA "Meu Feed"
            ListView.builder(
              itemCount: myFeedPosts.length,
              itemBuilder: (context, index) {
                final post = myFeedPosts[index];
                return PostCard(
                  userName: post["userName"]!,
                  userLogin: post["userLogin"]!,
                  postContent: post["content"]!,
                  onLike: () => print("Curtir ${post["content"]}"),
                  onComment: () => print("Comentar em ${post["content"]}"),
                );
              },
            ),

            // ABA "Seguindo"
            ListView.builder(
              itemCount: followingPosts.length,
              itemBuilder: (context, index) {
                final post = followingPosts[index];
                return PostCard(
                  userName: post["userName"]!,
                  userLogin: post["userLogin"]!,
                  postContent: post["content"]!,
                  onLike: () => print("Curtir ${post["content"]}"),
                  onComment: () => print("Comentar em ${post["content"]}"),
                  showFollowerButton: false,
                );
              },
            ),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      ),
    );
  }
}