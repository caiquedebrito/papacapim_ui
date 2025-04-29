import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:papacapim_ui/states/global_state.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      final url = Uri.parse(
        'https://api.papacapim.just.pro.br/sessions/${GlobalSession().session?.id}',
      );

      await http.delete(
        url,
        headers: {
          'x-session-token': GlobalSession().session?.token ?? '',
        },
      );

      await GlobalSession().logout();
      context.go('/login');
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Erro ao efetuar logout")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => _logout(context),
      icon: Icon(
        Icons.logout,
        color: Theme.of(context).colorScheme.secondary,
      ),
    );
  }
}
