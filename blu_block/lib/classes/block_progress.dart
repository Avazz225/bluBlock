import 'package:BluBlock/classes/settings.dart';

import 'database.dart';
import 'package:flutter/material.dart';

class BlockProgress extends ChangeNotifier {
  static final BlockProgress _instance = BlockProgress._internal();
  int totalCount = 0;
  int blockedCount = 0;
  int missedCount = 0;
  final DatabaseHelper _db = DatabaseHelper();
  final Settings _settings = Settings();

  factory BlockProgress() {
    return _instance;
  }

  Future<void> initialize() async {
    await _initValues();
  }

  _initValues() async {
    await updateValues();
  }

  updateValues() async {
    totalCount = await _db.getCount('account', ['COUNT(*)'], 'ignored = ? AND category_id <= ?', [0, _settings.blockLevel], 'id ASC', 1);
    blockedCount = await _db.getCount('account', ['COUNT(*)'], 'blocked = ? AND ignored=0 AND category_id <= ?', [1, _settings.blockLevel], 'id ASC', 1);
    missedCount = await _db.getCount('account', ['COUNT(*)'], 'block_attempt = ? AND blocked = ? AND ignored=0 AND category_id <= ?', [1, 0, _settings.blockLevel], 'id ASC', 1);
    notifyListeners();
  }
  
  updateBlockedCount(int additionalBlocked){
    blockedCount += additionalBlocked;
    notifyListeners();
  }

  updateMissedCount(int additionalMissed){
    missedCount += additionalMissed;
    notifyListeners();
  }

  BlockProgress._internal();
}