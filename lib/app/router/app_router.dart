import 'package:flutter/material.dart';

import '../../features/auth/presentation/auth_controller.dart';
import '../../features/auth/presentation/login_page.dart';
import '../../features/auth/presentation/splash_page.dart';
import '../../features/notifications/notification_page.dart';
import '../../features/notifications/notification_repository.dart';
import '../../features/profile/profile_page.dart';
import '../../features/profile/profile_repository.dart';
import '../../features/rewards/reward_page.dart';
import '../../features/rewards/reward_repository.dart';
import '../../features/stamp/presentation/home_page.dart';
import '../../features/stamp/presentation/stamp_controller.dart';
import '../../features/stamp/presentation/stamp_history_page.dart';
import '../../features/stamp/presentation/stamp_scan_page.dart';
import '../../features/store/store_page.dart';
import '../../features/store/store_repository.dart';

class AppRoutes {
  static const splash = '/';
  static const login = '/login';
  static const home = '/home';
  static const scan = '/scan';
  static const history = '/history';
  static const rewards = '/rewards';
  static const stores = '/stores';
  static const profile = '/profile';
  static const notifications = '/notifications';
}

class AppRouter {
  static Route<dynamic> generateRoute(
    RouteSettings settings, {
    required AuthController authController,
    required StampController stampController,
    required RewardRepository rewardRepository,
    required StoreRepository storeRepository,
    required ProfileRepository profileRepository,
    required NotificationRepository notificationRepository,
  }) {
    switch (settings.name) {
      case AppRoutes.splash:
        return MaterialPageRoute(
          builder: (_) => SplashPage(authController: authController),
        );
      case AppRoutes.login:
        return MaterialPageRoute(
          builder: (_) => LoginPage(authController: authController),
        );
      case AppRoutes.home:
        return MaterialPageRoute(
          builder: (_) => HomePage(
            authController: authController,
            stampController: stampController,
          ),
        );
      case AppRoutes.scan:
        return MaterialPageRoute(
          builder: (_) => StampScanPage(
            authController: authController,
            stampController: stampController,
          ),
        );
      case AppRoutes.history:
        return MaterialPageRoute(
          builder: (_) => StampHistoryPage(
            authController: authController,
            stampController: stampController,
          ),
        );
      case AppRoutes.rewards:
        return MaterialPageRoute(
          builder: (_) => RewardPage(
            authController: authController,
            stampController: stampController,
            rewardRepository: rewardRepository,
          ),
        );
      case AppRoutes.stores:
        return MaterialPageRoute(
          builder: (_) => StorePage(storeRepository: storeRepository),
        );
      case AppRoutes.profile:
        return MaterialPageRoute(
          builder: (_) => ProfilePage(
            authController: authController,
            profileRepository: profileRepository,
          ),
        );
      case AppRoutes.notifications:
        return MaterialPageRoute(
          builder: (_) => NotificationPage(
            authController: authController,
            notificationRepository: notificationRepository,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
