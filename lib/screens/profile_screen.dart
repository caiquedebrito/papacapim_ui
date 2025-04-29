import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:papacapim_ui/components/follow_button.dart';
import 'package:papacapim_ui/components/follower_card.dart';
import 'package:papacapim_ui/components/post_card.dart';
import 'package:papacapim_ui/models/user-profile.dart';
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
  late Future<List<Follower>> _followers;
  bool following = false;
  late Future<UserProfile> userData;

  @override
  void initState() {
    super.initState();
    _isLoading = true;
    userData = _loadProfile();
    _followers = loadFollowers();
    _isLoading = false;
  }

  Future<UserProfile> _loadProfile() async {
    final token = GlobalSession().session?.token ?? "";
    final url = Uri.parse('https://api.papacapim.just.pro.br/users/${widget.userLogin}');
    
    try {
      final response = await http.get(
        url,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return UserProfile.fromJson(data);
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

  Future<List<Follower>> loadFollowers() async {
    final token = GlobalSession().session?.token ?? "";
    final myUserLogin = GlobalSession().session?.userLogin ?? "";
    final url = Uri.parse('https://api.papacapim.just.pro.br/users/${widget.userLogin}/followers');    
    
    try {
      final response = await http.get(
        url,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) {
          final f = Follower.fromJson(json);
          if (f.userLogin == myUserLogin) {
            print("Eu sigo $myUserLogin");
            following = true;
          }
          return f;
        }).toList();
      } else {
        throw Exception('Falha ao carregar seguidores (status ${response.statusCode})');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
      throw Exception("Falha ao carregar perfil");
    }
  }

  Future<void> _togglFollow() async {
    final token = GlobalSession().session?.token ?? "";
    final url = Uri.parse('https://api.papacapim.just.pro.br/users/${widget.userLogin}/followers');
    final deleteUrl = Uri.parse('${url.toString()}/1');

    try {
      final response = following
        ? await http.delete(deleteUrl, headers: {
            'x-session-token': token,
            'Content-Type': 'application/json',
          })
        : await http.post(url, headers: {
            'x-session-token': token,
            'Content-Type': 'application/json',
          });

      final success = (following && response.statusCode == 204) ||
      (!following && response.statusCode == 201);

      if (!success) {
        throw Exception(
          following
            ? 'Falha ao dar unfollowing (status ${response.statusCode})'
            : 'Falha ao seguir usuário (status ${response.statusCode})'
        );
      }

      setState(() {
        following = !following;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
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
                    child: FutureBuilder<UserProfile>(
                      future: userData,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator());
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              snapshot.data!.login ?? "",
                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "@${snapshot.data!.login}",
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                            const SizedBox(height: 8,),
                            Text("Desde ${snapshot.data!.createdAt}"),
                            const SizedBox(height: 16,),
                            Text(
                              " seguidores",
                            ),
                            const SizedBox(height: 8,),
                            FollowButton(following: following, onTap: _togglFollow)
                          ],
                        );
                      },
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
                        FutureBuilder<List<Follower>>(
                          future: _followers,
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(child: CircularProgressIndicator());
                            } else if (snapshot.data!.isEmpty) {
                              return const Center(child: Text("Nenhum seguidor"));
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  final follower = snapshot.data![index];
                                  return FollowerCard(userLogin: follower.userLogin);
                                },
                              );
                            }
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


class Follower {
  final int id;
  final String userLogin;
  final String createdAt;
  final String updatedAt;

  Follower({
    required this.id,
    required this.userLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Follower.fromJson(Map<String, dynamic> json) {
    return Follower(
      id: json['follower_id'],
      userLogin: json['follower_login'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }
}