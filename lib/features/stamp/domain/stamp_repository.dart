import '../../../shared/models/stamp_log.dart';

abstract class StampRepository {
  Future<int> fetchStampCount(String userId);
  Future<List<StampLog>> fetchStampLogs(String userId);
  Future<int> grantStamp({required String userId, required String storeId});
  Future<int> useStamps({
    required String userId,
    required int amount,
    String? storeId,
    String? message,
  });
}
