import 'package:BluBlock/ui/components/pop_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../classes/automated_web_view.dart';
import '../../classes/settings.dart';

class LoginWebView extends StatelessWidget {
  final String initialUrl;
  final String jsLogic;
  final String platform;
  final bool isLogin;
  final Settings settings = Settings();

  LoginWebView({super.key, required this.initialUrl, required this.jsLogic, required this.platform, required this.isLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text((isLogin)?'Login':'Logout'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () async {
            await _checkLoginStatus(context);
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
          await _checkLoginStatus(context);
        },
      ),
    );
  }

  _checkLoginStatus(context) async {
    showMessage(context, "Dein Loginstatus wird geprüft.\nBitte warte kurz.", "Prüfen", false);
    bool checkResult = await AutomatedWebView(url: initialUrl,jsActions: jsLogic).performAutomatedActions();
    settings.updateValue(platform, checkResult);
    Navigator.of(context).pop();
  }
}
