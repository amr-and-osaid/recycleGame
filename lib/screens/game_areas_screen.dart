import 'package:recycle_game/widgets/controls_widget.dart';
import 'package:recycle_game/screens/welcome_screen.dart';
import 'package:recycle_game/screens/game_level_screen.dart';
import 'package:flutter/material.dart';
import 'package:recycle_game/app_data.dart';

class GameAreasScreen extends StatefulWidget {
  GameAreasScreen({Key key}) : super(key: key);

  @override
  _GameAreasScreenState createState() => _GameAreasScreenState();
}

class LevelMark {
  int areaID;
  int levelID;

  bool open = false;
  bool passed = false;
  bool current = false;
  double x;
  double y;

  LevelMark(this.areaID, this.levelID, this.x, this.y) {
    if (levelID <= AppData.gameManager.currentLevelID) open = true;
    if (levelID < AppData.gameManager.currentLevelID) passed = true;
    if (levelID == AppData.gameManager.currentLevelID) current = true;
    open = true;
  }
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (open) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => GameLevelScreen(areaID, levelID)),
              (Route<dynamic> route) => false);
        }
      },
      child: Stack(
        children: [
          Align(
              alignment: Alignment(x, y),
              child: Container(
                width: 60,
                height: 50,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Icon(Icons.circle,
                              size: 30,
                              color: open ? Colors.purple : Colors.black),
                          Text((levelID + 1).toString(),
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.topCenter,
                        child: passed
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/recycle/5.png'),
                                          width: 20,
                                          height: 20)),
                                  Image(
                                      image: AssetImage('assets/recycle/5.png'),
                                      width: 20,
                                      height: 20),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Image(
                                        image:
                                            AssetImage('assets/recycle/5.png'),
                                        width: 20,
                                        height: 20),
                                  ),
                                ],
                              )
                            : current
                                ? Icon(Icons.face_sharp)
                                : SizedBox(width: 0))
                  ],
                ),
              )),
        ],
      ),
    );
  }
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
                children: List<Widget>.generate(
                    AppData.gameManager.gameAreas.length,
                    (areaID) => Container(
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: AssetImage(AppData
                                      .gameManager.gameAreas[areaID].bgPath))),
                          child: Stack(
                              children: List<Widget>.generate(
                                  AppData.gameManager.gameAreas[areaID].levels
                                      .length,
                                  (gameLevelID) => LevelMark(
                                          areaID,
                                          gameLevelID,
                                          AppData.gameManager.gameAreas[areaID]
                                              .levels[gameLevelID].xLocInMap,
                                          AppData.gameManager.gameAreas[areaID]
                                              .levels[gameLevelID].yLocInMap)
                                      .getWidget(context)).toList()),
                        )).toList()),
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
