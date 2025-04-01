import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim_ui/constants/app_colors.dart';
<<<<<<< HEAD
import '../states/global_state.dart';
import 'package:go_router/go_router.dart';
=======
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
>>>>>>> api_login

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('auth_token');

    if (token != null) {
      // Se o token existir, vai direto para o FeedScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => FeedScreen()),
      );
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

<<<<<<< HEAD
    final url = Uri.parse("https://api.papacapim.just.pro.br/sessions");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "login": _loginController.text,
          "password": _passwordController.text,
        }),
      );

      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final session = Session.fromJson(data);
        GlobalSession().session = session;

        setState(() {
          _isLoading = false;
        });

        context.go('/feed');
      } else {
        setState(() {
          _isLoading = false;
        });

        final Map<String, dynamic> body = jsonDecode(response.body);
        final errorMsg = body["message"] ?? "Erro ao efetuar login";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMsg)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }

    setState(() {
      _isLoading = false;
    });
=======
    final String apiUrl =
        "https://api.papacapim.just.pro.br/sessions"; // Substitua pela URL correta
    final Map<String, dynamic> requestBody = {
      "login": _loginController.text,
      "password": _passwordController.text,
    };

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String token = responseData['token'];

        // 🔹 Armazena o token de forma segura para manter a sessão ativa
        await _saveToken(token);

        // 🔹 Navega para a tela de Feed após o login bem-sucedido
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => FeedScreen()),
        );
      } else {
        _showErrorMessage("Login falhou! Verifique suas credenciais.");
      }
    } catch (e) {
      _showErrorMessage("Erro ao conectar com o servidor.");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
>>>>>>> api_login
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(color: AppColors.black),
          Positioned(
            top: -150,
            left: -180,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.green.withOpacity(0.5),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
          Positioned(
            bottom: -150,
            right: -180,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(colors: [
                  AppColors.green.withOpacity(0.5),
                  Colors.transparent,
                ]),
              ),
            ),
          ),
<<<<<<< HEAD
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Papa',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 64,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Text(
                        'Capim',
                        style: TextStyle(
                          color: AppColors.green,
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 50),
                  const Text(
                    'Bem-vindo à primeira rede social da Bahia!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 50),
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
                  const SizedBox(height: 30),
                  _isLoading 
                    ? CircularProgressIndicator(color: Theme.of(context).colorScheme.secondary)
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
                          onPressed: _handleLogin,
                          child: const Text(
                            'Entrar',
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
                          context.go('/cadastro');
                        },
                        child: Text(
                          'Novo no Papacapim? Registrar',
                          style: TextStyle(
                            color: AppColors.green.withOpacity(0.9),
                            fontSize: 14,
=======
          SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Papa',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 64,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        Text(
                          'Capim',
                          style: TextStyle(
                            color: AppColors.green,
                            fontSize: 64,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Text(
                      'Bem-vindo à primeira rede social da Bahia!',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 50),
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
                              onPressed: _handleLogin,
                              child: const Text(
                                'Entrar',
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
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CadastroScreen(),
                              ),
                            );
                          },
                          child: Text(
                            'Novo no Papacapim? Registrar',
                            style: TextStyle(
                              color: AppColors.green.withOpacity(0.9),
                              fontSize: 14,
                            ),
>>>>>>> api_login
                          ),
                        ),
                      ),
                    ),
<<<<<<< HEAD
                  ),
                ],
              ),
            ),
          )
=======
                  ],
                ),
              )),
>>>>>>> api_login
        ],
      ),
    );
  }
}
