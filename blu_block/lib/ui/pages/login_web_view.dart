import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../classes/automated_web_view.dart';
import '../../classes/settings.dart';

class LoginWebView extends StatelessWidget {
  final String initialUrl;
  final String jsLogic;
  final String platform;
  final Settings settings = Settings();

  LoginWebView({super.key, required this.initialUrl, required this.jsLogic, required this.platform});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await _checkLoginStatus();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri.uri(Uri.parse(initialUrl))),
        initialSettings: InAppWebViewSettings(
          javaScriptEnabled: true,
        ),
        onCloseWindow: (controller) async {
          await _checkLoginStatus();
        },
      ),
    );
  }

  _checkLoginStatus() async {
    bool checkResult = await AutomatedWebView(url: initialUrl,jsActions: jsLogic).performAutomatedActions();
    settings.updateValue(platform, checkResult);
  }
}
