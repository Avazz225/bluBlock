import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoPage extends StatelessWidget{
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hinweise"),
      ),
      body: SingleChildScrollView(
        child:Padding(
          padding: const EdgeInsets.symmetric(horizontal: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Kann mein Konto durch Nutzung von BluBlock gesperrt werden?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              const Text('''Ja, das ist prinzipiell möglich.'''),
              const Text('''Wir versuchen aber das zu verhindern. Darum haben wir standardmäßig kleine Blockpakete und zusätzliche randomisierte Wartezeiten eingebaut (Diese können auch angepasst werden!).\nDazu gibt es auch ein anpassbares tägliches Blocklimit.\nDennoch können wir nicht versprechen, dass die Plattformen keine Konten sperren oder zumindest einschränken.'''),
              const Text('\n'),
              const Text('Haftet der Softwarehersteller für eventuelle Schäden oder den Verlust von Accounts?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              const Text('''Nein, BluBlock zu nutzen erfolgt auf eigene Verantwortung.'''),
              const Text('''BluBlock ist nur ein Werkzeug, das jedem/r zur Verfügung gestellt wird.\nFür eventuelle Schäden jeglicher Art haftet der/die Anwendende selbst.\nWir empfehlen daher die Blockvorgänge in einem langsamen Rhythmus auszuführen, wie er Standardmäßig eingestellt ist. Aber auch die Einstellung ist keine Garantie dafür, dass keine Schäden entstehen.'''),
              const Text('\n'),
              const Text('Wie werden neue Daten hinterlegt?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              const Text('''Neue Daten werden durch ein CDN bereitgestellt.\nDie importierten Listen werden durch einen Algorithmus extrahiert, grob klassifiziert und anschließend händisch überprüft, bevor sie freigegeben werden.\nDadurch dauert das Bereitstellen der Listen unter Umständen länger.'''),
              const Text('\n'),
              const Text('Ist BluBlock ein Werkzeug um politischen Einfluss zu nehmen?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              const Text('''Nein.'''),
              const Text('''BluBlock ist auch nicht durch Dritte finanziert. Es ist ein Moderationstool für den eigenen Algorithmus und wirkt sich primär nur auf den eigenen Account aus.\nOb die Plattformen als Reaktion auf die Blocks weitere Effekte zeigen, ist weder bekannt, noch ist so etwas beabsichtigt.'''),
              const Text('\n'),
              const Text('Wenn BluBlock keinen politischen Einfluss nimmt, warum wird nur eine politische Gruppe blockiert?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              const Text('''Grund dafür ist, den eigenen Algorithmus aufzuräumen. Die starke Fokussierung kommt von der Präsenz jener Gruppe auf Social Media, die sich mitunter negativ auf das eigene Wohlbefinden auswirken kann.'''),
              const Text('\n'),
              const Text('Wie funktioniert BluBlock im Allgemeinen? Wie kann ich mir sicher sein, dass keine Daten abfließen?', style: TextStyle(fontWeight: FontWeight.bold)),
              const Text(''),
              RichText(
                text:TextSpan(
                  children: [
                    TextSpan(text: '''Es würde den Rahmen übersteigen dies hier zu beantworten. Daher ist der Quellcode frei zugänglich in einem GitHub Repository ''', style: Theme.of(context).textTheme.bodyMedium),
                    TextSpan(
                        text:'(zum Repository)',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.blueAccent),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () async {
                            const url = 'https://github.com/Avazz225/bluBlock';
                            await launchUrl(
                              Uri.parse(url),
                              mode: LaunchMode.externalApplication
                            );
                          },
                    ),
                    TextSpan(text:'''. Bitte beachte, dass ungefragt keine Plagiate der Software angefertigt werden dürfen.''', style: Theme.of(context).textTheme.bodyMedium),
                  ]
                ),
              ),
              const Text('\n'),
            ],
          )
        )
      )
    );
  }
}