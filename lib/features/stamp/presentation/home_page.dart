import 'package:flutter/material.dart';

import '../../../app/constants/app_spacing.dart';
import '../../../app/router/app_router.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/section_card.dart';
import '../../auth/presentation/auth_controller.dart';
import '../../rewards/reward_repository.dart';
import 'stamp_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
    required this.authController,
    required this.stampController,
  });

  final AuthController authController;
  final StampController stampController;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _rewardRepository = RewardRepository.global;

  @override
  void initState() {
    super.initState();
    final userId = widget.authController.currentUser?.id;
    if (userId != null) {
      widget.stampController.load(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.authController.currentUser;
    return AnimatedBuilder(
      animation: widget.stampController,
      builder: (context, _) {
        final rewards = _rewardRepository.fetchAllSync();
        final remaining = widget.stampController.remainingUntilNextReward(rewards);
        return AppScaffold(
          title: 'ホーム',
          currentIndex: 0,
          actions: [
            IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoutes.notifications),
              icon: const Icon(Icons.notifications_none),
            ),
          ],
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('スタンプ取得'),
          ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 100),
            children: [
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('こんにちは、${user?.name ?? ''}さん'),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      '${widget.stampController.stampCount}',
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                    const Text('現在のスタンプ数'),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      remaining == 0 ? '交換可能な特典があります' : '次の特典まであと$remaining個',
                    ),
                  ],
                ),
              ),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('クイックメニュー'),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        FilledButton.tonal(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.history),
                          child: const Text('履歴を見る'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.rewards),
                          child: const Text('特典を見る'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.tickets),
                          child: const Text('チケットを見る'),
                        ),
                        FilledButton.tonal(
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.stores),
                          child: const Text('店舗を見る'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SectionCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('最近の履歴'),
                    const SizedBox(height: AppSpacing.sm),
                    ...widget.stampController.logs.take(5).map(
                      (log) => Container(
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: AppSpacing.xs),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              log.storeName,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 4),
                            Text(log.message),
                            const SizedBox(height: 2),
                            Text(
                              DateFormatter.short(log.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
