import '../../../shared/models/app_user.dart';
import '../../../shared/services/in_memory_database.dart';
import '../domain/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._db);

  final InMemoryDatabase _db;

  @override
  Future<AppUser> login({required String email, required String password}) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    final savedPassword = _db.passwords[email];
    final user = _db.users[email];
    if (savedPassword == null || user == null || savedPassword != password) {
      throw Exception('メールアドレスまたはパスワードが違います');
    }
    return user;
  }

  @override
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (_db.users.containsKey(email)) {
      throw Exception('すでに登録済みのメールアドレスです');
    }

    final user = AppUser(
      id: 'u${_db.users.length + 1}',
      name: name,
      email: email,
    );
    _db.users[email] = user;
    _db.passwords[email] = password;
    _db.stampCounts[user.id] = 0;
    _db.stampLogs[user.id] = [];
    _db.notifications[user.id] = [];
    return user;
  }

  @override
  Future<void> logout() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
  }
}
