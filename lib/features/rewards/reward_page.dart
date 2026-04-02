import 'package:flutter/material.dart';

import '../../app/constants/app_spacing.dart';
import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/primary_button.dart';
import '../../shared/widgets/section_card.dart';
import '../auth/presentation/auth_controller.dart';
import '../stamp/presentation/stamp_controller.dart';
import 'reward_repository.dart';

class RewardPage extends StatefulWidget {
  const RewardPage({
    super.key,
    required this.authController,
    required this.stampController,
    required this.rewardRepository,
  });

  final AuthController authController;
  final StampController stampController;
  final RewardRepository rewardRepository;

  @override
  State<RewardPage> createState() => _RewardPageState();
}

class _RewardPageState extends State<RewardPage> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.rewardRepository.fetchAll(),
      builder: (context, snapshot) {
        final rewards = snapshot.data ?? [];
        return AnimatedBuilder(
          animation: widget.stampController,
          builder: (context, _) {
            return AppScaffold(
              title: '特典一覧',
              currentIndex: 1,
              body: ListView(
                children: [
                  SectionCard(
                    child: Text('保有スタンプ: ${widget.stampController.stampCount}個'),
                  ),
                  ...rewards.map(
                    (reward) {
                      final canRedeem = widget.stampController.stampCount >= reward.requiredStamps;
                      return SectionCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(reward.title, style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: AppSpacing.xs),
                            Text(reward.description),
                            const SizedBox(height: AppSpacing.xs),
                            Text('必要スタンプ: ${reward.requiredStamps}'),
                            const SizedBox(height: AppSpacing.sm),
                            PrimaryButton(
                              label: canRedeem ? '交換する' : 'スタンプ不足',
                              isLoading: widget.stampController.isLoading,
                              onPressed: canRedeem
                                  ? () async {
                                      await widget.stampController.redeem(
                                        userId: widget.authController.currentUser!.id,
                                        reward: reward,
                                      );
                                      if (!mounted) return;
                                      final msg = widget.stampController.errorMessage ?? '交換しました';
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text(msg)),
                                      );
                                      setState(() {});
                                    }
                                  : null,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
