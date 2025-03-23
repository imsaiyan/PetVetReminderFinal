import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:petvet_reminder/routes/routes.dart';

void main() {
  runApp(MyApp(router: Routes.router));
}

class MyApp extends StatelessWidget {
  final GoRouter router;

  const MyApp({super.key, required this.router});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
