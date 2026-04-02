class StampLog {
  const StampLog({
    required this.id,
    required this.storeId,
    required this.storeName,
    required this.message,
    required this.createdAt,
    required this.amount,
  });

  final String id;
  final String storeId;
  final String storeName;
  final String message;
  final DateTime createdAt;
  final int amount;
}
