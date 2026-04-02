import '../../../shared/models/reward_model.dart';
import '../../../shared/models/stamp_log.dart';
import '../../../shared/models/user_ticket.dart';

abstract class StampRepository {
  Future<int> fetchStampCount(String userId);
  Future<List<StampLog>> fetchStampLogs(String userId);
  Future<List<UserTicket>> fetchTickets(String userId);
  Future<int> grantStamp({required String userId, required String storeId});
  Future<int> useStamps({
    required String userId,
    required int amount,
    String? storeId,
    String? message,
  });
  Future<void> addTicket({required String userId, required RewardModel reward});
  Future<void> useTicket({required String userId, required String ticketId});
}
