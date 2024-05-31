import 'package:BluBlock/classes/database.dart';
import 'package:BluBlock/classes/import_list.dart';
import 'package:BluBlock/classes/settings.dart';
import 'package:BluBlock/classes/url.dart';
import 'package:BluBlock/js_logic/insta_logic.dart';
import 'package:BluBlock/ui/components/background.dart';
import 'package:BluBlock/ui/components/button.dart';
import 'package:BluBlock/ui/components/dropdown.dart';
import 'package:BluBlock/ui/pages/login_web_view.dart';
import 'package:BluBlock/ui/components/time_picker.dart';
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
    final TextEditingController minWaitController = TextEditingController(text: "${(settings.waitSecondsMin/60).round()}");
    final TextEditingController maxWaitController = TextEditingController(text: "${(settings.waitSecondsMax/60).round()}");

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
                          (settings.facebookLoggedIn)?CustomButton(text: "Ausloggen", onClick: _dummyFunction) : CustomButton(text: "Einloggen", onClick: _dummyFunction),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Instagram (+ Threads)"),
                          (settings.instaLoggedIn)?CustomButton(text: "Ausloggen", onClick: _dummyFunction) : CustomButton(text: "Einloggen", onClick: _loginInstagram),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("TikTok"),
                          (settings.tiktokLoggedIn)?CustomButton(text: "Ausloggen", onClick: _dummyFunction) : CustomButton(text: "Einloggen", onClick: _dummyFunction),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("X (ehem. Twitter)"),
                          (settings.xLoggedIn)?CustomButton(text: "Ausloggen", onClick: _dummyFunction) :  CustomButton(text: "Einloggen", onClick: _dummyFunction),
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
                      Row(
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
                      ),
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
                          const Text("Wartezeit in Minuten (min 5)"),
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
                                    settings.updateValue('waitSecondsMin', newValue*60);
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
                                    settings.updateValue('waitSecondsMax', newValue*60);
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
    String msg = "Diese Funktion steht bisher nur für Instagram bereit.";
    showMessage(context, msg, title);
  }

  _startListRefresh() async {
    ImportList importer = ImportList();
    int result = await importer.executeImport();
    int totalCount = await _db.getCount('account', ['COUNT(*)'], '1 = ?', [1], 'id ASC', 1);
    String title = "Import abgeschlossen";
    String msg = "Es wurden $result neue Einträge importiert.\nEs existieren jetzt $totalCount Einträge.";
    // ignore: use_build_context_synchronously
    showMessage(context, msg, title);
  }

  _loginInstagram() async {
    String initialUrl = (await Url().getPlatformUrl(2));
    Navigator.push(
      // ignore: use_build_context_synchronously
        context,
        MaterialPageRoute(builder: (context) => LoginWebView(initialUrl: initialUrl, jsLogic: instaLoginLogic, platform: "instagram"))
    );
  }
}