import 'package:flutter/material.dart';
import 'package:papacapim_ui/constants/app_colors.dart';
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
    return Container(
      decoration: BoxDecoration(
      border: Border(
        top: BorderSide(
        color: Colors.grey.shade300,
        width: 1.0,
        ),
      ),
      ),
      child: BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) => _onItemTapped(context, index),
      backgroundColor: Theme.of(context).colorScheme.primary,
      selectedItemColor: AppColors.green,
      unselectedItemColor: Colors.white,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      elevation: 10,
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: "Feed",
          backgroundColor: Theme.of(context).colorScheme.primary),
        BottomNavigationBarItem(
          icon: const Icon(Icons.search),
          label: "Buscar",
          backgroundColor: Theme.of(context).colorScheme.primary),
        BottomNavigationBarItem(
          icon: const Icon(Icons.add_circle_outline),
          label: "Postar",
          backgroundColor: Theme.of(context).colorScheme.primary),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: "Perfil",
          backgroundColor: Theme.of(context).colorScheme.primary),
      ],
      ),
    );
  }
}
