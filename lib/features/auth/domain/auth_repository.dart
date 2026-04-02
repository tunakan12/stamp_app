import '../../../shared/models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser> login({required String email, required String password});
  Future<AppUser> register({
    required String name,
    required String email,
    required String password,
  });
  Future<void> logout();
}
