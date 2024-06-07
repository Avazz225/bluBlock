import 'dart:math';
import 'package:BluBlock/classes/account_overview.dart';
import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/settings.dart';
import 'package:BluBlock/helpers/random_wait_time.dart';
import 'package:flutter/cupertino.dart';

import 'account.dart';

class BlockExecutor extends ChangeNotifier{
  static final BlockExecutor _instance = BlockExecutor._internal();

  List<Account> _accounts = [];
  int _waitTimeSeconds = 0;
  int _batchSize = 0;
  /*
  int _workWindowStartSecs = 0;
  int _workWindowEndSecs = 0;
  */
  int _totalActions = 0;
  int _succeededActions = 0;
  bool _blockActive = false;
  final Settings _settings = Settings();
  final DatabaseHelper _db = DatabaseHelper();
  final AccountOverview _accountOverview = AccountOverview();

  factory BlockExecutor() {
    return _instance;
  }

  Future<void> initialize() async {
    await _settings.initialize();
  }

  toggleBlockActive(){
    _blockActive = !_blockActive;
    if (_blockActive){
      blockScheduler();
    }
    notifyListeners();
  }

  changeBlockActiveSilent(){
    _blockActive = !_blockActive;
  }

  bool getBlockActive(){
    return _blockActive;
  }

  Map getBlockStats(){
    return {'total_actions':_totalActions, 'succeeded':_succeededActions, 'percentage':(_succeededActions/_totalActions)};
  }

  blockScheduler() async {
    while(_blockActive){
      //block execution
      _getBatchSize();
      await _getNewList();
      //only execute blocks and get waitTime if account list is not empty
      if (_accounts.isNotEmpty){
        await _executeBlocks();
        _getWaitTime();
        _accountOverview.initialize();
        await Future.delayed(Duration(seconds: _waitTimeSeconds));
      } else {
        // if account list is empty: stop execution
        toggleBlockActive();
      }
    }
  }

  _executeBlocks() async {
    for (final account in _accounts){
      bool res = false;
      try{
        res = await account.block();
      } catch (e) {
        res = false;
      }
      _totalActions++;
      if (res){
        _succeededActions++;
      }
    }
    return;
  }

  _getBatchSize() {
    _batchSize = Random().nextInt(_settings.maxBatchSize)+1;
  }

  _getWaitTime() {
    _waitTimeSeconds = randomNumberGenerator(_settings.waitSecondsMin, _settings.waitSecondsMax);
  }

  _getNewList() async {
    _accounts = [];
    int maxBlockLevel = _settings.blockLevel;
    List loginStates = [_settings.facebookLoggedIn, _settings.instaLoggedIn, _settings.tiktokLoggedIn, _settings.xLoggedIn];

    for (int i = 0; i<loginStates.length; i++){
      if (loginStates[i]){
        List accounts = await _db.readDB('account', ['account_id', 'account_name', 'blocked', 'ignored', 'category_id', 'platform_id'], 'category_id  <= ? AND blocked=0 AND block_attempt=0 AND platform_id = ? AND ignored=0', [maxBlockLevel, i+1], 'category_id ASC, RANDOM()', _batchSize);
        for (final account in accounts){
          _accounts.add(Account(account['account_id'], account['account_name'], account['platform_id'], account['category_id'], account['blocked'] == 1, account['ignored'] == 1, false));
        }
      }
    }
  }

/*_getWorkingWindow() {
    _workWindowStartSecs = _settings.workWindowStart;
    _workWindowEndSecs = _settings.workWindowEnd;
  }

  int _defineWorkingWindow() {
    _getWorkingWindow();
    DateTime now = DateTime.now();
    int secondsSinceMidnight = now.hour * 3600 + now.minute * 60 + now.second;

    //is over night
    if (_workWindowEndSecs < _workWindowStartSecs){
      if (secondsSinceMidnight > _workWindowStartSecs || secondsSinceMidnight < _workWindowEndSecs){
        return 0;
      } else {
        return _workWindowStartSecs - secondsSinceMidnight;
      }
    // is not over night
    } else {
      if (secondsSinceMidnight >= _workWindowStartSecs && secondsSinceMidnight < _workWindowEndSecs){
        return 0;
      } else 
        if (secondsSinceMidnight < _workWindowStartSecs){
          // same day
          return _workWindowStartSecs - secondsSinceMidnight;
        } else {
          // next dayv
          return (86400 - _workWindowStartSecs) + _workWindowStartSecs;
        }
      }
  }*/

  BlockExecutor._internal();
}