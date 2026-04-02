import '../models/app_notification.dart';
import '../models/app_user.dart';
import '../models/reward_model.dart';
import '../models/stamp_log.dart';
import '../models/store_model.dart';

class InMemoryDatabase {
  InMemoryDatabase({
    required this.users,
    required this.passwords,
    required this.stampCounts,
    required this.stampLogs,
    required this.rewards,
    required this.stores,
    required this.notifications,
  });

  final Map<String, AppUser> users;
  final Map<String, String> passwords;
  final Map<String, int> stampCounts;
  final Map<String, List<StampLog>> stampLogs;
  final List<RewardModel> rewards;
  final List<StoreModel> stores;
  final Map<String, List<AppNotification>> notifications;

  static InMemoryDatabase seeded() {
    const user = AppUser(
      id: 'u1',
      name: '島崎ユーザー',
      email: 'demo@example.com',
    );

    final stores = [
      const StoreModel(
        id: 's1',
        name: 'カフェABC',
        description: '来店で1スタンプ',
        location: '東京都港区',
      ),
      const StoreModel(
        id: 's2',
        name: 'ラーメンXYZ',
        description: '会計ごとに1スタンプ',
        location: '東京都新宿区',
      ),
    ];

    final rewards = [
      const RewardModel(
        id: 'r1',
        storeId: 's1',
        title: 'ドリンク1杯無料',
        requiredStamps: 5,
        description: '好きなドリンク1杯',
      ),
      const RewardModel(
        id: 'r2',
        storeId: 's2',
        title: 'トッピング無料',
        requiredStamps: 8,
        description: '任意トッピング1つ無料',
      ),
    ];

    return InMemoryDatabase(
      users: {user.email: user},
      passwords: {'demo@example.com': 'password123'},
      stampCounts: {'u1': 3},
      stampLogs: {
        'u1': [
          StampLog(
            id: 'l1',
            storeId: 's1',
            storeName: 'カフェABC',
            message: '初回来店スタンプ',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
            amount: 1,
          ),
          StampLog(
            id: 'l2',
            storeId: 's2',
            storeName: 'ラーメンXYZ',
            message: '会計スタンプ',
            createdAt: DateTime.now().subtract(const Duration(hours: 5)),
            amount: 2,
          ),
        ],
      },
      rewards: rewards,
      stores: stores,
      notifications: {
        'u1': [
          AppNotification(
            id: 'n1',
            title: 'ようこそ',
            body: 'スタンプアプリへようこそ。あと2個で特典です。',
            createdAt: DateTime.now().subtract(const Duration(days: 1)),
          )
        ],
      },
    );
  }
}
