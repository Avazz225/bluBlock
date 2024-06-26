import 'package:BluBlock/classes/database.dart';
import 'package:flutter/cupertino.dart';

import 'account.dart';

class AccountOverview extends ChangeNotifier{
  static final AccountOverview _instance = AccountOverview._internal();

  List<Account> _accounts = [];
  final Map _platforms = {}; 
  final Map _categories = {};
  final DatabaseHelper _db = DatabaseHelper();
  int filter = 0;

  factory AccountOverview() {
    return _instance;
  }

  Future<void> initialize() async {
    await _initValues();
    notifyListeners();
  }

  _initValues() async {
    _accounts = [];
    int maxBlockLevel = (await _db.readDB('configuration', ['block_level'], '1 = ?', [1], 'block_level ASC', 1))[0]['block_level'];
    List accountNames = await _db.readDB('account', ['account_id', 'account_name', 'blocked', 'ignored', 'category_id', 'platform_id', 'block_attempt'], 'category_id  <= ?', [maxBlockLevel], 'category_id ASC, account_name ASC', 1000000);
    for (final account in accountNames){
      _accounts.add(Account(account['account_id'], account['account_name'], account['platform_id'], account['category_id'], account['blocked'] == 1, account['ignored'] == 1, account['block_attempt'] == 1));
    }

    List rawPlatforms = await _db.readDB('platform', ['platform_id', 'platform_name'], '1 = ?', [1], 'platform_id ASC', 100);
    for (final platform in rawPlatforms){
      _platforms[platform['platform_id']] = platform['platform_name'];
    }

    List rawCategories = await _db.readDB('category', ['category_id', 'category_name'], '1 = ?', [1], 'category_id ASC', 100);
    for (final category in rawCategories){
      _categories[category['category_id']] = category['category_name'];
    }
  }

  setFilter(int value){
    filter = value;
  }

  getAccountList(){
    List<Map> result = [];
    for (final acc in _accounts){
      if (filter == 0){
        //all accounts
        result.add({"account": acc, "platform":_platforms[acc.platformId], "category":_categories[acc.categoryId]});
      } else if (filter == 1){
        //only not processed accounts
        if (!acc.blocked && !acc.attempt && !acc.ignored){
          result.add({"account": acc, "platform":_platforms[acc.platformId], "category":_categories[acc.categoryId]});
        }
      } else if (filter == 2){
        //only successful accounts
        if (acc.blocked && !acc.attempt && !acc.ignored){
          result.add({"account": acc, "platform":_platforms[acc.platformId], "category":_categories[acc.categoryId]});
        }
      } else if (filter == 3){
        //only ignored accounts
        if (acc.ignored){
          result.add({"account": acc, "platform":_platforms[acc.platformId], "category":_categories[acc.categoryId]});
        }
      } else if (filter == 4){
        //only failed accounts
        if (!acc.blocked && acc.attempt && !acc.ignored){
          result.add({"account": acc, "platform":_platforms[acc.platformId], "category":_categories[acc.categoryId]});
        }
      }
    }
    return result;
  }

  AccountOverview._internal();
}