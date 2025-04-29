
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:papacapim_ui/routing/routes.dart';
import 'package:papacapim_ui/screens/cadastro_screen.dart';
import 'package:papacapim_ui/screens/edit_profile_screen.dart';
import 'package:papacapim_ui/screens/feed_screen.dart';
import 'package:papacapim_ui/screens/login_screen.dart';
import 'package:papacapim_ui/screens/my_profile_screen.dart';
import 'package:papacapim_ui/screens/new_post_screen.dart';
import 'package:papacapim_ui/screens/profile_screen.dart';
import 'package:papacapim_ui/screens/replies_screen.dart';
import 'package:papacapim_ui/screens/search_screen.dart';
import 'package:papacapim_ui/states/global_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

GoRouter router() => GoRouter(
  initialLocation: Routes.login,
  redirect: _redirect,
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
    GoRoute(
      path: Routes.feed,
      builder: (context, state) {
        return const FeedScreen();
      }
    ),
    GoRoute(
      path: Routes.my_profile,
      builder: (context, state) {
        return const MyProfileScreen();
      }
    ),
    GoRoute(
      path: Routes.my_profile_edit,
      builder: (context, state) {
        return const EditProfileScreen();
      }
    ),
    GoRoute(
      path: Routes.new_post,
      builder: (context, state) {
        return const NewPostScreen();
      }
    ),
    GoRoute(
      path: '/replies',
      builder: (context, state) {
        final args = state.extra as Map<String, String>;
        return RepliesScreen(
          postId: args['postId']!,
          userName: args['userName']!,
          userLogin: args['userLogin']!,
          postContent: args['postContent']!,
        );
      },
    ),
    GoRoute(
      path: Routes.search,
      builder: (context, state) {
        return const SearchScreen();
      }
    ),
    GoRoute(
      path: Routes.profile,
      builder: (context, state) {
        return const ProfileScreen();
      },
    )
  ]
);

Future<String?> _redirect(BuildContext context, GoRouterState state) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    String sessionString = prefs.getString('session') ?? '';

    if (sessionString.isEmpty) {
      return '/login';
    }

    Session session = Session.fromJson(jsonDecode(sessionString));
    GlobalSession().session = session;
    
    final bool loggingIn = state.uri.toString() == '/login' || state.uri.toString() == '/cadastro';

    if (loggingIn) {
      return '/feed';
    }

  } catch (e) {
    return '/login';
  }
  
  return null;
}