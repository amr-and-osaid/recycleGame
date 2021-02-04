import 'dart:async';

import 'package:cleanWise/app_data.dart';
import 'package:cleanWise/logic/game_level.dart';
import 'package:cleanWise/screens/finish_screen.dart';
import 'package:cleanWise/screens/welcome_screen.dart';
import 'package:cleanWise/screens/widgets/controls_widget.dart';
import 'package:cleanWise/screens/widgets/type1_game_widget.dart';
import 'package:cleanWise/screens/widgets/type2_game_widget.dart';
import 'package:cleanWise/screens/widgets/trash_widget.dart';
import 'package:cleanWise/screens/widgets/progress_widget.dart';
import 'package:flutter/material.dart';

class GameScreen extends StatefulWidget {
  GameScreen({Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
  GameLevel game;
  bool _showCloseConfirm = false;
  Timer _gameTimer;
  int trashFinished = 0;
  int correctResult = 0;
  List<int> trashIDs = [];
  List<int> trashIDsDragged = [];
  int _curSec = 0;

  //for game type MOVING
  Timer _movingTimer;
  double _align = 1;
  double _offset = 0.1;
  EntranceState _state = EntranceState.ENTER;
  bool _pauseTimer = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        AppData.audioManager.playBgLoop();
        break;
      case AppLifecycleState.inactive:
        AppData.audioManager.pauseAll();
        break;
      case AppLifecycleState.paused:
        AppData.audioManager.pauseAll();
        break;
      case AppLifecycleState.detached:
        AppData.audioManager.pauseAll();
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    game = AppData.gameManager.currentLevel;
    trashIDs = game.trashIDs;
    if (game.type == LevelType.TIMED) {
      _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _curSec++;
        });

        if (_curSec >= game.durationinSec) {
          _gameTimer.cancel();
          bool win = game.isWin;
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => FinishScreen(win)),
              (Route<dynamic> route) => false);
          game.resetGame();
        }
      });
    } else if (game.type == LevelType.MOVING) {
      _movingTimer =
          Timer.periodic(Duration(milliseconds: game.movingSpeed), (timer) {
        if (_pauseTimer) return;
        setState(() {
          if (_state == EntranceState.ENTER) {
            _offset += 0.01;
            if (_offset >= 1) {
              _state = EntranceState.NONE;
              _offset = 1;
            }
          } else if (_state == EntranceState.NONE) {
            _align -= 0.01;
            if (_align <= -1) {
              _state = EntranceState.EXIT;
            }
          } else if (_state == EntranceState.EXIT) {
            _offset -= 0.01;
            if (_offset <= 0) {
              _state = EntranceState.ENTER;
              _offset = 0.01;
              _align = 1;
              _checkResults(trashIDs.length > 0 ? trashIDs[0] : 0, false);
            }
          }
        });
      });
    }
  }

  @override
  void dispose() {
    if (_gameTimer != null) _gameTimer.cancel();
    if (_movingTimer != null) _movingTimer.cancel();
    super.dispose();
  }

  void updateMe() => setState(() {});

  void exit() {
    setState(() {
      _showCloseConfirm = true;
    });
  }

  void onDrag() {
    setState(() {
      _pauseTimer = true;
    });
  }

  void onDragCancelled() {
    setState(() {
      _pauseTimer = false;
    });
  }

  void _checkResults(int trashID, bool correct) {
    trashFinished++;
    if (correct) correctResult++;

    setState(() {
      trashIDsDragged.add(trashID);
    });

    if (trashFinished < game.nTrashAtOnce) return;

    setState(() {
      game.setProgressAndGoNext(correctResult >= game.nTrashAtOnce);
      _pauseTimer = false;
      _state = EntranceState.ENTER;
      _offset = 0.1;
      _align = 1;
    });

    trashFinished = 0;
    correctResult = 0;
    trashIDsDragged.clear();
    trashIDs = game.trashIDs;

    if (game.isEndOfGame) {
      if (_gameTimer != null) _gameTimer.cancel();
      Timer(Duration(milliseconds: 500), () {
        bool win = game.isWin;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => FinishScreen(win)),
            (Route<dynamic> route) => false);
        game.resetGame();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
            child: Stack(children: [
          Column(children: [
            Flexible(
                flex: 20,
                child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(children: [
                      Flexible(
                          flex: 1,
                          child: game.type == LevelType.BASIC ||
                                  game.type == LevelType.MOVING
                              ? ProgressWidget(game).getBasicWidget()
                              : ProgressWidget(game).getTimedWidget(_curSec)),
                      Flexible(flex: 1, child: ControlsWidget(updateMe, exit))
                    ]))),
            Flexible(
                flex: 80,
                child: game.type == LevelType.MOVING
                    ? Type2GameWidget(
                            game,
                            _checkResults,
                            trashIDs,
                            trashIDsDragged,
                            onDrag,
                            onDragCancelled,
                            _align,
                            _offset,
                            _state)
                        .getWidget()
                    : Type1GameWidget(
                            game, _checkResults, trashIDs, trashIDsDragged)
                        .getWidget()),
          ]),
          ..._showCloseConfirm
              ? [
                  Opacity(opacity: 0.6, child: Container(color: Colors.black)),
                  Center(
                      child: GestureDetector(
                          onTap: () {
                            game.resetGame();
                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                    builder: (context) => WelcomeScreen()),
                                (Route<dynamic> route) => false);
                          },
                          child: Image(
                            gaplessPlayback: true,
                            image:
                                AssetImage('assets/controls/close_confirm.png'),
                          )))
                ]
              : [Center()]
        ])));
  }
}
