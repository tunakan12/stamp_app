import '../../../shared/models/stamp_log.dart';
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
  Future<int> useStamps({required String userId, required int amount}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final current = _db.stampCounts[userId] ?? 0;
    if (current < amount) {
      throw Exception('スタンプが不足しています');
    }
    _db.stampCounts[userId] = current - amount;
    return _db.stampCounts[userId]!;
  }
}
