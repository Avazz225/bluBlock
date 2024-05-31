import 'package:BluBlock/classes/database.dart';

class Url{
  static final Url _instance = Url._internal();
  final DatabaseHelper _db = DatabaseHelper();

  factory Url() {
    return _instance;
  }

  Future<String> getPlatformUrl(int platformId) async {
    return (await _db.readDB("platform", ['platform_url'], "platform_id = ?", [platformId], 'platform_id ASC', 1))[0]["platform_url"];
  }

  Future<String> getBaseUrl() async {
    return (await _db.readDB("configuration", ['cloudfront_url'], "1 = ?", [1], 'cloudfront_url ASC', 1))[0]["cloudfront_url"];
  }

  Url._internal();
}