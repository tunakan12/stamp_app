import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import 'auth_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key, required this.authController});

  final AuthController authController;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 800), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(
        context,
        widget.authController.isLoggedIn ? AppRoutes.home : AppRoutes.login,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.stars_rounded, size: 72),
            SizedBox(height: 12),
            Text('Stamp App', style: TextStyle(fontSize: 24)),
          ],
        ),
      ),
    );
  }
}
