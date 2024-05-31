import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../classes/settings.dart';

class LoginWebView extends StatelessWidget {
  final String initialUrl;
  final String jsLogic;
  final String platform;

  LoginWebView({super.key, required this.initialUrl, required this.jsLogic, required this.platform});

  @override
  Widget build(BuildContext context) {
    Completer<WebViewController> controller0 = Completer<WebViewController>();
    final settings = Provider.of<Settings>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(initialUrl))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onConsoleMessage: (controller, consoleMessage) {
          if (consoleMessage.message.startsWith("BluBlockScriptResult - ")){
            String consoleResult = consoleMessage.message.substring(23);
            if (consoleResult == 'true'){
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
              settings.updateValue(targetRow, true);
              //Navigator.pop(context);
            }
          }
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: jsLogic);
        },
      ),
    );
  }
}
