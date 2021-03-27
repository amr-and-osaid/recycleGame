import 'dart:async';

import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/widgets/progress_widget.dart';
import 'package:recycle_game/widgets/waste_bin_widget.dart';
import 'package:recycle_game/widgets/waste_widget.dart';
import 'package:flutter/material.dart';

class BasicLevelWidget extends StatefulWidget {
  final GameLevel game;
  final Function gameFinishAction;

  BasicLevelWidget(this.game, this.gameFinishAction) {
    if (game.type != LevelType.BASIC)
      throw Exception("This widget only support Basic Game Level.");
  }

  @override
  State<StatefulWidget> createState() => _BasicLevelWidgetState();
}

class _BasicLevelWidgetState extends State<BasicLevelWidget> {
  Timer globalTimer;
  double redOpacity;
  List<Waste> activeWastes;

  void postDropAction(Waste waste, bool correctState) {
    widget.game.setScore(correctState);
    activeWastes[waste.outIndex] = widget.game.nextWaste()
      ..outIndex = waste.outIndex;
    if (!correctState) {
      redOpacity = 1;
      Timer(Duration(milliseconds: 200), () {
        redOpacity = 0;
        setState(() {});
      });
      Timer(Duration(milliseconds: 400), () {
        redOpacity = 1;
        setState(() {});
      });
      Timer(Duration(milliseconds: 600), () {
        redOpacity = 0;
        setState(() {});
      });
    }

    setState(() {});
  }

  @override
  void initState() {
    widget.game.prepareLevel();

    activeWastes = List<Waste>.generate(
            widget.game.numWastes, (e) => widget.game.nextWaste()..outIndex = e)
        .toList();
    redOpacity = 0;

    widget.game.startLevel();

    globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.game.remDuration <= 0) {
        globalTimer.cancel();
        widget.gameFinishAction();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    if (globalTimer != null) globalTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
            opacity: redOpacity,
            duration: Duration(milliseconds: 100),
            child: Container(color: Colors.red)),
        Column(
          children: [
            ProgressWidget(widget.game),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(flex: 4, fit: FlexFit.tight, child: binsSection()),
                  Flexible(flex: 6, fit: FlexFit.tight, child: wastesSection())
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget binsSection() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: widget.game.bins
          .map((bin) => Flexible(
              fit: FlexFit.tight, child: WasteBinWidget(bin, postDropAction)))
          .toList());

  Widget wastesSection() => Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: activeWastes
          .map((waste) => Flexible(
                  child: Stack(alignment: Alignment.center, children: [
                CircleAvatar(radius: 80, backgroundColor: Color(0xff644CA2)),
                WasteWidget(waste)
              ])))
          .toList());
}
