import '../../shared/models/app_user.dart';
import '../../shared/services/in_memory_database.dart';

class ProfileRepository {
  ProfileRepository(this._db);

  final InMemoryDatabase _db;

  Future<AppUser> updateName({required String email, required String name}) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    final user = _db.users[email];
    if (user == null) throw Exception('ユーザーが見つかりません');
    final updated = user.copyWith(name: name);
    _db.users[email] = updated;
    return updated;
  }
}
