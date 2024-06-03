import 'package:flutter/material.dart';

class DataSecurity extends StatelessWidget{
  const DataSecurity({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Datenschutz"),
      ),
      body: const SingleChildScrollView(
        child:Padding(
          padding: EdgeInsets.symmetric(horizontal: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Welche Daten werden von mir erhoben?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''BluBlock selbst erhebt keine Daten, außer von Auswertungen der anonymen Logs des Content Delivery Networks. Alle Datenerhebungen, die eventuell durchgeführt werden, kommen von den Social Media Plattformen. Auf diese Informationen hat BluBlock keinen Zugriff.'''),
              Text('\n'),
              Text('Wo kommen die Blocklisten her?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''Die Blocklisten kommen von unserem Content Delivery Network. Dafür wird keine Authentifizierung benötigt. Es kann also jede Person von überall auf der Welt auf die Listen zugreifen. Hierbei wird BluBlock nicht zuordnen, wer auf die Daten zugegriffen hat.'''),
              Text('\n'),
              Text('Wie lang werden die anonymen Logs des Content Delivery Networks aufgehoben?', style: TextStyle(fontWeight: FontWeight.bold)),
              Text(''),
              Text('''So kurz wie möglich. Die Logs liegen ca. 2 Wochen vor und werden danach gelöscht.\nDie Metadaten der Anforderungen werden zur Auswertung längerfristig gespeichert. Dabei handelt es sich aber nur um Zahlen ohne weiteren Informationsgehalt.\nSpätestens nach 2 Wochen ist ein Zuordnen der Anfragen also absolut ausgeschlossen.'''),
              Text('\n'),
            ],
          )
        )
      )
    );
  }
}