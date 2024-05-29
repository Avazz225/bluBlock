import 'package:blu_block/classes/automated_web_view.dart';
import 'package:blu_block/classes/database.dart';
import 'package:blu_block/classes/url.dart';
import 'package:blu_block/js_logic/insta_logic.dart';

import 'block_progress.dart';

class Account{
  final String accountId;
  final String accountName;
  final int platformId;
  final int categoryId;
  bool blocked;
  final DatabaseHelper _db = DatabaseHelper();
  final Url _url = Url();
  
  Account(this.accountId, this.accountName, this.platformId, this.categoryId, this.blocked);

  Future<bool> block(BlockProgress progressTracker) async {
    AutomatedWebView webView = AutomatedWebView('${await(_getBaseUrl())}/$accountId', await _getBlockLogic());
    bool blockResult = await webView.performAutomatedActions();
    if (blockResult){
      _updateBlockState();
      progressTracker.updateBlockedCount(1);
    } else {
      progressTracker.updateMissedCount(1);
    }
    await _db.updateDB('account', {'block_attempt': 1}, 'account_id = ? AND account_name = ? AND platform_id = ? AND category_id = ?', [accountId, accountName, platformId, categoryId]);
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
    }
    return "";
  }
}