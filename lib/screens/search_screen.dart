import 'package:flutter/material.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';
import '../components/bottom_navegation.dart'; // Importação da navegação reutilizável
import '../constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _allUsers = []; // Lista de todos os usuários
  List<Map<String, String>> _filteredUsers = []; // Lista filtrada

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  // Simula o carregamento dos usuários
  Future<void> _loadUsers() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _allUsers = [
        {"name": "João Silva", "login": "joaosilva"},
        {"name": "Maria Oliveira", "login": "maria_oliveira"},
        {"name": "Carlos Souza", "login": "carlossouza"},
        {"name": "Ana Paula", "login": "anapaula"},
        {"name": "Lucas Ferreira", "login": "lucasf"},
      ];
      _filteredUsers = List.from(_allUsers); // Começa com todos os usuários
    });
  }

  // Filtra os usuários conforme a pesquisa
  void _filterUsers(String query) {
    setState(() {
      _filteredUsers = _allUsers
          .where((user) =>
              user["name"]!.toLowerCase().contains(query.toLowerCase()) ||
              user["login"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
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
              onChanged: _filterUsers,
              decoration: const InputDecoration(
                hintText: "Digite o nome ou @usuário...",
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey,
                    width: 2.0,
                  ),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(child: Text("Nenhum usuário encontrado"))
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];
                      return ListTile(
                        title: Text(user["name"]!,
                            style: const TextStyle(color: Colors.white)),
                        subtitle: Text("@${user["login"]}",
                            style: const TextStyle(
                                color: Color.fromARGB(171, 255, 255, 255),
                                fontSize: 12)),
                        trailing: const Icon(Icons.arrow_forward,
                            color: Color(0xFFD8FF6F)),
                        onTap: () {
                          // TODO: Implementar a navegação para o perfil do usuário
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ProfileScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),

      bottomNavigationBar: const BottomNavigation(
          currentIndex: 1),
    );
  }
}
