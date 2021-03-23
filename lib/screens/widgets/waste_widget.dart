import 'package:cleanWise/model/waste.dart';
import 'package:flutter/material.dart';
import 'package:cleanWise/app_data.dart';

enum EntranceState { ENTER, EXIT, NONE }

class WasteWidget extends StatefulWidget {
  final Waste waste;
  final Function onDrag;
  final Function onDragCancelled;
  final EntranceState state;
  final double offset;
  final bool dragged;
  final _WasteWidgetState localState = _WasteWidgetState();

  WasteWidget(this.waste, this.onDrag, this.onDragCancelled, this.state,
      this.offset, this.dragged,
      {Key key})
      : super(key: key);

  @override
  _WasteWidgetState createState() => localState;
}

class _WasteWidgetState extends State<WasteWidget> {
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
                  image: AssetImage(widget.waste.imagePath),
                  width: 150,
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
              image: AssetImage(widget.waste.imagePath),
              width: 100,
              height: 100),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Draggable<Waste>(
          data: widget.waste,
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
