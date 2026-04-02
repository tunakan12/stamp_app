import '../../../shared/models/reward_model.dart';
import '../../../shared/models/stamp_log.dart';
import '../../../shared/models/user_ticket.dart';
import '../../../shared/services/in_memory_database.dart';
import '../domain/stamp_repository.dart';

class StampRepositoryImpl implements StampRepository {
  StampRepositoryImpl(this._db);

  final InMemoryDatabase _db;

  @override
  Future<int> fetchStampCount(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _db.stampCounts[userId] ?? 0;
  }

  @override
  Future<List<StampLog>> fetchStampLogs(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final logs = _db.stampLogs[userId] ?? [];
    return [...logs]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<List<UserTicket>> fetchTickets(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final tickets = _db.userTickets[userId] ?? [];
    return [...tickets]..sort((a, b) => b.exchangedAt.compareTo(a.exchangedAt));
  }

  @override
  Future<int> grantStamp({required String userId, required String storeId}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final store = _db.stores.firstWhere((e) => e.id == storeId);
    final current = _db.stampCounts[userId] ?? 0;
    _db.stampCounts[userId] = current + 1;
    final log = StampLog(
      id: 'l${DateTime.now().millisecondsSinceEpoch}',
      storeId: storeId,
      storeName: store.name,
      message: 'QR読み取りでスタンプ獲得',
      createdAt: DateTime.now(),
      amount: 1,
    );
    (_db.stampLogs[userId] ??= []).add(log);
    return _db.stampCounts[userId]!;
  }

  @override
  Future<int> useStamps({
    required String userId,
    required int amount,
    String? storeId,
    String? message,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final current = _db.stampCounts[userId] ?? 0;
    if (current < amount) {
      throw Exception('スタンプが不足しています');
    }
    _db.stampCounts[userId] = current - amount;
    String storeName = '特典交換';
    if (storeId != null) {
      final matchedStores = _db.stores.where((store) => store.id == storeId);
      if (matchedStores.isNotEmpty) {
        storeName = matchedStores.first.name;
      }
    }
    final log = StampLog(
      id: 'l${DateTime.now().millisecondsSinceEpoch}',
      storeId: storeId ?? 'reward',
      storeName: storeName,
      message: message ?? '特典交換',
      createdAt: DateTime.now(),
      amount: -amount,
    );
    (_db.stampLogs[userId] ??= []).add(log);
    return _db.stampCounts[userId]!;
  }

  @override
  Future<void> addTicket({required String userId, required RewardModel reward}) async {
    final tickets = (_db.userTickets[userId] ??= []);
    tickets.add(
      UserTicket(
        id: 't${DateTime.now().millisecondsSinceEpoch}',
        rewardId: reward.id,
        storeId: reward.storeId,
        title: reward.title,
        description: reward.description,
        exchangedAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<void> useTicket({required String userId, required String ticketId}) async {
    final tickets = _db.userTickets[userId] ?? [];
    final index = tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index < 0) {
      throw Exception('チケットが見つかりません');
    }
    if (tickets[index].isUsed) {
      throw Exception('このチケットはすでに使用済みです');
    }
    final updatedTicket = tickets[index].copyWith(usedAt: DateTime.now());
    tickets[index] = updatedTicket;

    String storeName = '特典';
    final matchedStores = _db.stores.where((store) => store.id == updatedTicket.storeId);
    if (matchedStores.isNotEmpty) {
      storeName = matchedStores.first.name;
    }
    final log = StampLog(
      id: 'l${DateTime.now().millisecondsSinceEpoch}',
      storeId: updatedTicket.storeId,
      storeName: storeName,
      message: 'チケット「${updatedTicket.title}」を使用',
      createdAt: DateTime.now(),
      amount: 0,
    );
    (_db.stampLogs[userId] ??= []).add(log);
  }
}
