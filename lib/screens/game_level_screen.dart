import 'package:recycle_game/widgets/controls_widget.dart';
import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/widgets/levels_widgets/belt_level_widget.dart';
import 'package:recycle_game/widgets/levels_widgets/basic_level_widget.dart';
import 'package:recycle_game/widgets/levels_widgets/waterfall_level_widget.dart';
import 'package:recycle_game/widgets/levels_widgets/collection_level_widget.dart';
import 'package:recycle_game/screens/game_areas_screen.dart';
import 'package:recycle_game/screens/welcome_screen.dart';
import 'package:flutter/material.dart';

class GameLevelScreen extends StatefulWidget {
  final int gameMapID;
  final int gameLevelID;

  GameLevelScreen(this.gameMapID, this.gameLevelID, {Key key})
      : super(key: key);

  @override
  _GameLevelScreenState createState() => _GameLevelScreenState();
}

class _GameLevelScreenState extends State<GameLevelScreen>
    with WidgetsBindingObserver {
  GameLevel gameLevel;
  Widget gamelevelWidget;
  bool gameFinished = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      AppData.cycleState(state);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    gameLevel =
        AppData.gameManager.getGameLevel(widget.gameMapID, widget.gameLevelID);
    switch (gameLevel.type) {
      case LevelType.BASIC:
        gamelevelWidget = BasicLevelWidget(gameLevel, gameFinishAction);
        break;
      case LevelType.BELT:
        gamelevelWidget = BeltLevelWidget(gameLevel, gameFinishAction);
        break;
      case LevelType.WATERFALL:
        gamelevelWidget = WaterfallLevelWidget(gameLevel, gameFinishAction);
        break;
      case LevelType.COLLECTION:
        gamelevelWidget = CollectionLevelWidget(gameLevel, gameFinishAction);
        break;
      default:
        throw Exception("Game type ${gameLevel.type} is not supported");
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("update screen");
    return Scaffold(
        body: SafeArea(
            child: gameFinished
                ? finishedGameWidget()
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(gameLevel.bgPath))),
                    child: Stack(children: [
                      gamelevelWidget,
                      ControlsWidget(updateMe, exitAction)
                    ]))));
  }

  void exitAction() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => GameAreasScreen()),
        (Route<dynamic> route) => false);
  }

  void updateMe() => setState(() {});

  void gameFinishAction() {
    AppData.audioManager.pauseBg();
    if (gameLevel.levelSucceeded) {
      AppData.audioManager.playWin();
      AppData.gameManager.nextLevel(widget.gameMapID, widget.gameLevelID);
    } else
      AppData.audioManager.playLose();

    setState(() {
      gameFinished = true;
    });
  }

  Widget finishedGameWidget() => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: Image(
                    image: AssetImage('assets/finish_screen/top_' +
                        (gameLevel.levelSucceeded ? 'win' : 'lose') +
                        '.png'),
                    fit: BoxFit.fill),
              ),
            ),
            Flexible(
              child: Image(
                  image: AssetImage('assets/finish_screen/girl_' +
                      (gameLevel.levelSucceeded ? 'win' : 'lose') +
                      '.png'),
                  fit: BoxFit.fill),
            ),
            Flexible(
              child: GestureDetector(
                onTap: () {
                  AppData.audioManager.playBgLoop();

                  if (gameLevel.levelSucceeded &
                      AppData.gameManager.isLastLevelReached)
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => WelcomeScreen()),
                        (Route<dynamic> route) => false);
                  else if (gameLevel.levelSucceeded) {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => GameAreasScreen()),
                        (Route<dynamic> route) => false);
                  } else
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => GameLevelScreen(
                                widget.gameMapID, widget.gameLevelID)),
                        (Route<dynamic> route) => false);
                },
                child: Image(
                    image: AssetImage('assets/finish_screen/button_' +
                        (gameLevel.levelSucceeded &
                                AppData.gameManager.isLastLevelReached
                            ? 'home'
                            : gameLevel.levelSucceeded
                                ? 'win'
                                : 'lose') +
                        '.png'),
                    fit: BoxFit.fill),
              ),
            ),
          ],
        ),
      );
}
