import 'dart:async';

import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/widgets/progress_widget.dart';
import 'package:recycle_game/widgets/waste_bin_widget.dart';
import 'package:recycle_game/widgets/waste_widget.dart';
import 'package:flutter/material.dart';

class CollectionLevelWidget extends StatefulWidget {
  final GameLevel game;
  final Function gameFinishAction;

  CollectionLevelWidget(this.game, this.gameFinishAction) {
    if (game.type != LevelType.COLLECTION)
      throw Exception("This widget only support Collection Game Level.");
  }

  @override
  State<StatefulWidget> createState() => _CollectionLevelWidgetState();
}

class _CollectionLevelWidgetState extends State<CollectionLevelWidget> {
  Timer globalTimer;
  double redOpacity;
  List<Waste> activeWastes;
  Widget wastesWidget;

  void postDropAction(Waste waste, bool correctState) {
    widget.game.setScore(correctState);

    // activeWastes[waste.outIndex] = widget.game.nextWaste()
    //   ..outIndex = waste.outIndex;

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
      setState(() {});
    }
  }

  @override
  void initState() {
    widget.game.prepareLevel();

    activeWastes = List<Waste>.generate(
            widget.game.numWastes, (e) => widget.game.nextWaste()..outIndex = e)
        .toList();
    redOpacity = 0;

    wastesWidget = Container(
      color: Colors.purple,
      child: GridView.count(
          shrinkWrap: true,
          crossAxisCount: 6,
          children: activeWastes
              .map((waste) => Flexible(
                      child: Stack(alignment: Alignment.center, children: [
                    WasteWidget(waste, hideWhenDraggedToTarget: true)
                  ])))
              .toList()),
    );

    widget.game.startLevel();

    globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.game.levelEndReached) {
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
                  Flexible(flex: 8, fit: FlexFit.tight, child: wastesSection()),
                  Flexible(flex: 2, fit: FlexFit.tight, child: binsSection())
                ],
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget binsSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.game.bins
                .map((bin) => Flexible(
                    fit: FlexFit.tight,
                    child: WasteBinWidget(bin, postDropAction)))
                .toList()),
      );

  Widget wastesSection() => Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: wastesWidget,
        ),
      );
}
