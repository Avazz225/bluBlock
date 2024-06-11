import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/import_list.dart';
import 'package:BluBlock/classes/settings.dart';
import 'package:BluBlock/classes/url.dart';
import 'package:BluBlock/js_logic/insta_logic.dart';
import 'package:BluBlock/js_logic/tiktok_logic.dart';
import 'package:BluBlock/js_logic/x_logic.dart';
import 'package:BluBlock/ui/components/background.dart';
import 'package:BluBlock/ui/components/button.dart';
import 'package:BluBlock/ui/components/dropdown.dart';
import 'package:BluBlock/ui/pages/login_web_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/pop_up.dart';

class SettingsPage extends StatefulWidget  {
  const SettingsPage({super.key});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final DatabaseHelper _db = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<Settings>(context);
    final TextEditingController maxBatchSizeController = TextEditingController(text: "${settings.maxBatchSize}");
    final TextEditingController minWaitController = TextEditingController(text: "${(settings.waitSecondsMin).round()}");
    final TextEditingController maxWaitController = TextEditingController(text: "${(settings.waitSecondsMax).round()}");

    return(
      Scaffold(
        appBar: AppBar(
          title: const Text("Einstellungen"),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: BackgroundPainter(),
              ),
            ),
            Center(
              child:SingleChildScrollView(
                child:Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      Title(color: Colors.cyan, child: const Text("Login Status", style: TextStyle(fontSize: 20))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Facebook"),
                          CustomButton(text: (settings.facebookLoggedIn)?"Ausloggen":"Einloggen", onClick: _dummyFunction),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Instagram (+ Threads)"),
                          CustomButton(text: (settings.instaLoggedIn)?"Ausloggen":"Einloggen", onClick: _loginInstagram),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("TikTok"),
                          CustomButton(text: (settings.tiktokLoggedIn)?"Ausloggen":"Einloggen", onClick: _dummyFunction),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("X (ehem. Twitter)"),
                          CustomButton(text: (settings.xLoggedIn)?"Ausloggen":"Einloggen", onClick: _loginX),
                        ],
                      ),
                      Title(color: Colors.cyan, child: const Text("Einstellungen", style: TextStyle(fontSize: 20))),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Blocklevel"),
                              Text("(Auswahl und darüber)", style: TextStyle(fontSize: 12),)
                            ],
                          ),
                          DropdownComponent(defaultValue: settings.blockLevel)
                        ]
                      ),
                      /*Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Arbeitszeit"),
                          SizedBox(
                            width: 110,
                            child:Column(
                              children: [
                                TimePickerComponent(initialSeconds: settings.workWindowStart, variableName: "workWindowStart"),
                                const Text("bis"),
                                TimePickerComponent(initialSeconds: settings.workWindowEnd, variableName: "workWindowEnd"),
                              ]
                            )
                          ),
                        ],
                      ),*/
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Paketgröße"),
                          SizedBox(
                            width: 110,
                            child:Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 75,
                                  child:TextField(
                                    textAlign: TextAlign.center,
                                    controller: maxBatchSizeController,
                                    keyboardType: TextInputType.number,
                                    decoration: InputDecoration(
                                      filled: true,
                                      fillColor: Colors.grey.withOpacity(.15) ,
                                      border: const OutlineInputBorder(),
                                    ),
                                    onEditingComplete: () {
                                      int newValue = int.tryParse(maxBatchSizeController.text) ?? settings.maxBatchSize;
                                      settings.updateValue('maxBatchSize', newValue);
                                      FocusScope.of(context).unfocus(); // Schließt die Tastatur
                                    },
                                  ),
                                ),
                              ]
                            )
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Wartezeit in Sekunden (min 15)"),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              SizedBox(
                                width: 50,
                                child:TextField(
                                  textAlign: TextAlign.center,
                                  controller: minWaitController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(.15) ,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onEditingComplete: () {
                                    int newValue = int.tryParse(minWaitController.text) ?? settings.waitSecondsMin;
                                    settings.updateValue('waitSecondsMin', newValue);
                                    FocusScope.of(context).unfocus(); // Schließt die Tastatur
                                  },
                                ),
                              ),
                              const Text(" bis "),
                              SizedBox(
                                width: 50,
                                child:TextField(

                                  textAlign: TextAlign.center,
                                  controller: maxWaitController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey.withOpacity(.15) ,
                                    border: const OutlineInputBorder(),
                                  ),
                                  onEditingComplete: () {
                                    int newValue = int.tryParse(maxWaitController.text) ?? settings.waitSecondsMax;
                                    settings.updateValue('waitSecondsMax', newValue);
                                    FocusScope.of(context).unfocus(); // Schließt die Tastatur
                                  },
                                ),
                              ),
                            ]
                          )
                        ],
                      ),
                      const Text(""),
                      if (settings.facebookLoggedIn || settings.tiktokLoggedIn || settings.xLoggedIn || settings.instaLoggedIn)
                        Column(
                          children: [
                            CustomButton(text: "Liste(n) aktualisieren", onClick: _startListRefresh),
                            Text("Zuletzt aktualisiert am ${DateFormat('dd.MM.yyyy \'um\' HH:mm:ss').format(settings.lastFileRefresh)}", style: const TextStyle(fontSize: 12))
                          ],
                        )
                    ]
                  )
                )
              )
            )
          ]
        )
      )
    );
  }
  _dummyFunction(){
    String title = "Noch nicht vorhanden";
    String msg = "Diese Funktion steht bisher nur für Instagram und X bereit.";
    showMessage(context, msg, title);
  }

  _startListRefresh() async {
    DateTime lastTime = DateTime.tryParse((await _db.readDB("configuration", ["last_file_refresh"], "1 = ?", [1], "last_file_refresh ASC", 1))[0]["last_file_refresh"])!;
    DateTime now = DateTime.now();
    if (now.isAfter(lastTime.add(const Duration(days: 1)))){
      ImportList importer = ImportList();
      int result = await importer.executeImport();
      int totalCount = await _db.getCount('account', ['COUNT(*)'], '1 = ?', [1], 'id ASC', 1);
      String title = "Import abgeschlossen";
      String msg = "Es wurden $result neue Einträge importiert.\nEs existieren jetzt $totalCount Einträge.";
      // ignore: use_build_context_synchronously
      showMessage(context, msg, title);
    } else {
      Duration difference = now.difference(lastTime.add(const Duration(days: 1)));
      int hours = difference.inHours * -1;
      int minutes = difference.inMinutes.remainder(60) * -1;
      String title = "Nicht verfügbar";
      String msg = "Du kannst nur alle 24h einen Import durchführen.\nBitte warte noch ${hours.toString().padLeft(2, '0')} Stunde(n) und ${minutes.toString().padLeft(2, '0')} Minute(n).";
      // ignore: use_build_context_synchronously
      showMessage(context, msg, title);
    }
  }

  _loginInstagram() async {
    String initialUrl = (await Url().getPlatformUrl(2));
    Navigator.push(
      // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginWebView(initialUrl: initialUrl, jsLogic: instaLoginLogic, platform: "instagram"))
    );
  }

  _loginTikTok() async {
    String initialUrl = (await Url().getPlatformUrl(3));
    Navigator.push(
      // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginWebView(initialUrl: initialUrl, jsLogic: tiktokLoginLogic, platform: "tiktok"))
    );
  }

  _loginX() async {
    String initialUrl = (await Url().getPlatformUrl(4));
    Navigator.push(
      // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginWebView(initialUrl: initialUrl, jsLogic: xLoginLogic, platform: "x"))
    );
  }
}