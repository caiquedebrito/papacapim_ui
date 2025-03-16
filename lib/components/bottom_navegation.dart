import 'package:flutter/material.dart';
import '../screens/feed_screen.dart';
import '../screens/search_screen.dart';
import '../screens/new_post_screen.dart';
import '../screens/my_profile_screen.dart';

class BottomNavigation extends StatelessWidget {
  final int currentIndex;

  const BottomNavigation({Key? key, required this.currentIndex})
      : super(key: key);

  void _onItemTapped(BuildContext context, int index) {
    if (index == currentIndex) return; // Evita recarregar a mesma tela

    Widget destination;
    switch (index) {
      case 0:
        destination = const FeedScreen();
        break;
      case 1:
        destination = const SearchScreen();
        break;
      case 2:
        destination = const NewPostScreen();
        break;
      case 3:
        destination = const MyProfileScreen();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor:
          Color(0xFF252525), // Define a cor de fundo do BottomNavigationBar
      selectedItemColor: Color(0xFFD8FF6F), // Cor do item selecionado
      unselectedItemColor: Color(0xFF252525), // Cor dos itens não selecionados
      showSelectedLabels: true, // Exibir rótulo do item selecionado
      showUnselectedLabels: false, // Esconder rótulo dos itens não selecionados
      elevation: 10, // Adiciona sombra para destacar o menu
      items: const [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Feed",
            backgroundColor: Colors.black),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Buscar"),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline), label: "Postar"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Perfil"),
      ],
    );
  }
}
