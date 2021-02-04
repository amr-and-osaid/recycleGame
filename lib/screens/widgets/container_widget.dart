import 'package:cleanWise/app_data.dart';
import 'package:cleanWise/logic/trash_container_map.dart';
import 'package:flutter/material.dart';

class ContainerWidget extends StatefulWidget {
  final int containerID;
  final Function checkResults;
  final _ContainerWidgetState localState = _ContainerWidgetState();

  ContainerWidget(this.containerID, this.checkResults, {Key key})
      : super(key: key);

  @override
  _ContainerWidgetState createState() => localState;
}

class _ContainerWidgetState extends State<ContainerWidget> {
  bool draggedToTarget = false;

  Widget get baseWidget => Image(
        image: AssetImage(
            'assets/container/' + widget.containerID.toString() + '.png'),
        fit: BoxFit.fitWidth,
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DragTarget<int>(
          builder: (_, candidateData, rejectedData) => baseWidget,
          onAccept: (data) {
            if (TrashContainerMap.checkMatch(data, widget.containerID)) {
              AppData.audioManager.playTrash(widget.containerID);
              widget.checkResults(data, true);
            } else {
              AppData.audioManager.playWrong();
              widget.checkResults(data, false);
            }
          },
        ),
      ],
    );
  }
}
