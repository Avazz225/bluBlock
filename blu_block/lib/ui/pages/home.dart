import 'package:BluBlock/classes/block_executor.dart';
import 'package:BluBlock/ui/components/button.dart';
import 'package:BluBlock/ui/pages/data_security.dart';
import 'package:BluBlock/ui/pages/infos.dart';
import 'package:BluBlock/ui/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../classes/block_progress.dart';
import '../components/background.dart';
import '../components/circular_progress_painter.dart';
import 'list_page.dart';

class HomePage extends StatefulWidget  {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  BlockProgress progressTracker = BlockProgress();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  dispose(){
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final blockExecutor = Provider.of<BlockExecutor>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("BluBlock"),
        actions: [
          PopupMenuButton<String>(
            onSelected: (String result) {
              switch (result) {
                case 'list':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ListPage()),
                  );
                  break;
                case 'settings':
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SettingsPage()),
                  );
                  break;
              case 'notes':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InfoPage())
                );
                break;
              case 'datasecurity':
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DataSecurity()),
                );
                break;
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'list',
                child: Text('Accountliste'),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Text('Einstellungen'),
              ),
              const PopupMenuItem<String>(
                value: 'notes',
                child: Text('Hinweise'),
              ),
              const PopupMenuItem<String>(
                value: 'datasecurity',
                child: Text('Datenschutz'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: BackgroundPainter(),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Gesamtfortschritt',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                CircularProgressIndicatorWrapper(blockExecutor.getBlockActive()),
                const SizedBox(height: 80,),
                CustomButton(
                  text: (blockExecutor.getBlockActive()?"Blocken stoppen":"Blocken starten"),
                  onClick: () => {
                    blockExecutor.toggleBlockActive(),
                  }
                )
              ],
            ),
          ),
        ]
      ),
    );
  }
}

class CircularProgressIndicatorWrapper extends StatelessWidget {
  final bool blockActive;
  const CircularProgressIndicatorWrapper(this.blockActive, {super.key});

  @override
  Widget build(BuildContext context) {
    final progressTracker = Provider.of<BlockProgress>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CircularProgressIndicatorWidget(
          progress: (progressTracker.totalCount != 0) ? (progressTracker.blockedCount / progressTracker.totalCount) : 1,
          failedProgress: (progressTracker.totalCount != 0) ? (progressTracker.missedCount / progressTracker.totalCount) : 0,
          valueX: progressTracker.blockedCount,
          valueY: progressTracker.totalCount,
          valueZ: progressTracker.missedCount,
          blockingActive: blockActive,
        ),
      ],
    );
  }
}