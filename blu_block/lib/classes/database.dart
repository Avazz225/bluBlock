import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'blublock_database3.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS "category" (
        "category_id"	INTEGER NOT NULL,
        "category_name"	TEXT NOT NULL,
        PRIMARY KEY("category_id")
      );'''
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS "platform" (
        "platform_id"	INTEGER NOT NULL,
        "platform_name"	TEXT NOT NULL,
        "platform_url" TEXT NOT NULL,
        PRIMARY KEY("platform_id")
    );'''
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS "account" (
          "id"	INTEGER NOT NULL,
          "account_id"	TEXT NOT NULL,
          "account_name"	TEXT NOT NULL,
          "blocked"	INTEGER NOT NULL DEFAULT 0,
          "block_attempt" INTEGER NOT NULL DEFAULT 0,
          "ignored" INTEGER NOT NULL DEFAULT 0,
          "category_id"	INTEGER NOT NULL,
          "platform_id"	INTEGER NOT NULL,
          PRIMARY KEY("id")
        );'''
    );

    await db.execute('''
      CREATE TABLE IF NOT EXISTS "configuration" (
        "block_level"	INTEGER NOT NULL DEFAULT 2,
        "cloudfront_url"	TEXT UNIQUE,
        "wait_seconds_min"	INTEGER NOT NULL DEFAULT 900,
        "wait_seconds_max"	INTEGER NOT NULL DEFAULT 1200,
        "max_batch_size"	INTEGER NOT NULL DEFAULT 5,
        "work_window_start"	INTEGER NOT NULL DEFAULT 79200,
        "work_window_end"	INTEGER NOT NULL DEFAULT 18000,
        "facebook_logged_in" INTEGER NOT NULL DEFAULT 0,
        "insta_logged_in" INTEGER NOT NULL DEFAULT 0,
        "tiktok_logged_in" INTEGER NOT NULL DEFAULT 0,
        "x_logged_in" INTEGER NOT NULL DEFAULT 0,
        "last_file_refresh" TEXT NOT NULL DEFAULT "never"
      );'''
    );

    await db.execute('''
      INSERT OR IGNORE INTO "platform" ("platform_id","platform_name","platform_url") VALUES (1,'Facebook', 'https://www.facebook.com/'),
        (2,'Instagram', 'https://www.instagram.com/'),
        (3,'TikTok', 'https://www.tiktok.com/'),
        (4,'X', 'https://x.com/');
      '''
    );

    await db.execute('''
      INSERT OR IGNORE INTO "category" ("category_id","category_name") VALUES (1,'Politiker/-in'),
        (2,'Großer Unterstützender'),
        (3,'Einzelperson');
      '''
    );

    await db.execute('''
      INSERT OR IGNORE INTO "configuration" ("cloudfront_url") VALUES ("https://d1wkl9s3pa535c.cloudfront.net");
      '''
    );
  }

  // Create
  Future<int> insertDB(String table, Map<String, dynamic> row) async {
    Database db = await database;
    return await db.insert(table, row, conflictAlgorithm: ConflictAlgorithm.ignore);
  }

  // Read
  Future<List<Map<String, dynamic>>> readDB(String table, List<String> columns, String where, List<Object?> whereArgs, String orderBy, int limit) async {
    Database db = await database;
    return await db.query(table, columns: columns, where: where, whereArgs: whereArgs, orderBy: orderBy, limit: limit);
  }

  Future<int> getCount(String table, List<String> columns, String where, List<Object?> whereArgs, String orderBy, int limit) async {
    final result = await DatabaseHelper().readDB(table, columns,where, whereArgs, orderBy, limit);
    if (result.isNotEmpty && result[0].containsKey('COUNT(*)')) {
      return result[0]['COUNT(*)'] as int;
    } else {
      return 0;
    }
  }

  // Update
  Future<int> updateDB(String table, Map<String, dynamic> row, String where, List<Object?> whereArgs) async {
    Database db = await database;
    return await db.update(table, row, where: where, whereArgs: whereArgs);
  }

  // Delete
  Future<int> deleteDB(String table,  String where, List<Object?> whereArgs) async {
    Database db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }
}
