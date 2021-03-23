import 'package:cleanWise/logic/game_level.dart';
import 'package:cleanWise/model/waste.dart';
import 'package:cleanWise/screens/widgets/waste_bin_widget.dart';
import 'package:cleanWise/screens/widgets/waste_widget.dart';
import 'package:flutter/material.dart';

class Type2GameWidget {
  final GameLevel game;
  final Function checkResult;
  final List<Waste> wastes;
  final List<int> trashIDsDragged;
  final Function onDrag;
  final Function onDragCancelled;
  double align;
  double offset;
  EntranceState state;

  Type2GameWidget(
      this.game,
      this.checkResult,
      this.wastes,
      this.trashIDsDragged,
      this.onDrag,
      this.onDragCancelled,
      this.align,
      this.offset,
      this.state);

  Widget getWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            flex: 30,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: game.wasteBins.length == 0
                    ? [
                        Opacity(
                            opacity: 0,
                            child: Image(
                              image: AssetImage('assets/waste_bins/1.png'),
                              fit: BoxFit.fitWidth,
                            ))
                      ]
                    : game.wasteBins
                        .map((e) => Flexible(
                            flex: 30,
                            fit: FlexFit.tight,
                            child: WasteBinWidget(e, checkResult)))
                        .toList())),
        Flexible(
            flex: 50,
            fit: FlexFit.tight,
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image(
                      image: AssetImage('assets/line.png'),
                      height: 150,
                      fit: BoxFit.fill),
                  Align(
                      alignment: Alignment(align, 0),
                      child: wastes.length == 0
                          ? Center()
                          : WasteWidget(
                              wastes[0],
                              onDrag,
                              onDragCancelled,
                              state,
                              offset,
                              (trashIDsDragged.contains(wastes[0])))),
                ],
              ),
            )),
      ],
    );
  }
}
