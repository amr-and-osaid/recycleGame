// import 'dart:async';

// import 'package:cleanWise/app_data.dart';
// import 'package:cleanWise/screens/widgets/container_widget.dart';
// import 'package:cleanWise/screens/widgets/trash_widget.dart';
// import 'package:flutter/material.dart';

// class Main2Screen extends StatefulWidget {
//   final Function finishGame;
//   final Function exitGame;
//   Main2Screen(this.finishGame, this.exitGame, {Key key}) : super(key: key);

//   @override
//   _Main2ScreenState createState() => _Main2ScreenState();
// }

// class _Main2ScreenState extends State<Main2Screen> {
//   bool _showCloseConfirm = false;
//   int _warningFreq = 500;
//   double _warningOpacity = 1;
//   Timer _warningTimer;
//   double _align = 1;
//   double _offset = 0.1;
//   EntranceState _state = EntranceState.ENTER;
//   bool _pauseTimer = false;

//   @override
//   void initState() {
//     super.initState();
//     Timer.periodic(Duration(milliseconds: 1), (timer) {
//       if (_pauseTimer) return;
//       setState(() {
//         if (_state == EntranceState.ENTER) {
//           _offset += 0.01;
//           if (_offset >= 1) {
//             _state = EntranceState.NONE;
//             _offset = 1;
//           }
//         } else if (_state == EntranceState.NONE) {
//           _align -= 0.02;
//           if (_align <= -1) {
//             _state = EntranceState.EXIT;
//           }
//         } else if (_state == EntranceState.EXIT) {
//           _offset -= 0.01;
//           if (_offset <= 0) {
//             _state = EntranceState.ENTER;
//             _offset = 0.01;
//             _align = 1;
//             _checkResults(false);
//           }
//         }
//       });
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

//   @override
//   void dispose() {
//     super.dispose();
//   }

//   void _checkResults(bool correct) {
//     AppData.gameManager.setProgressAndGoNext(correct);

//     if (AppData.gameManager.isEndOfGame) {
//       if (_warningTimer != null) _warningTimer.cancel();
//       widget.finishGame();
//     } else {
//       if (AppData.gameManager.currentMistakes > 10) {
//         if (_warningTimer != null) _warningTimer.cancel();
//         _warningFreq = 500 - (AppData.gameManager.currentMistakes * 20);
//         _warningTimer =
//             Timer.periodic(Duration(milliseconds: _warningFreq), (timer) {
//           setState(() {
//             _warningOpacity = _warningOpacity == 0.5 ? 0.8 : 0.5;
//           });
//         });
//       }
//       setState(() {
//         _pauseTimer = false;
//         _state = EntranceState.ENTER;
//         _offset = 0.1;
//         _align = 1;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: Colors.white,
//         body: SafeArea(
//             child: Stack(
//           children: [
//             Column(
//               children: [
//                 Flexible(
//                     flex: 20,
//                     fit: FlexFit.tight,
//                     child: Padding(
//                       padding: const EdgeInsets.all(20.0),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Flexible(
//                             flex: 1,
//                             fit: FlexFit.tight,
//                             child: Stack(
//                               alignment: Alignment.center,
//                               children: [
//                                 Image(
//                                   image: AssetImage('assets/progress/back.png'),
//                                 ),
//                                 AnimatedOpacity(
//                                   opacity: _warningOpacity,
//                                   duration:
//                                       Duration(milliseconds: _warningFreq),
//                                   child: Image(
//                                     gaplessPlayback: true,
//                                     color: Color.fromARGB(
//                                         255,
//                                         160 +
//                                             (AppData.gameManager
//                                                     .currentMistakes *
//                                                 5),
//                                         160 -
//                                             (AppData.gameManager
//                                                     .currentMistakes *
//                                                 3),
//                                         160 -
//                                             (AppData.gameManager
//                                                     .currentMistakes *
//                                                 3)),
//                                     image: AssetImage('assets/progress/LS' +
//                                         (AppData.gameManager.currentProgress +
//                                                 AppData.gameManager
//                                                     .currentMistakes)
//                                             .toString() +
//                                         '.png'),
//                                   ),
//                                 ),
//                                 Image(
//                                   gaplessPlayback: true,
//                                   image: AssetImage('assets/progress/LS' +
//                                       (AppData.gameManager.currentProgress)
//                                           .toString() +
//                                       '.png'),
//                                 ),
//                                 Image(
//                                   image:
//                                       AssetImage('assets/progress/shade.png'),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           Flexible(
//                             flex: 1,
//                             fit: FlexFit.tight,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.end,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Flexible(
//                                     flex: 1,
//                                     fit: FlexFit.tight,
//                                     child: Center()),
//                                 Flexible(
//                                   flex: 1,
//                                   fit: FlexFit.tight,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         AppData.musicOn = !AppData.musicOn;
//                                         if (AppData.musicOn)
//                                           AppData.audioManager.playBgLoop();
//                                         else
//                                           AppData.audioManager.pauseBg();
//                                         setState(() {});
//                                       },
//                                       child: Image(
//                                         gaplessPlayback: true,
//                                         image: AssetImage(
//                                             'assets/controls/music' +
//                                                 (AppData.musicOn
//                                                     ? ''
//                                                     : '_mute') +
//                                                 '.png'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   fit: FlexFit.tight,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         AppData.soundOn = !AppData.soundOn;
//                                         setState(() {});
//                                       },
//                                       child: Image(
//                                         gaplessPlayback: true,
//                                         image: AssetImage(
//                                             'assets/controls/sound' +
//                                                 (AppData.soundOn
//                                                     ? ''
//                                                     : '_mute') +
//                                                 '.png'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 Flexible(
//                                   flex: 1,
//                                   fit: FlexFit.tight,
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(3.0),
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         setState(() {
//                                           _showCloseConfirm = true;
//                                         });
//                                       },
//                                       child: Image(
//                                         gaplessPlayback: true,
//                                         image: AssetImage(
//                                             'assets/controls/close.png'),
//                                       ),
//                                     ),
//                                   ),
//                                 ),
//                                 // Flexible(
//                                 //     flex: 1,
//                                 //     fit: FlexFit.tight,
//                                 //     child: Center()),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )),
//                 Flexible(
//                     flex: 30,
//                     fit: FlexFit.tight,
//                     child: Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: AppData.gameManager.currentContainerIDs
//                           .map((e) => Flexible(
//                               flex: 30,
//                               fit: FlexFit.tight,
//                               child: ContainerWidget(e, _checkResults)))
//                           .toList(),
//                     )),
//                 Flexible(
//                     flex: 50,
//                     fit: FlexFit.tight,
//                     child: Center(
//                       child: Stack(
//                         alignment: Alignment.center,
//                         children: [
//                           Image(
//                               image: AssetImage('assets/line.png'),
//                               height: 150,
//                               fit: BoxFit.fill),
//                           Align(
//                               alignment: Alignment(_align, 0),
//                               child: TrashWidget(
//                                   AppData.gameManager.currentTrashID,
//                                   onDrag,
//                                   onDragCancelled,
//                                   _state,
//                                   _offset)),
//                         ],
//                       ),
//                     )),
//               ],
//             ),
//             _showCloseConfirm
//                 ? Opacity(opacity: 0.6, child: Container(color: Colors.black))
//                 : Center(),
//             _showCloseConfirm
//                 ? Center(
//                     child: GestureDetector(
//                       onTap: () {
//                         widget.exitGame();
//                       },
//                       child: Image(
//                         gaplessPlayback: true,
//                         image: AssetImage('assets/controls/close_confirm.png'),
//                       ),
//                     ),
//                   )
//                 : Center()
//           ],
//         )));
//   }
// }
