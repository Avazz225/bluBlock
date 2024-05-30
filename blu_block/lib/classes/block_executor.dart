import 'dart:math';
import 'package:blu_block/classes/database.dart';
import 'package:blu_block/classes/settings.dart';
import 'package:blu_block/helpers/random_wait_time.dart';
import 'package:flutter/cupertino.dart';

import 'account.dart';
import 'block_progress.dart';

class BlockExecutor extends ChangeNotifier{
  static final BlockExecutor _instance = BlockExecutor._internal();

  List<Account> _accounts = [];
  int _waitTimeSeconds = 0;
  int _batchSize = 0;
  int _workWindowStartSecs = 0;
  int _workWindowEndSecs = 0;
  int _totalActions = 0;
  int _succeededActions = 0;
  bool _blockActive = false;
  final Settings _settings = Settings();
  final DatabaseHelper _db = DatabaseHelper();
  final BlockProgress _progressTracker = BlockProgress();

  factory BlockExecutor() {
    return _instance;
  }

  toggleBlockActive(){
    _blockActive = !_blockActive;
    if (_blockActive){
      _blockScheduler();
    }
    notifyListeners();
  }

  bool getBlockActive(){
    return _blockActive;
  }

  Map getBlockStats(){
    return {'total_actions':_totalActions, 'succeeded':_succeededActions, 'percentage':(_succeededActions/_totalActions)};
  }

  _blockScheduler() async {
    while(_blockActive){
      //preparation and delaying
      await Future.delayed(Duration(seconds: _waitTimeSeconds), () async {
        int secondsToWindow = _defineWorkingWindow();
        await Future.delayed(Duration(seconds: secondsToWindow), ()  async {
          //do not execute block if execution was stopped while waiting
          if(_blockActive){
            //actual block execution
            _getBatchSize();
            await _getNewList();
            //only execute blocks and get waitTime if account list is not empty
            if (_accounts.isNotEmpty){
              await _executeBlocks();
              //at the end, so the first batch is performed immediately
              _getWaitTime();
            } else {
              // if account list is empty: stop execution
              toggleBlockActive();
            }
          }
        });
      });
    }
  }

  _executeBlocks() async {
    for (final account in _accounts){
      bool res = await account.block(_progressTracker);
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
        List accounts = await _db.readDB('account', ['account_id', 'account_name', 'blocked', 'category_id', 'platform_id'], 'category_id  <= ? AND blocked=0 AND block_attempt=0 AND platform_id = ?', [maxBlockLevel, i+1], 'category_id ASC, RANDOM()', _batchSize);
        for (final account in accounts){
          _accounts.add(Account(account['account_id'], account['account_name'], account['platform_id'], account['category_id'], account['blocked'] == 1));
        }
      }
    }
  }

  _getWorkingWindow() async {
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
        if(secondsSinceMidnight < _workWindowStart){
          // same day 
          return _workWindowStartSecs - secondsSinceMidnight;
        } else {
          // next dayv
          return (86400 - secondsSinceMidnight) + _workWindowStart;
        }
      } 
    }
  }

  BlockExecutor._internal();
}