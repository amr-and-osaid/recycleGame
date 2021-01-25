import 'package:cleanWise/screens/finish_screen.dart';
import 'package:cleanWise/screens/main_screen.dart';
import 'package:cleanWise/screens/welcome_screen.dart';
import 'package:cleanWise/app_data.dart';
import 'package:flutter/material.dart';

class RootScreen extends StatefulWidget {
  RootScreen({Key key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> with WidgetsBindingObserver {
  bool _welcome = true;
  bool _gameStarted = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppData.gameManager.playBgLoop();
        break;
      case AppLifecycleState.inactive:
        AppData.gameManager.pauseBg();
        break;
      case AppLifecycleState.paused:
        AppData.gameManager.pauseBg();
        break;
      case AppLifecycleState.detached:
        AppData.gameManager.pauseBg();
        break;
    }
  }

  void startGame() => setState(() {
        _gameStarted = true;
        _welcome = false;
      });

  void finishGame() => setState(() {
        _gameStarted = false;
        _welcome = false;
      });

  void exitGame() => setState(() {
        _gameStarted = false;
        _welcome = true;
      });

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppData.gameManager.playBgLoop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _welcome
        ? WelcomeScreen(startGame)
        : _gameStarted
            ? MainScreen(finishGame, exitGame)
            : FinishScreen(startGame);
  }
}
