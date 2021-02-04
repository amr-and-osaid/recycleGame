import 'package:cleanWise/logic/game_level.dart';
import 'package:cleanWise/screens/widgets/container_widget.dart';
import 'package:cleanWise/screens/widgets/trash_widget.dart';
import 'package:flutter/material.dart';

class Type1GameWidget {
  final GameLevel game;
  final Function checkResult;
  final List<int> trashIDs;
  final List<int> trashIDsDragged;

  Type1GameWidget(
      this.game, this.checkResult, this.trashIDs, this.trashIDsDragged);

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
            child: Center(
                child: Row(children: [
              Flexible(
                  flex: 70,
                  fit: FlexFit.loose,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: trashIDs
                          .map((e) => Flexible(
                              flex: 1,
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        CircleAvatar(
                                            radius: 80,
                                            backgroundColor: Color(0xff644CA2)),
                                        TrashWidget(
                                            e,
                                            null,
                                            null,
                                            EntranceState.NONE,
                                            1,
                                            (trashIDsDragged.contains(e)))
                                      ]))))
                          .toList()))
            ])))
      ],
    );
  }
}
