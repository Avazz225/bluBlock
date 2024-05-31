import 'dart:async';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AutomatedWebView {
  final String url;
  final String jsActions;
  bool result = false;

  AutomatedWebView({required this.url, required this.jsActions});

  Future<bool> performAutomatedActions() async {
    Completer<void> actionCompleter = Completer<void>();

    HeadlessInAppWebView headlessWebView = HeadlessInAppWebView(
      initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(url))),
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        loadsImagesAutomatically: false,

      ),

      onConsoleMessage: (controller, consoleMessage) {
        if (consoleMessage.message.startsWith("BluBlockScriptResult - ")){
          String consoleResult = consoleMessage.message.substring(23);
          result = consoleResult.trim() == "true";
          if (!actionCompleter.isCompleted) {
            actionCompleter.complete();
          }
        }
      },
      onLoadStop: (controller, url) async {
        await controller.evaluateJavascript(source: jsActions);
        print(url);
      },

    );

    await headlessWebView.run();
    await actionCompleter.future;
    await headlessWebView.dispose();

    return result;
  }
}