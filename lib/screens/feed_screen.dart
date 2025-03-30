import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/post_card.dart';
import '../components/bottom_navegation.dart'; // Importação da navegação reutilizável

class FeedScreen extends StatelessWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Exemplos de posts para cada aba
    final List<Map<String, String>> myFeedPosts = [
      {
        "userName": "João Silva",
        "userLogin": "joaosilva",
        "content": "Bem-vindo ao meu feed!"
      },
      {
        "userName": "João Silva",
        "userLogin": "joaosilva",
        "content": "Mais um post no meu feed..."
      },
    ];

    final List<Map<String, String>> followingPosts = [
      {
        "userName": "Maria Oliveira",
        "userLogin": "maria_oliveira",
        "content": "Curtindo essa rede!"
      },
      {
        "userName": "Carlos Souza",
        "userLogin": "carlossouza",
        "content": "Segue mais um post por aqui."
      },
    ];

    return DefaultTabController(
      length: 2, // Número de abas
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          title: const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Papa",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFFD8FF6F),
                    ),
                  ),
                  Text(
                    "Capim",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD8FF6F),
                    ),
                  ),
                ],
              ),
            ],
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              child: TabBar(
                indicatorColor: Color(0xFFD8FF6F),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: "Meu Feed"),
                  Tab(text: "Seguindo"),
                ],
              ),
            ),
          ),
        ),
        body: Container(
          color: const Color(0xFF252525),
          child: TabBarView(
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
        ),
        bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      ),
    );
  }
}
