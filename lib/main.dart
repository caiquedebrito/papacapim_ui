import 'package:flutter/material.dart';
import 'package:papacapim_ui/constants/app_colors.dart';
import 'package:papacapim_ui/screens/login_screen.dart';

// ThemeData appTheme = ThemeData(
//   primaryColor: AppColors.green, // Cor principal (verde)
//   scaffoldBackgroundColor: AppColors.black, // Cor de fundo (preto)
//   textTheme: const TextTheme(
//     bodyLarge: TextStyle(color: Colors.white),
//     bodyMedium: TextStyle(color: Colors.white),
//     titleLarge: TextStyle(color: Colors.white),
//   ),
//   appBarTheme: AppBarTheme(
//     backgroundColor: AppColors.black, // Cor da AppBar (fundo preto)
//     foregroundColor: AppColors.green, // Cor do texto da AppBar (verde)
//     elevation: 0, // Sem sombra
//   ),
//   bottomNavigationBarTheme: BottomNavigationBarThemeData(
//     backgroundColor: AppColors.black, // Cor de fundo do BottomNavigation
//     selectedItemColor: AppColors.green, // Cor do item selecionado (verde)
//     unselectedItemColor: Colors.white, // Cor do item não selecionado
//     showUnselectedLabels: true, // Mostrar rótulos dos itens não selecionados
//     elevation: 8, // Elevação (sombra)
//   ),
//   buttonTheme: ButtonThemeData(
//     buttonColor: AppColors.green, // Cor dos botões
//     textTheme: ButtonTextTheme.primary, // Cor do texto no botão
//   ),
//   visualDensity: VisualDensity.adaptivePlatformDensity,
// );

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