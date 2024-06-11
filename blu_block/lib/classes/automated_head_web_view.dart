import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../classes/settings.dart';

class AutomatedHeadWebView extends StatelessWidget {
  final String initialUrl;
  final String jsActions;
  final String platform;
  final Settings settings = Settings();
  bool _result = false;
  bool _actionsDone = false;
  Completer<void> actionCompleter = Completer<void>();

  AutomatedHeadWebView({super.key, required this.initialUrl, required this.jsActions, required this.platform});

  bool getActionsDone(){
    return _actionsDone;
  }

  bool getResult(){
    return _result;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(initialUrl))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
            loadsImagesAutomatically: false
        ),
        onConsoleMessage: (controller, consoleMessage) async {
          if (consoleMessage.message.startsWith("BluBlockScriptResult - ")){
            String consoleResult = consoleMessage.message.substring(23);
            _result = consoleResult.trim() == "true";
            _actionsDone = true;
            if (!actionCompleter.isCompleted) {
              actionCompleter.complete();
            }
          }
        },
        onLoadStop: (controller, url) async {
          await controller.evaluateJavascript(source: jsActions);
        },
      ),
    );

  }
}
