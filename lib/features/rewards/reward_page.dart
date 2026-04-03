import 'package:flutter/material.dart';

import '../../shared/widgets/app_scaffold.dart';
import '../../shared/widgets/primary_button.dart';
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
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0EA5E9), Color(0xFF2563EB)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '現在の保有スタンプ',
                          style: TextStyle(color: Color(0xFFDBEAFE), fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${widget.stampController.stampCount} 個',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...rewards.map(
                    (reward) {
                      final canRedeem = widget.stampController.stampCount >= reward.requiredStamps;
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              reward.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              reward.description,
                              style: const TextStyle(color: Color(0xFF475569)),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '必要スタンプ: ${reward.requiredStamps}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF64748B),
                              ),
                            ),
                            const SizedBox(height: 12),
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
                                      final msg = widget.stampController.errorMessage ?? 'チケットを追加しました';
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
