import '../../shared/models/app_notification.dart';
import '../../shared/services/in_memory_database.dart';

class NotificationRepository {
  NotificationRepository(this._db);

  final InMemoryDatabase _db;

  Future<List<AppNotification>> fetchAll(String userId) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final list = _db.notifications[userId] ?? [];
    return [...list]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> push(String userId, {required String title, required String body}) async {
    final list = (_db.notifications[userId] ??= []);
    list.add(
      AppNotification(
        id: 'n${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        body: body,
        createdAt: DateTime.now(),
      ),
    );
  }
}
