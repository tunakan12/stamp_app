import 'package:flutter/material.dart';

import '../../../app/router/app_router.dart';
import '../../../shared/utils/date_formatter.dart';
import '../../../shared/widgets/app_scaffold.dart';
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
        final maxStamp = rewards
            .map((reward) => reward.requiredStamps)
            .fold<int>(8, (prev, current) => current > prev ? current : prev);
        final stampCount = widget.stampController.stampCount;
        final progress = maxStamp == 0 ? 0.0 : (stampCount / maxStamp).clamp(0.0, 1.0);

        return AppScaffold(
          title: 'ホーム',
          currentIndex: 0,
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.scan),
            icon: const Icon(Icons.qr_code_scanner),
            label: const Text('スタンプ取得'),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'こんにちは、',
                      style: TextStyle(color: Color(0xFFC7D2FE), fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${user?.name ?? 'ゲスト'} さん',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '$stampCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            height: 0.9,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            '/ $maxStamp スタンプ',
                            style: const TextStyle(color: Color(0xFFC7D2FE)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(999),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 10,
                        backgroundColor: const Color(0x33433B82),
                        valueColor: const AlwaysStoppedAnimation(Colors.white),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        remaining == 0 ? '交換可能な特典があります' : '次の特典まであと $remaining 個',
                        style: const TextStyle(
                          color: Color(0xFFC7D2FE),
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'クイックメニュー',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _quickChip(
                      '履歴を見る',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.history),
                    ),
                    _quickChip(
                      '特典を見る',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.rewards),
                    ),
                    _quickChip(
                      'チケットを見る',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.tickets),
                    ),
                    _quickChip(
                      '店舗を見る',
                      onTap: () => Navigator.pushNamed(context, AppRoutes.stores),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                '最近の履歴',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF334155),
                ),
              ),
              const SizedBox(height: 12),
              if (widget.stampController.logs.isEmpty)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: const Text('履歴はまだありません'),
                ),
              ...widget.stampController.logs.take(5).map(
                (log) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 46,
                          height: 46,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text('🎫'),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                log.storeName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1E293B),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                log.message,
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF64748B),
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                DateFormatter.short(log.createdAt),
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickChip(String text, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: ActionChip(
        onPressed: onTap,
        backgroundColor: const Color(0xFFEEF2FF),
        label: Text(
          text,
          style: const TextStyle(
            color: Color(0xFF4338CA),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
