import 'package:BluBlock/classes/database.dart';
import 'package:flutter/cupertino.dart';

class Settings extends ChangeNotifier{
  static final Settings _instance = Settings._internal();

  bool facebookLoggedIn = false;
  bool instaLoggedIn = false;
  bool tiktokLoggedIn = false;
  bool xLoggedIn = false;
  int waitSecondsMin = 0;
  int waitSecondsMax = 0;
  int maxBatchSize = 0;
  DateTime lastFileRefresh = DateTime.parse("1970-01-01 00:00:00.000");
  int blockLevel = 1;
  int workWindowStart = 0;
  int workWindowEnd = 0;
  final DatabaseHelper _db = DatabaseHelper();

  factory Settings() {
    return _instance;
  }

  Future<void> initialize() async {
    await _initValues();
    notifyListeners();
  }

  Future<void> _initValues() async {
    List<String> targetCols = [
      'block_level', 
      'wait_seconds_min', 
      'wait_seconds_max', 
      'max_batch_size',
      'work_window_start',
      'work_window_end',
      'facebook_logged_in',
      'insta_logged_in',
      'tiktok_logged_in',
      'x_logged_in',
      'last_file_refresh'
    ];
    Map rawSettings = (await _db.readDB("configuration", targetCols, '1 = ?', [1], 'block_level ASC', 1))[0];
    
    facebookLoggedIn = rawSettings['facebook_logged_in'] == 1;
    instaLoggedIn = rawSettings['insta_logged_in'] == 1;
    tiktokLoggedIn = rawSettings['tiktok_logged_in'] == 1;
    xLoggedIn = rawSettings['x_logged_in'] == '1';

    blockLevel = rawSettings['block_level'];
    waitSecondsMin = rawSettings['wait_seconds_min'];
    waitSecondsMax = rawSettings['wait_seconds_max'];
    maxBatchSize = rawSettings['max_batch_size'];
    workWindowStart = rawSettings['work_window_start'];
    workWindowEnd = rawSettings['work_window_end'];
    if (rawSettings['last_file_refresh'] != 'never'){
      lastFileRefresh = DateTime.parse(rawSettings['last_file_refresh']);
    }
  }

  void updateValue(String variableName, dynamic value) async {
    switch (variableName) {
      case 'facebookLoggedIn':
      case 'facebook_logged_in':
      case 'facebook':
        facebookLoggedIn = value;
        await _db.updateDB("configuration", {"facebook_logged_in": value ? 1:0}, '1 = ?', [1]);
        break;
      case 'instaLoggedIn':
      case 'insta_logged_in':
      case 'instagram':
        instaLoggedIn = value;
        await _db.updateDB("configuration", {"insta_logged_in": value ? 1:0}, '1 = ?', [1]);
        break;
      case 'tiktokLoggedIn':
      case 'tiktok_logged_in':
      case 'tiktok':
        tiktokLoggedIn = value;
        await _db.updateDB("configuration", {"tiktok_logged_in": value ? 1:0}, '1 = ?', [1]);
        break;
      case 'xLoggedIn':
      case 'x_logged_in':
      case 'x':
        xLoggedIn = value;
        await _db.updateDB("configuration", {"x_logged_in": value ? 1:0}, '1 = ?', [1]);
        break;
      case 'waitSecondsMin':
        if (value < 15){
          value = 15;
        }
        waitSecondsMin = value;
        await _db.updateDB("configuration", {"wait_seconds_min": value}, '1 = ?', [1]);
        if (value > waitSecondsMax){
          waitSecondsMax = value;
          await _db.updateDB("configuration", {"wait_seconds_max": value}, '1 = ?', [1]);
        }
        break;
      case 'waitSecondsMax':
        if (value < 15){
          value = 15;
        }
        if (value < waitSecondsMin){
          value = waitSecondsMin;
        }
        waitSecondsMax = value;
        await _db.updateDB("configuration", {"wait_seconds_max": value}, '1 = ?', [1]);
        break;
      case 'maxBatchSize':
        maxBatchSize = value;
        await _db.updateDB("configuration", {"max_batch_size": value}, '1 = ?', [1]);
        break;
      case 'lastFileRefresh':
        lastFileRefresh = DateTime.parse(value);
        await _db.updateDB("configuration", {"last_file_refresh": value}, '1 = ?', [1]);
        break;
      case 'blockLevel':
        blockLevel = value;
        await _db.updateDB("configuration", {"block_level": value}, '1 = ?', [1]);
        break;
      case 'workWindowStart':
        workWindowStart = value;
        await _db.updateDB("configuration", {"work_window_start": value}, '1 = ?', [1]);
        break;
      case 'workWindowEnd':
        workWindowEnd = value;
        await _db.updateDB("configuration", {"work_window_end": value}, '1 = ?', [1]);
        break;
      default:
        throw Exception('Unknown variable name: $variableName');
    }
    notifyListeners();
    return;
  }

  Settings._internal();
}