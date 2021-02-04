import 'package:cleanWise/logic/game_level.dart';
import 'package:cleanWise/screens/widgets/container_widget.dart';
import 'package:cleanWise/screens/widgets/trash_widget.dart';
import 'package:flutter/material.dart';

class Type2GameWidget {
  final GameLevel game;
  final Function checkResult;
  final List<int> trashIDs;
  final List<int> trashIDsDragged;
  final Function onDrag;
  final Function onDragCancelled;
  double align;
  double offset;
  EntranceState state;

  Type2GameWidget(
      this.game,
      this.checkResult,
      this.trashIDs,
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
                children: game.containerIDs
                    .map((e) => Flexible(
                        flex: 30,
                        fit: FlexFit.tight,
                        child: ContainerWidget(e, checkResult)))
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
                      child: trashIDs.length == 0
                          ? Center()
                          : TrashWidget(
                              trashIDs[0],
                              onDrag,
                              onDragCancelled,
                              state,
                              offset,
                              (trashIDsDragged.contains(trashIDs[0])))),
                ],
              ),
            )),
      ],
    );
  }
}
