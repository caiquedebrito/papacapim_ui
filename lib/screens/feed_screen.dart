import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim_ui/states/global_state.dart';

import '../components/bottom_navegation.dart';
import '../components/post_card.dart';
import '../models/post.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  late Future<List<Post>> _myFeedFuture;
  late Future<List<Post>> _followingFuture;

  @override
  void initState() {
    super.initState();
    _myFeedFuture = fetchPosts(feed: 0);
    _followingFuture = fetchPosts(feed: 1);
  }

  Future<List<Post>> fetchPosts({required int feed, int page = 1}) async {
    final token = GlobalSession().session?.token ?? '';
    final uri = Uri.parse('https://api.papacapim.just.pro.br/posts')
        .replace(queryParameters: {
      'feed': feed.toString(),
      'page': page.toString(),
    });

    final response = await http.get(
      uri,
      headers: {
        'x-session-token': token,
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((e) => Post.fromJson(e)).toList();
    } else {
      throw Exception('Falha ao carregar posts (status ${response.statusCode})');
    }
  }

  Widget _buildPostList(Future<List<Post>> future, {bool showFollowerButton = true}) {
    return FutureBuilder<List<Post>>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Erro: ${snapshot.error}'));
        }
        final posts = snapshot.data!;
        if (posts.isEmpty) {
          return const Center(child: Text('Nenhuma postagem encontrada.'));
        }
        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, i) {
            final p = posts[i];
            return PostCard(
              userName: '@${p.userLogin}',      // se você tiver o nome real, troque aqui
              userLogin: p.userLogin,
              postContent: p.message,
              onLike: () => print('Curtir post ${p.id}'),
              onComment: () => print('Comentar post ${p.id}'),
              showFollowerButton: showFollowerButton,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          automaticallyImplyLeading: false,
          title: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Papa',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFFD8FF6F),
                  ),
                ),
                TextSpan(
                  text: 'Capim',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD8FF6F),
                  ),
                ),
              ],
            ),
          ),
          bottom: const PreferredSize(
            preferredSize: Size.fromHeight(50),
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
              child: TabBar(
                indicatorColor: Color(0xFFD8FF6F),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                tabs: [
                  Tab(text: 'Meu Feed'),
                  Tab(text: 'Seguindo'),
                ],
              ),
            ),
          ),
        ),
        backgroundColor: const Color(0xFF252525),
        body: TabBarView(
          children: [
            // Minha aba “Meu Feed”
            _buildPostList(_myFeedFuture),
            // Minha aba “Seguindo” (oculta botão “Seguir”)
            _buildPostList(_followingFuture, showFollowerButton: false),
          ],
        ),
        bottomNavigationBar: const BottomNavigation(currentIndex: 0),
      ),
    );
  }
}
