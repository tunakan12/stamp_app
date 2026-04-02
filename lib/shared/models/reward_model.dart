class RewardModel {
  const RewardModel({
    required this.id,
    required this.storeId,
    required this.title,
    required this.requiredStamps,
    required this.description,
  });

  final String id;
  final String storeId;
  final String title;
  final int requiredStamps;
  final String description;
}
