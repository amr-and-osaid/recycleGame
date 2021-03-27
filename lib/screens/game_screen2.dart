// import 'dart:async';
// import 'dart:math';

// import 'package:recycle_game/app_data.dart';
// import 'package:recycle_game/logic/game_level.dart';
// import 'package:recycle_game/model/waste.dart';
// import 'package:recycle_game/screens/finish_screen.dart';
// import 'package:recycle_game/screens/welcome_screen.dart';
// import 'package:recycle_game/screens/widgets/controls_widget.dart';
// import 'package:recycle_game/screens/widgets/type1_game_widget.dart';
// import 'package:recycle_game/screens/widgets/type2_game_widget.dart';
// import 'package:recycle_game/screens/widgets/waste_widget.dart';
// import 'package:recycle_game/screens/widgets/progress_widget.dart';
// import 'package:flutter/material.dart';

// class GameScreen extends StatefulWidget {
//   final int levelID;
//   GameScreen(this.levelID, {Key key}) : super(key: key);

//   @override
//   _GameScreenState createState() => _GameScreenState();
// }

// class _GameScreenState extends State<GameScreen> with WidgetsBindingObserver {
//   GameLevel game;
//   bool _showCloseConfirm = false;
//   Timer _gameTimer;
//   int trashFinished = 0;
//   int correctResult = 0;
//   List<Waste> wastes = [];
//   List<int> wastesDragged = [];
//   int _curSec = 0;

//   //for game type MOVING
//   Timer _movingTimer;
//   Timer _feedbackTimer;
//   double _align = 1;
//   double _offset = 0.1;
//   EntranceState _state = EntranceState.ENTER;
//   bool _pauseTimer = false;
//   double _feedbackOffset = 0;
//   String _girlImage = 'assets/side_girl/good_1.png';

//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     switch (state) {
//       case AppLifecycleState.resumed:
//         AppData.audioManager.playBgLoop();
//         break;
//       case AppLifecycleState.inactive:
//         AppData.audioManager.pauseAll();
//         break;
//       case AppLifecycleState.paused:
//         AppData.audioManager.pauseAll();
//         break;
//       case AppLifecycleState.detached:
//         AppData.audioManager.pauseAll();
//         break;
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//     game = AppData.gameManager.getLevel(widget.levelID);
//     wastes = game.wastes;

//     if (game.type == LevelType.TIMED) {
//       _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
//         setState(() {
//           _curSec++;
//         });

//         if (_curSec >= game.levelDuration) {
//           _gameTimer.cancel();
//           bool win = game.isWin;
//           Navigator.of(context).pushAndRemoveUntil(
//               MaterialPageRoute(
//                   builder: (context) => FinishScreen(widget.levelID, win)),
//               (Route<dynamic> route) => false);
//           game.setupLevel();
//         }
//       });
//     } else if (game.type == LevelType.MOVING) {
//       _movingTimer = Timer.periodic(
//           Duration(milliseconds: (game.movingDuration / 400).floor()), (timer) {
//         if (_pauseTimer) return;
//         setState(() {
//           if (_state == EntranceState.ENTER) {
//             _offset += 0.01;
//             if (_offset >= 1) {
//               _state = EntranceState.NONE;
//               _offset = 1;
//             }
//           } else if (_state == EntranceState.NONE) {
//             _align -= 0.01;
//             if (_align <= -1) {
//               _state = EntranceState.EXIT;
//             }
//           } else if (_state == EntranceState.EXIT) {
//             _offset -= 0.01;
//             if (_offset <= 0) {
//               _state = EntranceState.ENTER;
//               _offset = 0.01;
//               _align = 1;
//               _checkResults(wastes.length > 0 ? wastes[0] : 0, false);
//             }
//           }
//         });
//       });
//     }
//   }

//   @override
//   void dispose() {
//     if (_gameTimer != null) _gameTimer.cancel();
//     if (_movingTimer != null) _movingTimer.cancel();
//     super.dispose();
//   }

//   void updateMe() => setState(() {});

//   void showFeedback(bool good) {
//     if (_feedbackTimer == null) {
//       int rand = Random().nextInt(4) + 1;
//       _girlImage =
//           'assets/side_girl/' + (good ? 'good_$rand' : 'bad_$rand') + '.png';
//       _feedbackTimer = Timer.periodic(Duration(milliseconds: 2), (timer) {
//         if (_pauseTimer) return;
//         setState(() {
//           _feedbackOffset += 0.01;
//           if (_feedbackOffset >= 1) {
//             _feedbackOffset = 1;
//             _feedbackTimer.cancel();
//             Timer(Duration(milliseconds: 500), () {
//               _feedbackTimer =
//                   Timer.periodic(Duration(milliseconds: 2), (timer) {
//                 if (_pauseTimer) return;
//                 setState(() {
//                   _feedbackOffset -= 0.01;
//                   if (_feedbackOffset <= 0) {
//                     _feedbackOffset = 0;
//                     _feedbackTimer.cancel();
//                     _feedbackTimer = null;
//                   }
//                 });
//               });
//             });
//           }
//         });
//       });
//     }
//   }

//   void exit() {
//     setState(() {
//       _showCloseConfirm = true;
//     });
//   }

//   void onDrag() {
//     // setState(() {
//     //   _pauseTimer = true;
//     // });
//   }

//   void onDragCancelled() {
//     // setState(() {
//     //   _pauseTimer = false;
//     // });
//   }

//   void _checkResults(int trashID, bool correct) {
//     trashFinished++;
//     if (correct) correctResult++;

//     setState(() {
//       wastesDragged.add(trashID);
//     });

//     if (trashFinished < game.numWastes) return;

//     setState(() {
//       game.recordScore(correctResult >= game.numWastes);
//       if (game.consecutiveMistakesCounter == 2 && !game.isEndOfGame) {
//         showFeedback(false);
//         game.consecutiveMistakesCounter = 0;
//       } else if (game.consecutiveCorrectsCounter == 5 && !game.isEndOfGame) {
//         showFeedback(true);
//         game.consecutiveCorrectsCounter = 0;
//       }
//       _pauseTimer = false;
//       _state = EntranceState.ENTER;
//       _offset = 0.1;
//       _align = 1;
//     });

//     trashFinished = 0;
//     correctResult = 0;
//     wastesDragged.clear();
//     wastes = game.wastes;

//     if (game.isEndOfGame) {
//       if (_gameTimer != null) _gameTimer.cancel();
//       Timer(Duration(milliseconds: 500), () {
//         bool win = game.isWin;
//         Navigator.of(context).pushAndRemoveUntil(
//             MaterialPageRoute(
//                 builder: (context) => FinishScreen(widget.levelID, win)),
//             (Route<dynamic> route) => false);
//         game.setupLevel();
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         // backgroundColor: Colors.purple[100],
//         body: SafeArea(
//             child: Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               fit: BoxFit.fill, image: AssetImage('assets/maps/11.png'))),
//       child: Stack(children: [
//         Column(children: [
//           Container(
//             color: Colors.purple,
//             height: 50,
//             child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(children: [
//                   Flexible(
//                       flex: 2,
//                       child: game.type == LevelType.BASIC ||
//                               game.type == LevelType.MOVING
//                           ? ProgressWidget(game).getBasicWidget()
//                           : ProgressWidget(game).getTimedWidget(_curSec)),
//                   Flexible(flex: 1, child: ControlsWidget(updateMe, exit))
//                 ])),
//           ),
//           Flexible(
//               child: game.type == LevelType.MOVING
//                   ? Type2GameWidget(game, _checkResults, wastes, wastesDragged,
//                           onDrag, onDragCancelled, _align, _offset, _state)
//                       .getWidget()
//                   : BasicLevelWidget(game, _checkResults, wastes, wastesDragged)
//                       .getWidget()),
//         ]),
//         // _feedbackOffset > 0 ? Container(color: Colors.transparent) : Center(),
//         ..._showCloseConfirm
//             ? [
//                 Opacity(opacity: 0.6, child: Container(color: Colors.black)),
//                 Center(
//                     child: GestureDetector(
//                         onTap: () {
//                           game.setupLevel();
//                           Navigator.of(context).pushAndRemoveUntil(
//                               MaterialPageRoute(
//                                   builder: (context) => WelcomeScreen()),
//                               (Route<dynamic> route) => false);
//                         },
//                         child: Image(
//                           gaplessPlayback: true,
//                           image:
//                               AssetImage('assets/controls/close_confirm.png'),
//                         )))
//               ]
//             : [Center()],
//         _feedbackOffset == 0
//             ? Center()
//             : Align(
//                 alignment: Alignment.centerLeft,
//                 child: Container(
//                   height: 200,
//                   child: ClipRect(
//                     child: Container(
//                       child: Align(
//                         alignment: Alignment.centerRight,
//                         widthFactor: _feedbackOffset,
//                         child: Image(
//                           image: AssetImage(_girlImage),
//                           // width: 150,
//                           fit: BoxFit.fill,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               )
//       ]),
//     )));
//   }
// }
