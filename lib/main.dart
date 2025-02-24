import 'package:flutter/material.dart';
import 'package:papacapim_ui/screens/login_screen.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Papacapim App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Tela de login conectada como tela inicial.
    );
  }
}