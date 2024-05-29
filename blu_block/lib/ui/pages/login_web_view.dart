import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../classes/database.dart';
import '../../classes/settings.dart';

class LoginWebView extends StatelessWidget {
  final String initialUrl;
  final String jsLogic;
  final String platform;
  final DatabaseHelper _db = DatabaseHelper();

  LoginWebView({super.key, required this.initialUrl, required this.jsLogic, required this.platform});

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> controller0 = Completer<WebViewController>();
    final settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: WebView(
        initialUrl: initialUrl,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          controller0.complete(webViewController);
        },
        onPageFinished: (String url) async {
          WebViewController controller = await controller0.future;
          String loginSuccessful = await controller.runJavascriptReturningResult(jsLogic);
          if (loginSuccessful == '"true"'){
            String targetRow = "";
            if (platform == "instagram"){
              targetRow = "insta_logged_in";
            } else if (platform == "tiktok"){
              targetRow = "tiktok_logged_in";
            } else if (platform == "x"){
              targetRow = "x_logged_in";
            } else if (platform == "facebook"){
              targetRow = "facebook_logged_in";
            }
            await _db.updateDB("configuration", {targetRow: 1}, '1 = ?', [1]);
            settings.updateValue(targetRow, true);
            Navigator.pop(context);
          }
        },
      ),
    );
  }
}
