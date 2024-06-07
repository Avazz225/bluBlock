import 'package:BluBlock/classes/account_overview.dart';
import 'package:BluBlock/classes/block_progress.dart';
import 'package:BluBlock/classes/cdn_file_reader.dart';
import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/settings.dart';

class ImportList{
  int _importedRows = 0;
  final DatabaseHelper _db = DatabaseHelper();
  final CDNFileReader _reader = CDNFileReader();
  final BlockProgress progress = BlockProgress();
  final Settings settings = Settings();
  final AccountOverview overview = AccountOverview();

  Future<int> executeImport() async {
    Map targetPlatforms = (await _db.readDB("configuration", ['facebook_logged_in','insta_logged_in','tiktok_logged_in','x_logged_in'], '1 = ?', [1], 'insta_logged_in ASC', 1))[0];
    List loginStates = [targetPlatforms['facebook_logged_in'], targetPlatforms['insta_logged_in'], targetPlatforms['tiktok_logged_in'], targetPlatforms['x_logged_in']];
    List platforms = [
      'facebook', 
      'instagram', 
      'tiktok', 
      'x'];
    for (int i = 0; i<loginStates.length; i++){
      if (loginStates[i] == 1){
        _reader.setPlatform(platforms[i]+".csv", i+1);
        _importedRows = (await _reader.readFileAndPerformAction());
      }
    }
    DateTime now = DateTime.now();
    settings.updateValue("lastFileRefresh", now.toString());
    progress.updateValues();
    overview.initialize();

    return _importedRows;
  }
}