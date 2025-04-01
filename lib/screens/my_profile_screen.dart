import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papacapim_ui/components/follower_card.dart';
import 'package:papacapim_ui/components/logout_button.dart';
import 'package:papacapim_ui/components/post_card.dart';
import 'package:papacapim_ui/states/global_state.dart';
import 'edit_profile_screen.dart';
import '../components/bottom_navegation.dart';
import 'package:http/http.dart' as http;

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<MyProfileScreen> {
  bool _isLoading = true;
  Map<String, dynamic> _userData = {};
  List<Map<String, String>> _userPosts = [];
  List<Map<String, String>> _followers = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
      _userData = {
        "name": "João Silva",
        "login": "joaosilva",
        "followers": 120,
        "following": 80,
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
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _userData["name"] ?? "",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "@${_userData["login"]}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const EditProfileScreen()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).colorScheme.secondary,
                              ),
                              child: const Text("Editar Perfil"),
                            ),
                            const LogoutButton(),
                          ],
                        )
                      ],
                    ),
                  ),
                  // TabBar para alternar entre postagens e seguidores
                  const TabBar(
                    indicatorColor: Color(0xFFD8FF6F),
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: "Postagens"),
                      Tab(text: "Seguidores"),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
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
                                    showDeleteButton: true,
                                    showFollowerButton: false,
                                  );
                                },
                              ),
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
      bottomNavigationBar: const BottomNavigation(currentIndex: 3),
    );
  }
}