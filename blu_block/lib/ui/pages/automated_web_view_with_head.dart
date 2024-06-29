import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class AutomatedWebViewWithHead extends StatelessWidget {
  final String initialUrl;
  final String jsActions;

  const AutomatedWebViewWithHead({super.key, required this.initialUrl, required this.jsActions});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(initialUrl))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onLoadStop: (controller, initialUrl) async {
          await controller.evaluateJavascript(source: jsActions);
        },
        onConsoleMessage: (controller, consoleMessage) {
          if (consoleMessage.message.startsWith("BluBlockScriptResult - ")){
            String consoleResult = consoleMessage.message.substring(23);
            bool result = consoleResult.trim() == "true";
            Future.delayed(const Duration(seconds: 2)).then((val) {
              //Navigator.of(context).pop(result);
            });
          }
        },
      ),
    );
  }
}
