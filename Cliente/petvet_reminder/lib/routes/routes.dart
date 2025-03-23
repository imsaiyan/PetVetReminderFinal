import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petvet_reminder/page/Home.dart';
import 'package:petvet_reminder/page/NotFoundScreen.dart';
import 'package:petvet_reminder/page/assets/Agregar.Mascota.dart';
import 'package:petvet_reminder/page/assets/Notificaciones.dart';
import 'package:petvet_reminder/page/assets/Settings.dart';
import 'package:petvet_reminder/page/assets/Ver.Mascota.dart';
import 'package:petvet_reminder/page/forum_screen.dart';
import 'package:petvet_reminder/page/login_register.dart';
import 'package:petvet_reminder/page/post_screen.dart';

class Routes {
  // Definir el router
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginRegister()),
      GoRoute(path: '/Home', builder: (context, state) => const Home()),
      GoRoute(
        path: '/Settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/Notificaciones',
        builder: (context, state) => const AddListNews(),
      ),
      GoRoute(path: '/forum', builder: (context, state) => const ForumScreen()),
      GoRoute(path: '/post', builder: (context, state) => const PostScreen()),
      GoRoute(
        path: '/ver',
        builder: (context, state) => const VerMascotaScreen(),
      ),
      GoRoute(
        path: '/agregar',
        builder: (context, state) => const AgregarMascotaScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
}
