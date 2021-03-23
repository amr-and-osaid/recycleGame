import 'package:cleanWise/logic/game_level.dart';
import 'package:cleanWise/model/waste.dart';
import 'package:cleanWise/screens/widgets/waste_bin_widget.dart';
import 'package:cleanWise/screens/widgets/waste_widget.dart';
import 'package:flutter/material.dart';

class Type1GameWidget {
  final GameLevel game;
  final Function checkResult;
  final List<Waste> wastes;
  final List<int> trashIDsDragged;

  Type1GameWidget(
      this.game, this.checkResult, this.wastes, this.trashIDsDragged);

  Widget getWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            flex: 30,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: game.wasteBins
                    .map((e) => Flexible(
                        flex: 30,
                        fit: FlexFit.tight,
                        child: WasteBinWidget(e, checkResult)))
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
                      children: wastes
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
                                        WasteWidget(
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
