import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/logic/game_area.dart';
import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/screens/game_level_screen.dart';

class LevelMark extends StatefulWidget {
  final GameArea gameArea;
  final GameLevel gameLevel;

  LevelMark(this.gameArea, this.gameLevel);

  @override
  _LevelMarkState createState() => _LevelMarkState();
}

class PulseCurve extends Curve {
  final double min = 0.7;
  @override
  double transformInternal(double t) {
    var val = t * (1 - min) + min;
    return val; //f(x)
  }
}

class _LevelMarkState extends State<LevelMark> with TickerProviderStateMixin {
  double _margin = 0;
  bool _enhaled = true;
  Timer _enhalingTimer;

  AnimationController _controller;
  Animation<double> _animation;

  bool get isOpen =>
      widget.gameArea.areaID <= AppData.gameManager.currentAreaID &&
      widget.gameLevel.levelID <= AppData.gameManager.currentLevelID;

  bool get isPassed =>
      widget.gameArea.areaID <= AppData.gameManager.currentAreaID &&
      widget.gameLevel.levelID < AppData.gameManager.currentLevelID;

  bool get isCurrent =>
      widget.gameArea.areaID == AppData.gameManager.currentAreaID &&
      widget.gameLevel.levelID == AppData.gameManager.currentLevelID;

  bool get isLastInArea =>
      widget.gameLevel.levelID == widget.gameArea.levels.length - 1;

  Point get levelPosition =>
      widget.gameArea.getLevelPosition(widget.gameLevel.levelID);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(seconds: 1), vsync: this, value: 0.1);
    _animation = CurvedAnimation(parent: _controller, curve: PulseCurve());

    _controller.repeat(
      reverse: true,
      period: Duration(seconds: 1),
    );

    // _enhalingTimer = Timer.periodic(Duration(milliseconds: 500), (timer) {
    //   _controller.forward();
    //   // setState(() {
    //   //   _margin = _enhaled ? 1 : 10;
    //   //   _enhaled = !_enhaled;
    //   // });
    // });
  }

  @override
  void dispose() {
    if (_enhalingTimer != null) _enhalingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isOpen) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => GameLevelScreen(
                      widget.gameArea.areaID, widget.gameLevel.levelID)),
              (Route<dynamic> route) => false);
        }
      },
      child: ScaleTransition(
        scale: _animation,
        alignment: Alignment(levelPosition.x * 2 - 1, levelPosition.y * 2 - 1),
        // AnimatedContainer(
        //   duration: Duration(milliseconds: 500),
        //   margin: EdgeInsets.all(_margin),
        child: Stack(
          children: [
            Align(
                alignment:
                    Alignment(levelPosition.x * 2 - 1, levelPosition.y * 2 - 1),
                child: Container(
                  width: 60,
                  height: 50,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Opacity(
                            opacity: isOpen ? 1 : 1,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                isLastInArea
                                    ? Icon(
                                        Icons.wine_bar,
                                        color: Colors.purple,
                                        size: 50,
                                      )
                                    : Image(
                                        image: AssetImage('assets/recycle/' +
                                            (isOpen ? '6' : '7') +
                                            '.png'),
                                        width: 30,
                                        height: 30,
                                      )
                                // Icon(Icons.trash,
                                //     size: isLastInArea ? 50 : 30,
                                //     color: isOpen ? Colors.black : Colors.purple),
                                ,
                                isOpen
                                    ? Text(
                                        (widget.gameLevel.levelID + 1)
                                            .toString(),
                                        style: TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black))
                                    : Icon(
                                        Icons.lock,
                                        size: 12,
                                      ),
                              ],
                            )),
                      ),
                      Align(
                          alignment: Alignment.topCenter,
                          child: isPassed
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(top: 8.0),
                                        child: Image(
                                            image: AssetImage(
                                                'assets/recycle/star.png'),
                                            width: 20,
                                            height: 20)),
                                    Image(
                                        image: AssetImage(
                                            'assets/recycle/star.png'),
                                        width: 20,
                                        height: 20),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Image(
                                          image: AssetImage(
                                              'assets/recycle/star.png'),
                                          width: 20,
                                          height: 20),
                                    ),
                                  ],
                                )
                              :
                              // isCurrent
                              //     ? Icon(Icons.face_sharp)
                              //     :
                              SizedBox(width: 0))
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
