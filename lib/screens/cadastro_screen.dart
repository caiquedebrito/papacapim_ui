import 'package:flutter/material.dart';
import 'package:papacapim_ui/constants/app_colors.dart';

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
  final TextEditingController _passwordConfirmController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _loginController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  Future<void> _handleCadastro() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordController.text != _passwordConfirmController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As senhas não correspondem')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // TODO: Implementar a chamada à API para criação do usuário.
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cadastro realizado com sucesso')),
    );

    // Navega de volta para a tela de login após cadastro
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.black, // Fundo preto
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 120),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título "Papa Capim"
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

              // Mensagem de boas-vindas
              const Text(
                'Bem-vindo à primeira rede social da Bahia!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 50),

              // Campo de Login
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

              // Campo de Nome
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

              // Campo de Senha
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

              // Confirmar Senha
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

              // Botão "Cadastrar"
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
              const SizedBox(height: 16),

              // Link de "Voltar para Login"
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Já possui conta? Voltar para login',
                  style: TextStyle(
                    color: AppColors.green,
                    fontSize: 14,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
