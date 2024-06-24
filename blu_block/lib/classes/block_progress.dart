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
    String platformFiler = _getPlatforms();
    print(platformFiler);
    totalCount = await _db.getCount('account', ['COUNT(*)'], 'ignored = ? AND category_id <= ? AND $platformFiler', [0, _settings.blockLevel], 'id ASC', 1);
    blockedCount = await _db.getCount('account', ['COUNT(*)'], 'blocked = ? AND ignored=0 AND category_id <= ? AND $platformFiler', [1, _settings.blockLevel], 'id ASC', 1);
    missedCount = await _db.getCount('account', ['COUNT(*)'], 'block_attempt = ? AND blocked = ? AND ignored=0 AND category_id <= ? AND $platformFiler', [1, 0, _settings.blockLevel], 'id ASC', 1);
    notifyListeners();
  }

  String _getPlatforms(){
    List<bool> loginStates = [
      _settings.facebookLoggedIn,
      _settings.instaLoggedIn,
      _settings.tiktokLoggedIn,
      _settings.xLoggedIn
    ];

    List<String> results = [];
    for (int i = 0; i < loginStates.length; i++) {
      if (loginStates[i]) {
        results.add("platform_id = ${i + 1}");
      }
    }
    return "(${results.join(" OR ")})";
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