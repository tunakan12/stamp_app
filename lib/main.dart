import 'package:flutter/material.dart';

import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'features/auth/data/auth_repository_impl.dart';
import 'features/auth/presentation/auth_controller.dart';
import 'features/notifications/notification_repository.dart';
import 'features/profile/profile_repository.dart';
import 'features/rewards/reward_repository.dart';
import 'features/stamp/data/stamp_repository_impl.dart';
import 'features/stamp/presentation/stamp_controller.dart';
import 'features/store/store_repository.dart';
import 'shared/services/in_memory_database.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  final db = InMemoryDatabase.seeded();
  final authRepository = AuthRepositoryImpl(db);
  final stampRepository = StampRepositoryImpl(db);
  final rewardRepository = RewardRepository(db);
  final storeRepository = StoreRepository(db);
  final profileRepository = ProfileRepository(db);
  final notificationRepository = NotificationRepository(db);

  runApp(
    StampApp(
      authController: AuthController(authRepository),
      stampController: StampController(
        stampRepository,
        rewardRepository,
        storeRepository,
        notificationRepository,
      ),
      rewardRepository: rewardRepository,
      storeRepository: storeRepository,
      profileRepository: profileRepository,
      notificationRepository: notificationRepository,
    ),
  );
}

class StampApp extends StatelessWidget {
  const StampApp({
    super.key,
    required this.authController,
    required this.stampController,
    required this.rewardRepository,
    required this.storeRepository,
    required this.profileRepository,
    required this.notificationRepository,
  });

  final AuthController authController;
  final StampController stampController;
  final RewardRepository rewardRepository;
  final StoreRepository storeRepository;
  final ProfileRepository profileRepository;
  final NotificationRepository notificationRepository;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([authController, stampController]),
      builder: (context, _) {
        return MaterialApp(
          title: 'Stamp App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: (settings) => AppRouter.generateRoute(
            settings,
            authController: authController,
            stampController: stampController,
            rewardRepository: rewardRepository,
            storeRepository: storeRepository,
            profileRepository: profileRepository,
            notificationRepository: notificationRepository,
          ),
        );
      },
    );
  }
}
