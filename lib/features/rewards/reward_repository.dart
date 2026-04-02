import '../../shared/models/reward_model.dart';
import '../../shared/services/in_memory_database.dart';

class RewardRepository {
  RewardRepository(this._db) {
    global = this;
  }

  final InMemoryDatabase _db;
  static late RewardRepository global;

  Future<List<RewardModel>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [..._db.rewards];
  }

  List<RewardModel> fetchAllSync() => [..._db.rewards];
}
