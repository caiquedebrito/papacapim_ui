import 'package:flutter/material.dart';
import 'package:papacapim_ui/constants/app_colors.dart';
import 'package:papacapim_ui/screens/login_screen.dart';

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
        colorScheme: ColorScheme.dark(
          primary: AppColors.black,
          secondary: AppColors.green,
        ),
      ),
      home: const LoginScreen(),
    );
  }
}