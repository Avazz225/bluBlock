import 'package:BluBlock/classes/automated_web_view.dart';
import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/url.dart';
import 'package:BluBlock/js_logic/insta_logic.dart';
import 'package:BluBlock/js_logic/tiktok_logic.dart';

import 'block_progress.dart';

class Account{
  final String accountId;
  final String accountName;
  final int platformId;
  final int categoryId;
  bool ignored;
  bool blocked;
  bool attempt;
  final DatabaseHelper _db = DatabaseHelper();
  final Url _url = Url();
  final BlockProgress progressTracker = BlockProgress();
  
  Account(this.accountId, this.accountName, this.platformId, this.categoryId, this.blocked, this.ignored, this.attempt);


  Future<bool> block() async {
    bool blockResult = await AutomatedWebView(url: '${await(_getBaseUrl())}$accountId', jsActions: await _getBlockLogic()).performAutomatedActions();
    if (blockResult){
      _updateBlockState();
      progressTracker.updateBlockedCount(1);
    } else {
      await _db.updateDB('account', {'block_attempt': 1}, 'account_id = ? AND account_name = ? AND platform_id = ? AND category_id = ?', [accountId, accountName, platformId, categoryId]);
      progressTracker.updateMissedCount(1);
    }
    return blockResult;
  }

  _updateBlockState() async {
    await _db.updateDB('account', {'blocked': 1}, 'account_id = ? AND account_name = ? AND platform_id = ? AND category_id = ?', [accountId, accountName, platformId, categoryId]);
    blocked = true;
  }

  Future<String> _getBaseUrl() async {
    return (await _url.getPlatformUrl(platformId));
  }

  Future<String> _getBlockLogic() async {
    String platform = (await _db.readDB("platform", ["platform_name"], "platform_id = ?", [platformId], 'platform_id ASC', 1))[0]['platform_name'].toLowerCase();
    if (platform == "instagram"){
      return instaBlockLogic;
    } else if (platform == "tiktok"){
      return tiktokBlockLogic;
    }
    return "";
  }

  toggleIgnored(){
    ignored = !ignored;
    _db.updateDB('account', {'ignored': (ignored)?1:0}, 'account_id = ? AND account_name = ? AND platform_id = ? AND category_id = ?', [accountId, accountName, platformId, categoryId]);
    BlockProgress().updateValues();
  }
}