import 'dart:async';
import 'package:webview_flutter/webview_flutter.dart';

class AutomatedWebView {
  final String _url;
  final String _jsActions;
  String result = "";

  AutomatedWebView(this._url, this._jsActions);

  Future<bool> performAutomatedActions() async {
    Completer<WebViewController> controllerCompleter = Completer<WebViewController>();
    bool actionCompleted = false;

    // ignore: unused_local_variable
    final webView = WebView(
      initialUrl: _url,
      javascriptMode: JavascriptMode.unrestricted,
      onWebViewCreated: (WebViewController webViewController) {
        controllerCompleter.complete(webViewController);
      },
      onPageFinished: (String url) async {
        WebViewController controller = await controllerCompleter.future;
        // Führen Sie die automatisierten Aktionen auf der Webseite mit JavaScript aus
        result = await controller.runJavascriptReturningResult(_jsActions);
        // Setzen Sie actionCompleted auf true, wenn die Aktionen abgeschlossen sind
        actionCompleted = true;
      },
    );

    // Erstellen Sie ein Completer, um auf den Abschluss der WebView-Aktionen zu warten
    Completer<void> actionCompleter = Completer<void>();

    // Warten Sie darauf, dass die Aktionen in der WebView abgeschlossen sind
    Timer.periodic(const Duration(seconds: 1), (Timer timer) async {
      if (actionCompleted) {
        timer.cancel();
        actionCompleter.complete();
      }
    });

    // Warten Sie auf den Abschluss der Aktionen
    await actionCompleter.future;
    return result.toLowerCase() == "true";
  }
}