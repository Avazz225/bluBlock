import 'package:BluBlock/classes/account_overview.dart';
import 'package:BluBlock/classes/block_executor.dart';
import 'package:BluBlock/ui/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'classes/block_progress.dart';
import 'classes/settings.dart';
import 'classes/url.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  MainAppState createState() => MainAppState();
}

class MainAppState extends State<MainApp> {
  final Settings settings = Settings();
  final BlockProgress progress = BlockProgress();
  final AccountOverview accounts = AccountOverview();
  final BlockExecutor blockExecutor = BlockExecutor();
  final Url url = Url();

  @override
  void initState() {
    super.initState();
    _initializeStates();
  }

  Future<void> _initializeStates() async {
    await settings.initialize();
    await progress.initialize();
    await accounts.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => BlockProgress()),
        ChangeNotifierProvider(create: (context) => AccountOverview()),
        ChangeNotifierProvider(create: (context) => Settings()),
        ChangeNotifierProvider(create: (context) => BlockExecutor()),
      ],
      child:MaterialApp(
        title: "BluBlock",
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          brightness: Brightness.dark,
        ),
        themeMode: ThemeMode.system,
        home: const HomePage(),
      )
    );
  }
}