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
        height: 200,
        child: Row(children: [
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image(
                      gaplessPlayback: true,
                      image: AssetImage(getTimerImage()),
                    ),
                  ),
                ),
                Flexible(
                  flex: 3,
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
                      ),
                      widget.game.levelScore >= widget.game.numTargetWastes
                          ? Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Image(
                                gaplessPlayback: true,
                                image: AssetImage('assets/recycle/5.png'),
                              ),
                            )
                          : Center(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Flexible(flex: 1, fit: FlexFit.tight, child: Center())
        ]));
  }
}
