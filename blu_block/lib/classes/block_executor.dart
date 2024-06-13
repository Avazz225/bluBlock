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
    List<bool> loginStates = [_settings.facebookLoggedIn, _settings.instaLoggedIn, _settings.tiktokLoggedIn, _settings.xLoggedIn];
    while(_blockActive){
      //block execution
      _getBatchSize();
      //check if daily limit is about to be reached
      if (_batchSize > (_settings.maxBatchSize - _settings.dailyBlocks)){
        _batchSize = _settings.maxBatchSize  - _settings.dailyBlocks;
      }

      if (_batchSize > 0){
        await _getNewList();
        //only execute blocks and get waitTime if account list is not empty
        if (_accounts.isNotEmpty){
          await _executeBlocks();
          _getWaitTime();
          _accountOverview.initialize();
          _settings.updateValue("daily_blocks", _settings.dailyBlocks + _batchSize);
          await Future.delayed(Duration(seconds: _waitTimeSeconds));
        } else {
          // if account list is empty: stop execution (all accounts blocked)
          toggleBlockActive();
        }
      } else {
        // daily blocklimit reached
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
    _batchSize = Random().nextInt(5)+1;
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

  BlockExecutor._internal();
}