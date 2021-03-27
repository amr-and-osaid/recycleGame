import 'package:recycle_game/app_data.dart';
import 'package:recycle_game/logic/waste.dart';
import 'package:recycle_game/logic/waste_bin.dart';
import 'package:flutter/material.dart';

class WasteBinWidget extends StatefulWidget {
  final WasteBin wasteBin;
  final Function postDropAction;
  final _WasteBinWidgetState localState = _WasteBinWidgetState();

  WasteBinWidget(this.wasteBin, this.postDropAction, {Key key})
      : super(key: key);

  @override
  _WasteBinWidgetState createState() => localState;
}

class _WasteBinWidgetState extends State<WasteBinWidget> {
  bool draggedToTarget = false;
  bool draggedIntoTarget = false;

  Widget get baseWidget => Opacity(
      opacity: draggedIntoTarget ? 0.6 : 1,
      child: Image(image: AssetImage(widget.wasteBin.imagePath)));

  @override
  Widget build(BuildContext context) {
    return DragTarget<Waste>(
      builder: (_, candidateData, rejectedData) => baseWidget,
      onAccept: (data) {
        print(data.outIndex);
        draggedIntoTarget = false;
        bool matched = data.wasteBin == widget.wasteBin;
        if (matched)
          AppData.audioManager.play(widget.wasteBin.audioPath);
        else
          AppData.audioManager.playWrong();
        widget.postDropAction(data, matched);
      },
      onMove: (d) => draggedIntoTarget = true,
      onLeave: (d) => draggedIntoTarget = false,
    );
  }
}
