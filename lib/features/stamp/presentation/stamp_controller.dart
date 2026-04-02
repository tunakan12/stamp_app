import 'package:flutter/material.dart';

import '../../../shared/models/reward_model.dart';
import '../../../shared/models/stamp_log.dart';
import '../../notifications/notification_repository.dart';
import '../../rewards/reward_repository.dart';
import '../../store/store_repository.dart';
import '../domain/stamp_repository.dart';

class StampController extends ChangeNotifier {
  StampController(
    this._stampRepository,
    this._rewardRepository,
    this._storeRepository,
    this._notificationRepository,
  );

  final StampRepository _stampRepository;
  final RewardRepository _rewardRepository;
  final StoreRepository _storeRepository;
  final NotificationRepository _notificationRepository;

  int _stampCount = 0;
  bool _isLoading = false;
  List<StampLog> _logs = [];
  String? _errorMessage;

  int get stampCount => _stampCount;
  bool get isLoading => _isLoading;
  List<StampLog> get logs => _logs;
  String? get errorMessage => _errorMessage;

  Future<void> load(String userId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _stampCount = await _stampRepository.fetchStampCount(userId);
      _logs = await _stampRepository.fetchStampLogs(userId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> scanAndGrant({required String userId, required String storeId}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _stampCount = await _stampRepository.grantStamp(userId: userId, storeId: storeId);
      _logs = await _stampRepository.fetchStampLogs(userId);
      final store = await _storeRepository.findById(storeId);
      await _notificationRepository.push(
        userId,
        title: 'スタンプ獲得',
        body: '${store?.name ?? '店舗'}でスタンプを1個獲得しました',
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> redeem({required String userId, required RewardModel reward}) async {
    _isLoading = true;
    notifyListeners();
    try {
      _stampCount = await _stampRepository.useStamps(
        userId: userId,
        amount: reward.requiredStamps,
      );
      await _notificationRepository.push(
        userId,
        title: '特典交換完了',
        body: '「${reward.title}」を交換しました',
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int remainingUntilNextReward(List<RewardModel> rewards) {
    if (rewards.isEmpty) return 0;
    final candidates = rewards
        .map((e) => e.requiredStamps)
        .where((required) => required > _stampCount)
        .toList()
      ..sort();
    if (candidates.isEmpty) return 0;
    return candidates.first - _stampCount;
  }
}
