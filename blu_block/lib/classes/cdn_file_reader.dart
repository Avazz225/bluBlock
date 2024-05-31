import 'dart:convert';
import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/url.dart';
import 'package:http/http.dart' as http;

class CDNFileReader {
  String _fileName = "";
  String _baseUrl = "";
  int _platformId = 0;
  int importedRows = 0;
  final DatabaseHelper _db = DatabaseHelper();
  final Url url = Url();

  CDNFileReader(){
    _initValues();
  }

  _initValues() async {
    _baseUrl = (await url.getBaseUrl());
  }

  void setPlatform(String fileName, int platformID) {
    _fileName = fileName;
    _platformId = platformID;
  }

  Future<int> readFileAndPerformAction() async {
    final url = Uri.parse('$_baseUrl/$_fileName');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final lines = const LineSplitter().convert(response.body);
      for (final line in lines) {
        try{
          int result = await _importRow(line.split(","));
          if (result!=0){
            importedRows++;
          }
        // ignore: empty_catches
        } on Exception { }
      }
    } else {
      throw Exception('Failed to load file from CDN: ${response.statusCode}');
    }
    return importedRows;
  }

  Future<int> _importRow(List<String> row) async {
    Map<String, dynamic> accountMapping = {
      'id': _createSixDigitNumber(_platformId, row[0]),
      'account_id': row[1].trim(),
      'account_name': row[2].trim(),
      'category_id': int.parse(row[3]),
      'platform_id': _platformId
    };
    return await _db.insertDB("account", accountMapping);
  }

  int _createSixDigitNumber(int first, String secondStr) {
    String firstStr = first.toString();
    int numZeros = 6 - (firstStr.length + secondStr.length);
    String zeros = '0' * numZeros;
    return int.parse(firstStr + zeros + secondStr);
  }
}