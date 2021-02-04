import 'package:flutter/material.dart';
import 'package:cleanWise/app_data.dart';

enum EntranceState { ENTER, EXIT, NONE }

class TrashWidget extends StatefulWidget {
  final int imageID;
  final Function onDrag;
  final Function onDragCancelled;
  final EntranceState state;
  final double offset;
  final bool dragged;
  final _TrashWidgetState localState = _TrashWidgetState();

  TrashWidget(this.imageID, this.onDrag, this.onDragCancelled, this.state,
      this.offset, this.dragged,
      {Key key})
      : super(key: key);

  @override
  _TrashWidgetState createState() => localState;
}

class _TrashWidgetState extends State<TrashWidget> {
  bool draggedToTarget = false;

  Widget get baseWidget => Container(
        height: 150,
        child: ClipRect(
          child: Container(
            child: Align(
              alignment: widget.state == EntranceState.ENTER
                  ? Alignment.centerLeft
                  : widget.state == EntranceState.EXIT
                      ? Alignment.centerRight
                      : Alignment.center,
              widthFactor:
                  widget.state == EntranceState.NONE ? 1 : widget.offset,
              child: Image(
                  image: AssetImage(
                      'assets/trash/' + widget.imageID.toString() + '.png'),
                  width: 150,
                  // fit: BoxFit.fill,
                  height: 150),
            ),
          ),
        ),
      );

  Widget get feedbackWidget => Container(
        width: 150,
        height: 150,
        child: Align(
          alignment: Alignment(0, -1),
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
          // feedbackOffset: Offset(0, 5),
          child: widget.dragged ? Center() : baseWidget,
          onDragStarted: () {
            AppData.audioManager.playDrag();
            if (widget.onDrag != null) widget.onDrag();
          },
          onDraggableCanceled: (velocity, offset) {
            if (widget.onDragCancelled != null) widget.onDragCancelled();
          },
          onDragCompleted: () => setState(() => draggedToTarget = true),
        )
      ],
    );
  }
}
