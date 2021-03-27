// import 'package:recycle_game/logic/game_level.dart';
// import 'package:flutter/material.dart';
// import 'dart:math' as math;

import 'dart:async';

import 'package:recycle_game/logic/game_level.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProgressWidget extends StatefulWidget {
  final GameLevel game;

  ProgressWidget(this.game);

  @override
  _ProgressWidgetState createState() => _ProgressWidgetState();
}

class _ProgressWidgetState extends State<ProgressWidget> {
  Timer globalTimer;

  @override
  void initState() {
    globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (mounted) setState(() {});
      if (widget.game.remDuration <= 0) globalTimer.cancel();
    });
    super.initState();
  }

  String getTimerImage() {
    int num =
        ((widget.game.remDuration / widget.game.levelDuration) * 23).toInt();
    if (num < 0) num = 0;
    if (num > 23) num = 23;
    num = (num - 23) * -1;

    return "assets/timer/$num.png";
  }

  String getBarImage() {
    int num =
        ((widget.game.levelScore / widget.game.numTargetWastes) * 33).toInt();
    if (num < 0) num = 0;
    if (num > 33) num = 33;

    return "assets/progress/LS$num.png";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.purple,
        height: 70,
        child: Row(children: [
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      gaplessPlayback: true,
                      image: AssetImage(getTimerImage()),
                    ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: widget.game.levelScore >= widget.game.numTargetWastes
                      ? Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Image(
                            gaplessPlayback: true,
                            image: AssetImage('assets/recycle/5.png'),
                          ),
                        )
                      : Center(),
                ),
                Flexible(
                  flex: 2,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image(
                        image: AssetImage('assets/progress/back.png'),
                      ),
                      Image(
                        gaplessPlayback: true,
                        color: Colors.green,
                        image: AssetImage(getBarImage()),
                      ),
                      Image(
                        image: AssetImage('assets/progress/shade.png'),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10.0, top: 6),
                          child: Text(
                            (widget.game.levelScore).toString(),
                            style: TextStyle(
                                color: Colors.purple,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Flexible(flex: 1, fit: FlexFit.tight, child: Center())
        ]));
  }
}

// class ProgressWidget {
//   final GameLevel game;

//   ProgressWidget(this.game);

//   Widget getBasicWidget() {
//     return Column(
//       children: [
//         Flexible(
//           child: Row(
//             children: [
//               Flexible(
//                   flex: game.maxMistakesAllowed <=
//                           (game.numRounds - game.maxMistakesAllowed)
//                       ? 0
//                       : game.maxMistakesAllowed,
//                   fit: FlexFit.tight,
//                   child: Center()),
//               Flexible(
//                 flex: game.maxMistakesAllowed >
//                         (game.numRounds - game.maxMistakesAllowed)
//                     ? (game.numRounds - game.maxMistakesAllowed) * 2
//                     : game.numRounds - game.maxMistakesAllowed,
//                 fit: FlexFit.tight,
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     alignment: Alignment.center,
//                     children: [
//                       // Image(
//                       //   fit: BoxFit.fill,
//                       //   image: AssetImage('assets/progress/back.png'),
//                       // ),
//                       Container(
//                           decoration: BoxDecoration(
//                               color: Colors.blue[100],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(50.0)))),
//                       // Transform(
//                       //   alignment: Alignment.center,
//                       //   transform: Matrix4.rotationY(math.pi),
//                       //   child: Image(
//                       //     gaplessPlayback: true,
//                       //     color: Colors.red,
//                       //     // Color.fromARGB(
//                       //     //     255,
//                       //     //     160 + (game.mistakesCounter * 10),
//                       //     //     160 - (game.mistakesCounter * 5),
//                       //     //     160 - (game.mistakesCounter * 5)),
//                       //     image: AssetImage(game.mistakesImage),
//                       //   ),
//                       // ),
//                       Row(
//                         children: [
//                           Flexible(
//                               flex: game.numRounds -
//                                   game.maxMistakesAllowed -
//                                   game.levelScore,
//                               fit: FlexFit.tight,
//                               child: Center()),
//                           Flexible(
//                             flex: game.levelScore,
//                             fit: FlexFit.tight,
//                             child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.green,
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(50.0)))),
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Image(
//                       //   fit: BoxFit.fill,
//                       //   gaplessPlayback: true,
//                       //   color: Colors.green,
//                       //   // game.winLevelReached ? Colors.yellow : Colors.green,
//                       //   image: AssetImage(game.scoreImage),
//                       // ),
//                       Image(
//                         fit: BoxFit.fill,
//                         color: Colors.green.withOpacity(0.3),
//                         image: AssetImage('assets/progress/shade.png'),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 10.0, top: 6),
//                           child: Text(
//                             (game.numRounds -
//                                     game.maxMistakesAllowed -
//                                     game.levelScore)
//                                 .toString(),
//                             style: TextStyle(
//                                 color: Colors.purple,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       )
//                       // Align(
//                       //   alignment: Alignment(game.maxMiskatesAllowedAlignValue, 0),
//                       //   child: Image(
//                       //     width: 40,
//                       //     image: AssetImage('assets/recycle/5.png'),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//         Flexible(
//           child: Row(
//             children: [
//               Flexible(
//                   flex: (game.numRounds - game.maxMistakesAllowed) <=
//                           game.maxMistakesAllowed
//                       ? 0
//                       : game.numRounds - game.maxMistakesAllowed,
//                   fit: FlexFit.tight,
//                   child: Center()),
//               Flexible(
//                 flex: (game.numRounds - game.maxMistakesAllowed) >
//                         game.maxMistakesAllowed
//                     ? game.maxMistakesAllowed * 2
//                     : game.maxMistakesAllowed,
//                 fit: FlexFit.tight,
//                 child: Padding(
//                   padding: const EdgeInsets.all(4.0),
//                   child: Stack(
//                     fit: StackFit.expand,
//                     alignment: Alignment.center,
//                     children: [
//                       // Image(
//                       //   fit: BoxFit.fill,
//                       //   image: AssetImage('assets/progress/back.png'),
//                       // ),
//                       Container(
//                           decoration: BoxDecoration(
//                               color: Colors.blue[100],
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(50.0)))),
//                       // Transform(
//                       //   alignment: Alignment.center,
//                       //   transform: Matrix4.rotationY(math.pi),
//                       //   child: Image(
//                       //     gaplessPlayback: true,
//                       //     color: Colors.red,
//                       //     // Color.fromARGB(
//                       //     //     255,
//                       //     //     160 + (game.mistakesCounter * 10),
//                       //     //     160 - (game.mistakesCounter * 5),
//                       //     //     160 - (game.mistakesCounter * 5)),
//                       //     image: AssetImage(game.mistakesImage),
//                       //   ),
//                       // ),
//                       Row(
//                         children: [
//                           Flexible(
//                               flex: game.maxMistakesAllowed -
//                                   game.mistakesCounter,
//                               fit: FlexFit.tight,
//                               child: Center()),
//                           Flexible(
//                             flex: game.mistakesCounter,
//                             fit: FlexFit.tight,
//                             child: Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Container(
//                                   decoration: BoxDecoration(
//                                       color: Colors.red,
//                                       borderRadius: BorderRadius.all(
//                                           Radius.circular(50.0)))),
//                             ),
//                           ),
//                         ],
//                       ),
//                       // Image(
//                       //   fit: BoxFit.fill,
//                       //   gaplessPlayback: true,
//                       //   color: Colors.green,
//                       //   // game.winLevelReached ? Colors.yellow : Colors.green,
//                       //   image: AssetImage(game.scoreImage),
//                       // ),
//                       Image(
//                         fit: BoxFit.fill,
//                         color: Colors.red.withOpacity(0.3),
//                         image: AssetImage('assets/progress/shade.png'),
//                       ),
//                       Align(
//                         alignment: Alignment.centerRight,
//                         child: Padding(
//                           padding: const EdgeInsets.only(right: 10.0, top: 6),
//                           child: Text(
//                             (game.maxMistakesAllowed - game.mistakesCounter)
//                                 .toString(),
//                             style: TextStyle(
//                                 color: Colors.purple,
//                                 fontSize: 20,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                       )
//                       // Align(
//                       //   alignment: Alignment(game.maxMiskatesAllowedAlignValue, 0),
//                       //   child: Image(
//                       //     width: 40,
//                       //     image: AssetImage('assets/recycle/5.png'),
//                       //   ),
//                       // ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         )

//         // Flexible(
//         //   child: Padding(
//         //     padding: const EdgeInsets.all(4.0),
//         //     child: Stack(
//         //       alignment: Alignment.center,
//         //       children: [
//         //         Image(
//         //           image: AssetImage('assets/progress/back.png'),
//         //         ),
//         //         // Transform(
//         //         //   alignment: Alignment.center,
//         //         //   transform: Matrix4.rotationY(math.pi),
//         //         //   child: Image(
//         //         //     gaplessPlayback: true,
//         //         //     color: Colors.red,
//         //         //     // Color.fromARGB(
//         //         //     //     255,
//         //         //     //     160 + (game.mistakesCounter * 10),
//         //         //     //     160 - (game.mistakesCounter * 5),
//         //         //     //     160 - (game.mistakesCounter * 5)),
//         //         //     image: AssetImage(game.mistakesImage),
//         //         //   ),
//         //         // ),
//         //         Image(
//         //           gaplessPlayback: true,
//         //           color: Colors.red,
//         //           // game.winLevelReached ? Colors.yellow : Colors.green,
//         //           image: AssetImage(game.mistakesImage),
//         //         ),
//         //         Image(
//         //           color: Colors.red.withOpacity(0.3),
//         //           image: AssetImage('assets/progress/shade.png'),
//         //         ),
//         //         Align(
//         //           alignment: Alignment.centerRight,
//         //           child: Padding(
//         //             padding: const EdgeInsets.only(right: 10.0, top: 6),
//         //             child: Text(
//         //               (game.maxMistakesAllowed - game.mistakesCounter)
//         //                   .toString(),
//         //               style: TextStyle(
//         //                   color: Colors.purple,
//         //                   fontSize: 20,
//         //                   fontWeight: FontWeight.bold),
//         //             ),
//         //           ),
//         //         )
//         //         // Align(
//         //         //   alignment: Alignment(game.maxMiskatesAllowedAlignValue, 0),
//         //         //   child: Image(
//         //         //     width: 40,
//         //         //     image: AssetImage('assets/recycle/5.png'),
//         //         //   ),
//         //         // ),
//         //       ],
//         //     ),
//         //   ),
//         // ),
//       ],
//     );
//   }

//   Widget getTimedWidget(int curSecond) {
//     return Row(
//       children: [
//         Flexible(
//           flex: 1,
//           child: Align(
//             alignment: Alignment.centerRight,
//             child: Image(
//               gaplessPlayback: true,
//               image: AssetImage(game.timerImage(curSecond)),
//             ),
//           ),
//         ),
//         Flexible(
//           flex: 2,
//           child: Stack(
//             alignment: Alignment.center,
//             children: [
//               Image(
//                 image: AssetImage('assets/progress/back.png'),
//               ),
//               Image(
//                 gaplessPlayback: true,
//                 color: game.winLevelReached ? Colors.yellow : Colors.green,
//                 image: AssetImage(game.scoreImage),
//               ),
//               Image(
//                 image: AssetImage('assets/progress/shade.png'),
//               ),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Padding(
//                   padding: const EdgeInsets.only(right: 10.0, top: 6),
//                   child: Text(
//                     (game.numTargetWastes - game.levelScore).toString(),
//                     style: TextStyle(
//                         color: Colors.purple,
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               )
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }
