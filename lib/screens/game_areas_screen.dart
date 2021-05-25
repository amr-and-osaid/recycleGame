import 'dart:math';

import 'package:recycle_game/widgets/controls_widget.dart';
import 'package:recycle_game/screens/welcome_screen.dart';
import 'package:recycle_game/screens/game_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/widgets/levelmark_widget.dart';

import '../logic/game_area.dart';
import '../logic/game_level.dart';

class GameAreasScreen extends StatefulWidget {
  GameAreasScreen({Key key}) : super(key: key);

  @override
  _GameAreasScreenState createState() => _GameAreasScreenState();
}

class _GameAreasScreenState extends State<GameAreasScreen>
    with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      AppData.cycleState(state);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AppData.audioManager.playBgLoop();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
                reverse: true,
                children: AppData.gameManager.gameAreas
                    .map((gameArea) => Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(gameArea.bgPath))),
                          child: Stack(
                              children: gameArea.levels
                                  .map((gameLevel) =>
                                      LevelMark(gameArea, gameLevel))
                                  .toList()),
                        ))
                    .toList()),
            ControlsWidget(updateMe, exitAction)
          ],
        ));
  }

  void exitAction() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => WelcomeScreen()),
        (Route<dynamic> route) => false);
  }

  void updateMe() => setState(() {});
}
