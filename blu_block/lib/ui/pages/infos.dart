import 'package:flutter/material.dart';

class InfoPage extends StatelessWidget{
  const InfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Hinweise"),
      ),
      body: const SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Kann mein Konto durch Nutzung von BluBlock gesperrt werden?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''Ja, das ist prinzipiell möglich.'''),
              Text('''Wir versuchen aber das zu verhindern. Darum haben wir standardmäßig kleine Blockpakete und zusätzliche randomisierte Wartezeiten eingebaut (Diese können auch angepasst werden!).\nDennoch können wir nicht versprechen, dass die Plattformen keine Konten sperren oder zumindest einschränken.'''),
              Text('\n'),
              Text('Haftet der Softwarehersteller für eventuelle Schäden oder den Verlust von Accounts?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''Nein, BluBlock zu nutzen erfolgt auf eigene Verantwortung.'''),
              Text('''BluBlock ist nur ein Werkzeug, das jedem/r zur Verfügung gestellt wird.\nFür eventuelle Schäden jeglicher Art haftet der/die Anwendende selbst.\nWir empfehlen daher die Blockvorgänge in einem langsamen Rhythmus auszuführen, wie er Standardmäßig eingestellt ist. Aber auch die Einstellung ist keine Garantie dafür, dass keine Schäden entstehen.'''),
              Text('\n'),
              Text('Ist BluBlock ein Werkzeug um politischen Einfluss zu nehmen?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''Nein.'''),
              Text('''BluBlock ist auch nicht durch Dritte finanziert. Es ist ein Moderationstool für den eigenen Algorithmus und wirkt sich primär nur auf den eigenen Account aus.\nOb die Plattformen als Reaktion auf die Blocks weitere Effekte zeigen, ist weder bekannt, noch ist so etwas beabsichtigt.'''),
              Text('\n'),
              Text('Wenn BluBlock keinen politischen Einfluss nimmt, warum wird nur eine politische Gruppe blockiert?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''Grund dafür ist, den eigenen Algorithmus aufzuräumen. Die starke Fokussierung kommt von der Präsenz jener Gruppe auf Social Media, die sich mitunter negativ auf das eigene Wohlbefinden auswirken kann.'''),
              Text('\n'),
            ],
          )
        )
      )
    );
  }
}