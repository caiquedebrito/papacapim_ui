import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papacapim_ui/states/global_state.dart';
import 'package:papacapim_ui/states/user_state.dart';
import 'package:http/http.dart' as http;

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final user = UserState().user;
      setState(() {
        _nameController.text = user?.name ?? "";
        _loginController.text = user?.login ?? "";
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao carregar dados do usuário")),
      );
    }
  }

  Future<void> _saveChanges() async {
    if (_passwordController.text.isNotEmpty &&
        _passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("As senhas não coincidem")),
      );
      return;
    }

    Map<String, dynamic> userData = {};
    if (_loginController.text.isNotEmpty) {
      userData["login"] = _loginController.text;
    }
    if (_nameController.text.isNotEmpty) {
      userData["name"] = _nameController.text;
    }
    if (_passwordController.text.isNotEmpty) {
      userData["password"] = _passwordController.text;
      userData["password_confirmation"] = _confirmPasswordController.text;
    }

    if (userData.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nenhuma alteração realizada")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = UserState().user?.id;
      if (userId == null) {
        throw Exception("Usuário não encontrado");
      }

      final url = Uri.parse("https://api.papacapim.just.pro.br/users/$userId");
      final response = await http.patch(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user": userData}),
      );

      if (response.statusCode == 200) {
        if (_passwordController.text.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Senha alterada. Faça login novamente.")),
          );
          GlobalSession().logout();
          context.go('/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Perfil atualizado com sucesso!")),
          );
          Navigator.pop(context);
        }
      } else {
        final body = jsonDecode(response.body);
        final errorMsg = body["message"] ?? "Erro ao atualizar perfil";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _deleteUser() async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Excluir Conta"),
      content: const Text(
        "Tem certeza que deseja excluir sua conta? Essa ação não poderá ser desfeita.",
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text("Cancelar"),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text("Excluir", style: TextStyle(color: Colors.red)),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    setState(() {
      _isLoading = true;
    });

    try {
      final userId = UserState().user?.id;
      if (userId == null) {
        throw Exception("Usuário não encontrado");
      }

      final url = Uri.parse("https://api.papacapim.just.pro.br/users/$userId");

      final response = await http.delete(
        url,
        headers: {
          "x-session-token": GlobalSession().session?.token ?? '',
        },
      );

      if (response.statusCode == 204) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Usuário excluído com sucesso.")),
        );
        GlobalSession().logout();
        UserState().user = null;
        context.go('/login');
      } else {
        final body = jsonDecode(response.body);
        final errorMsg = body["message"] ?? "Erro ao excluir conta";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Perfil"),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            child: Column(
              children: [
                // Avatar do usuário
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  child: const Icon(Icons.person, size: 40, color: Colors.white),
                ),
                const SizedBox(height: 20),
                // Campo Nome
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Nome",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Login
                TextField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: "Login",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Nova Senha
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Nova Senha",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                // Campo Confirmar Senha
                TextField(
                  controller: _confirmPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Confirmar Senha",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                // Botões de ação
                _isLoading
                    ? const CircularProgressIndicator()
                    : Column(
                        children: [
                          // Botão para salvar alterações
                          ElevatedButton(
                            onPressed: _saveChanges,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Theme.of(context).colorScheme.secondary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Salvar Alterações"),
                          ),
                          const SizedBox(height: 12),
                          // Botão para excluir a conta
                          OutlinedButton(
                            onPressed: _deleteUser,
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              side: const BorderSide(color: Colors.red),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text("Excluir Conta", style: TextStyle(color: Colors.red)),
                          ),
                        ],
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
