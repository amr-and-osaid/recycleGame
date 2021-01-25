import 'package:cleanWise/app_data.dart';
import 'package:flutter/material.dart';

class ContainerWidget extends StatefulWidget {
  final int imageID;
  final Function checkResults;
  final _ContainerWidgetState localState = _ContainerWidgetState();

  ContainerWidget(this.imageID, this.checkResults, {Key key}) : super(key: key);

  void reset() => localState.draggedToTarget = false;

  @override
  _ContainerWidgetState createState() => localState;
}

class _ContainerWidgetState extends State<ContainerWidget> {
  bool draggedToTarget = false;

  Widget get baseWidget => Image(
        image: AssetImage(
            'assets/container/' + widget.imageID.toString() + '.png'),
        fit: BoxFit.fitWidth,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DragTarget<int>(
          builder: (_, candidateData, rejectedData) {
            return baseWidget;
          },
          onWillAccept: (data) => true,
          onAccept: (data) {
            if (AppData.gameManager.isCorrectContainer(data, widget.imageID)) {
              AppData.gameManager.playTrash(widget.imageID);
              widget.checkResults(true);
            } else {
              AppData.gameManager.playWrong();
              widget.checkResults(false);
            }
          },
        ),
      ],
    );
  }
}
