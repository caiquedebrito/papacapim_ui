
import 'package:go_router/go_router.dart';
import 'package:papacapim_ui/routing/routes.dart';
import 'package:papacapim_ui/screens/cadastro_screen.dart';
import 'package:papacapim_ui/screens/login_screen.dart';

GoRouter router() => GoRouter(
  routes: [
    GoRoute(
      path: Routes.login,
      builder: (context, state) {
        return const LoginScreen();
      }
    ),
    GoRoute(
      path: Routes.cadastro,
      builder: (context, state) {
        return const CadastroScreen();
      }
    ),
    
  ]
);