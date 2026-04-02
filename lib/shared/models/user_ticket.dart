class UserTicket {
  const UserTicket({
    required this.id,
    required this.rewardId,
    required this.storeId,
    required this.title,
    required this.description,
    required this.exchangedAt,
    this.usedAt,
  });

  final String id;
  final String rewardId;
  final String storeId;
  final String title;
  final String description;
  final DateTime exchangedAt;
  final DateTime? usedAt;

  bool get isUsed => usedAt != null;

  UserTicket copyWith({DateTime? usedAt}) {
    return UserTicket(
      id: id,
      rewardId: rewardId,
      storeId: storeId,
      title: title,
      description: description,
      exchangedAt: exchangedAt,
      usedAt: usedAt ?? this.usedAt,
    );
  }
}
