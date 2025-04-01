import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:papacapim_ui/constants/app_colors.dart';
import 'package:papacapim_ui/models/CreatedUser.dart';
import 'package:http/http.dart' as http;

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<Createduser> _createUser() async {
    final response = await http.post(
      Uri.parse('https://api.papacapim.just.pro.br/users'),
      headers: {"Content-Type": "application/json"},
      body: json.encode({
        'user': {
          'login': _loginController.text,
          'name': _nameController.text,
          'password': _passwordController.text,
          'password_confirmation': _passwordConfirmController.text
        }
      })
    );

    if (response.statusCode == 422) {
      return throw Exception('Usuário já cadastrado');
    }

    if (response.statusCode != 201) {
      return throw Exception('Erro ao criar usuário');
    }

    print('Response body: ${response.body}');
    return Createduser.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> _handleCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não correspondem')),
      );
      return;
    }

    print('Login: ${_loginController.text}; Name: ${_nameController.text}; Password: ${_passwordController.text}; Password Confirm: ${_passwordConfirmController.text}');

    setState(() {
      _isLoading = true;
    });

    try {
      Createduser user = await _createUser();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Usuário ${user.login} Cadastro realizado com sucesso')),
      );

      setState(() {
        _isLoading = false;
      });

      context.go('/login');
    } catch(error) {
      String e = error.toString();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e)),
      );

      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.black,
                AppColors.green,
              ],
              begin: Alignment.topCenter,
              end: const Alignment(0.0, 15),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Papa',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 44,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Text(
                      'Capim',
                      style: TextStyle(
                        color: AppColors.green,
                        fontSize: 44,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),
                const Text(
                  'Faça parte da primeira rede social da Bahia!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 25),
                TextFormField(
                  controller: _loginController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Login',
                    hintStyle: TextStyle(color: Colors.white54),
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu login';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Nome Completo',
                    hintStyle: TextStyle(color: Colors.white54),
                    icon: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome completo';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Senha',
                    hintStyle: TextStyle(color: Colors.white54),
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordConfirmController,
                  obscureText: true,
                  style: const TextStyle(color: Colors.white),
                  cursorColor: AppColors.green,
                  decoration: const InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    hintText: 'Confirmar Senha',
                    hintStyle: TextStyle(color: Colors.white54),
                    icon: Icon(
                      Icons.lock,
                      color: Colors.white,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, confirme sua senha';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                _isLoading
                    ? const CircularProgressIndicator()
                    : SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: _handleCadastro,
                          child: const Text(
                            'Cadastrar',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                const SizedBox(height: 40),
                Center(
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        context.go('/login');
                      },
                      child: const Text(
                        'Já possui conta? Voltar para login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
      ]),
    );
  }
}
