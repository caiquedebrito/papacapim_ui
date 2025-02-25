import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/follower_card.dart';
import 'package:papacapim_ui/components/post_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};
  List<Map<String, String>> _userPosts = [];
  List<Map<String, String>> _followers = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Simula o carregamento dos dados do perfil
  Future<void> _loadProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _userData = {
        "name": "João Silva",
        "login": "joaosilva",
        "created_at": "2024",
      };
      _userPosts = [
        {
          "userName": "João Silva",
          "userLogin": "joaosilva",
          "content": "Minha primeira postagem!"
        },
        {
          "userName": "João Silva",
          "userLogin": "joaosilva",
          "content": "Mais um post no meu feed!"
        },
      ];
      _followers = [
        {"name": "Maria Oliveira", "login": "maria_oliveira"},
        {"name": "Carlos Souza", "login": "carlossouza"},
        {"name": "Ana Paula", "login": "anapaula"},
      ];
    });
  }

  // Função para excluir uma postagem
  void _deletePost(int index) {
    setState(() {
      _userPosts.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Postagem excluída com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com informações do usuário
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Text(
                          _userData["name"] ?? "",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${_userData["login"]}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        Text(
                          "${_followers.length} seguidores",
                        ),
                        Text("Desde 2024"),
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text("Seguir"),
                        ),
                      ],
                    ),
                  ),
                  // TabBar para alternar entre postagens e seguidores
                  const TabBar(
                    indicatorColor: Colors.blue,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Postagens"),
                      Tab(text: "Seguidores"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        // Aba de Postagens do Usuário
                        _userPosts.isEmpty
                            ? const Center(child: Text("Nenhuma postagem"))
                            : ListView.builder(
                                itemCount: _userPosts.length,
                                itemBuilder: (context, index) {
                                  final post = _userPosts[index];
                                  return PostCard(
                                    userName: post["userName"]!,
                                    userLogin: post["userLogin"]!,
                                    postContent: post["content"]!,
                                    onDelete: () => _deletePost(index),
                                    showFollowerButton: false,
                                  );
                                },
                              ),
                        // Aba de Seguidores
                        _followers.isEmpty
                            ? const Center(child: Text("Nenhum seguidor"))
                            : ListView.builder(
                                itemCount: _followers.length,
                                itemBuilder: (context, index) {
                                  final follower = _followers[index];
                                  return FollowerCard(userName: follower["name"]!, userLogin: follower["login"]!);
                                },
                              ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
      // bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }
}