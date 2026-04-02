import '../../shared/models/store_model.dart';
import '../../shared/services/in_memory_database.dart';

class StoreRepository {
  StoreRepository(this._db) {
    global = this;
  }

  final InMemoryDatabase _db;
  static late StoreRepository global;

  Future<List<StoreModel>> fetchAll() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return [..._db.stores];
  }

  List<StoreModel> fetchAllSync() => [..._db.stores];

  Future<StoreModel?> findById(String id) async {
    try {
      return _db.stores.firstWhere((element) => element.id == id);
    } catch (_) {
      return null;
    }
  }
}
