import 'dart:async';

import 'package:recycle_game/logic/game_level.dart';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/widgets/progress_widget.dart';
import 'package:recycle_game/widgets/waste_bin_widget.dart';
import 'package:recycle_game/widgets/waste_widget.dart';
import 'package:flutter/material.dart';

class WaterfallLevelWidget extends StatefulWidget {
  final GameLevel game;
  final Function gameFinishAction;

  WaterfallLevelWidget(this.game, this.gameFinishAction) {
    if (game.type != LevelType.WATERFALL)
      throw Exception("This widget only support Waterfall Game Level.");
  }

  @override
  State<StatefulWidget> createState() => _WaterfallLevelWidgetState();
}

class _WaterfallLevelWidgetState extends State<WaterfallLevelWidget> {
  Timer globalTimer;
  List<Waste> activeWastes;
  double redOpacity;

  List<Timer> movingTimers;
  List<double> movingAligns;
  List<double> movingOffsets;
  List<EntranceState> movingStates;

  void postDropAction(Waste waste, bool correctState) {
    widget.game.setScore(correctState);

    int outIndex = waste.outIndex;
    activeWastes[outIndex] = widget.game.nextWaste().clone()
      ..outIndex = outIndex;

    movingAligns[outIndex] = 1;
    movingOffsets[outIndex] = 0.1;
    movingStates[outIndex] = EntranceState.ENTER_TOP;

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

    activeWastes = List<Waste>.generate(widget.game.numWastes,
        (e) => widget.game.nextWaste().clone()..outIndex = e).toList();

    redOpacity = 0;

    movingAligns = List<double>.filled(widget.game.numWastes, 1);
    movingOffsets = List<double>.filled(widget.game.numWastes, 0.1);
    movingStates = List<EntranceState>.filled(
        widget.game.numWastes, EntranceState.ENTER_TOP);

    widget.game.startLevel();

    globalTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (widget.game.remDuration <= 0) {
        globalTimer.cancel();
        widget.gameFinishAction();
      }
    });

    movingTimers = List<Timer>.generate(
        widget.game.numWastes,
        (index) => Timer.periodic(
                Duration(
                    milliseconds: (widget.game.movingDuration / 400).floor()),
                (timer) {
              setState(() {
                if (movingStates[index] == EntranceState.ENTER_TOP) {
                  movingOffsets[index] += 0.01;
                  if (movingOffsets[index] >= 1) {
                    movingStates[index] = EntranceState.NONE;
                    movingOffsets[index] = 1;
                  }
                } else if (movingStates[index] == EntranceState.NONE) {
                  movingAligns[index] -= 0.01;
                  if (movingAligns[index] <= -1) {
                    movingStates[index] = EntranceState.EXIT_BOTTOM;
                  }
                } else if (movingStates[index] == EntranceState.EXIT_BOTTOM) {
                  movingOffsets[index] -= 0.01;
                  if (movingOffsets[index] <= 0) {
                    movingStates[index] = EntranceState.ENTER_TOP;
                    movingOffsets[index] = 0.01;
                    movingAligns[index] = 1;
                    activeWastes[index] = widget.game.nextWaste().clone()
                      ..outIndex = index;
                  }
                }
              });
            })).toList();

    super.initState();
  }

  @override
  void dispose() {
    if (globalTimer != null) globalTimer.cancel();
    for (int i = 0; i < movingTimers.length; i++)
      if (movingTimers[i] != null) movingTimers[i].cancel();
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(flex: 4, fit: FlexFit.tight, child: binsSection()),
                  Flexible(flex: 6, fit: FlexFit.tight, child: wastesSection())
                ],
              ),
            ),
          ],
        ),
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
      children: List<Widget>.generate(
          activeWastes.length,
          (index) => Flexible(
                  child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: 1000,
                      child: Image(
                          image: AssetImage('assets/line.png'),
                          width: 80,
                          fit: BoxFit.fill),
                    ),
                    Align(
                        alignment: Alignment(0, -movingAligns[index]),
                        child: WasteWidget(
                          activeWastes[index],
                          state: movingStates[index],
                          offset: movingOffsets[index],
                        )),
                  ],
                ),
              ))).toList());
}
