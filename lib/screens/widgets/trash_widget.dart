import 'package:flutter/material.dart';
import 'package:cleanWise/app_data.dart';

class TrashWidget extends StatefulWidget {
  final int imageID;
  final _TrashWidgetState localState = _TrashWidgetState();

  TrashWidget({this.imageID, Key key}) : super(key: key);

  void reset() {
    localState.draggedToTarget = false;
    localState.setState(() {});
  }

  @override
  _TrashWidgetState createState() => localState;
}

class _TrashWidgetState extends State<TrashWidget> {
  bool draggedToTarget = false;

  Widget get baseWidget => Container(
        width: 200,
        height: 200,
        child: Center(
          child: Image(
              image: AssetImage(
                  'assets/trash/' + widget.imageID.toString() + '.png'),
              width: 200,
              height: 200),
        ),
      );

  Widget get feedbackWidget => Container(
        width: 200,
        height: 200,
        child: Align(
          alignment: Alignment(0, -0.1),
          child: Image(
              image: AssetImage(
                  'assets/trash/' + widget.imageID.toString() + '.png'),
              width: 100,
              height: 100),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Draggable<int>(
          data: widget.imageID,
          childWhenDragging: Center(),
          feedback: feedbackWidget,
          child: baseWidget,
          onDragStarted: () => AppData.gameManager.playDrag(),
          onDragCompleted: () => setState(() => draggedToTarget = true),
        )
      ],
    );
  }
}
