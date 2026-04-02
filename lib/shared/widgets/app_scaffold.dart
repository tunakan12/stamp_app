import 'package:flutter/material.dart';

import '../../app/router/app_router.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.currentIndex = 0,
    this.actions,
    this.floatingActionButton,
  });

  final String title;
  final Widget body;
  final int currentIndex;
  final List<Widget>? actions;
  final Widget? floatingActionButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: SafeArea(child: body),
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          final route = switch (index) {
            0 => AppRoutes.home,
            1 => AppRoutes.rewards,
            2 => AppRoutes.tickets,
            3 => AppRoutes.stores,
            4 => AppRoutes.profile,
            _ => AppRoutes.home,
          };
          if (ModalRoute.of(context)?.settings.name != route) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: 'ホーム'),
          NavigationDestination(icon: Icon(Icons.card_giftcard_outlined), label: '特典'),
          NavigationDestination(icon: Icon(Icons.confirmation_number_outlined), label: 'チケット'),
          NavigationDestination(icon: Icon(Icons.storefront_outlined), label: '店舗'),
          NavigationDestination(icon: Icon(Icons.person_outline), label: 'プロフィール'),
        ],
      ),
    );
  }
}
