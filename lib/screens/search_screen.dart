import 'dart:async'; // <- import necessário
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
  Timer? _debounce; // <- timer para debounce

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
    final uri = Uri.parse('https://api.papacapim.just.pro.br/users/$search')
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

      print('Status: ${resp.statusCode}');
      print('Body: ${resp.body}');

      if (resp.statusCode == 200) {
        final decoded = jsonDecode(resp.body);
        print('Decoded: $decoded');

        List<dynamic> jsonList = [];

        if (decoded is List) {
          jsonList = decoded;
        } else if (decoded is Map<String, dynamic>) {
          print('Decoded map: $decoded');
          jsonList = decoded['data'] ?? [];
        }

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

  void _onSearchChanged(String query) {
    // sempre que digitar, cancela o timer anterior
    if (_debounce?.isActive ?? false) _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _loadUsers(search: query.trim());
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
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
              onChanged: _onSearchChanged, // <-- chama ao digitar
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
                          _loadUsers(); // recarrega todos sem filtro
                        },
                      )
                    : null,
              ),
            ),
          ),
          if (_isLoading)
            const Expanded(child: Center(child: CircularProgressIndicator()))
          else if (_error.isNotEmpty)
            Expanded(
              child: Center(
                child: Text(
                  _error,
                  style: const TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          else if (_users.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  "Nenhum usuário encontrado",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _users.length,
                itemBuilder: (context, i) {
                  final u = _users[i];
                  return ListTile(
                    title: Text(u.name,
                        style: const TextStyle(color: Colors.white)),
                    subtitle: Text("@${u.login}",
                        style: const TextStyle(
                            color: Color.fromARGB(171, 255, 255, 255),
                            fontSize: 12)),
                    trailing: const Icon(Icons.arrow_forward,
                        color: Color(0xFFD8FF6F)),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              const ProfileScreen(), // lembre de colocar const
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
