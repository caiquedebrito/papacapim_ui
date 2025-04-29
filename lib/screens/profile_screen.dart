import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/follower_card.dart';
import 'package:papacapim_ui/components/post_card.dart';
import 'package:papacapim_ui/models/user.dart';
import 'package:papacapim_ui/states/global_state.dart';
import 'package:http/http.dart' as http;

class ProfileScreen extends StatefulWidget {
  final String? userLogin;
  final User? userData;

  const ProfileScreen({Key? key, this.userLogin, this.userData }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isLoading = true;
  List<Map<String, String>> _userPosts = [];
  List<Map<String, String>> _followers = [];

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<User> _loadProfile() async {
    final token = GlobalSession().session?.token ?? "";
    print(widget.userLogin);
    final url = Uri.parse('https://api.papacapim.just.pro.br/users/${widget.userLogin}');
    
    try {
      final response = await http.delete(
        url,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return User.fromJson(data);
      } else {
        throw Exception('Falha ao carregar perfil (status ${response.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
      throw Exception("Falha ao carregar perfil");
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
      appBar: AppBar(
        title: const Text("Perfil"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary,))
          : DefaultTabController(
              length: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Cabeçalho com informações do usuário
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userData?.name ?? "",
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "@${widget.userData?.login}}",
                          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 8,),
                        Text("Desde ${widget.userData?.createdAt}"),
                        const SizedBox(height: 16,),
                        Text(
                          "${_followers.length} seguidores",
                        ),
                        const SizedBox(height: 8,),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.secondary,
                          ),
                          child: const Text("Seguir"),
                        ),
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
                        // Aba de Postagens do Usuário
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