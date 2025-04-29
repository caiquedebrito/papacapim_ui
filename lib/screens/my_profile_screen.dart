import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim_ui/components/follower_card.dart';
import 'package:papacapim_ui/components/logout_button.dart';
import 'package:papacapim_ui/components/post_card.dart';
import 'package:papacapim_ui/states/global_state.dart';
import 'package:papacapim_ui/states/user_state.dart';
import 'edit_profile_screen.dart';
import '../components/bottom_navegation.dart';

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
    try {
      setState(() {
        _isLoading = true;
      });

      var url = Uri.parse("https://api.papacapim.just.pro.br/users/${GlobalSession().session?.userLogin}");

      final response = await http.get(
        url,
        headers: {"x-session-token": GlobalSession().session?.token ?? ""},
      );

      if (response.statusCode != 200) {
        throw Exception("Erro ao carregar dados do usuário");
      }

      final data = jsonDecode(response.body); 
      
      Map<String, dynamic> userData = {
        "user_id": GlobalSession().session?.userId,
        "name": data["name"],
        "login": data["login"],
        "created_at": data["created_at"],
        "updated_at": data["updated_at"],
      };

      final user = User.fromJson(userData);
      UserState().user = user;

      setState(() {
        _userData = userData;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar dados do usuário")),
      );
    }
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
                                    postId: index.toString(),
                                    userLogin: post["userLogin"]!,
                                    postContent: post["content"]!,
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
                                  return FollowerCard(userLogin: follower["login"]!);
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