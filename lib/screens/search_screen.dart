import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:papacapim_ui/screens/profile_screen.dart';
import 'package:papacapim_ui/states/global_state.dart';
import '../components/bottom_navegation.dart';
import '../constants/app_colors.dart';
import '../models/user.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<User> _users = [];
  bool _isLoading = false;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _loadUsers(); // carrega todos na inicialização
  }

  Future<void> _loadUsers({String search = ''}) async {
    setState(() {
      _isLoading = true;
      _error = '';
    });

    final token = GlobalSession().session?.token ?? '';
    final uri = Uri.parse('https://api.papacapim.just.pro.br/users')
        .replace(queryParameters: {
      'search': search,
      'page': '1',
    });

    try {
      final resp = await http.get(
        uri,
        headers: {
          'x-session-token': token,
          'Content-Type': 'application/json',
        },
      );

      if (resp.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(resp.body);
        setState(() {
          _users = jsonList.map((e) => User.fromJson(e)).toList();
        });
      } else {
        setState(() => _error = 'Erro ${resp.statusCode} ao buscar usuários.');
      }
    } catch (e) {
      setState(() => _error = 'Falha de conexão: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onSubmitted: (value) => _loadUsers(search: value),
              decoration: InputDecoration(
                hintText: "Digite o nome ou @usuário...",
                border: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey, width: 2.0),
                ),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadUsers(); // recarrega todos
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error.isNotEmpty)
            Expanded(child: Center(child: Text(_error, style: const TextStyle(color: Colors.white))))
          else if (_users.isEmpty)
            const Expanded(child: Center(child: Text("Nenhum usuário encontrado", style: TextStyle(color: Colors.white))))
          else
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, i) {
                  final u = _users[i];
                  return ListTile(
                    title: Text(u.name, style: const TextStyle(color: Colors.white)),
                    subtitle: Text("@${u.login}",
                        style: const TextStyle(
                            color: Color.fromARGB(171, 255, 255, 255), fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward, color: Color(0xFFD8FF6F)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProfileScreen(),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: const BottomNavigation(currentIndex: 1),
    );
  }
}
