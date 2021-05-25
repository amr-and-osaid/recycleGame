import 'package:recycle_game/logic/waste.dart';
import 'package:flutter/material.dart';
import 'package:recycle_game/app_data.dart';

enum EntranceState { ENTER_RIGHT, EXIT_LEFT, ENTER_TOP, EXIT_BOTTOM, NONE }

const double WASTE_SIZE = 100;

class WasteWidget extends StatefulWidget {
  final Waste waste;
  final bool hideWhenDraggedToTarget;
  final EntranceState state;
  final double offset;

  final _WasteWidgetState localState = _WasteWidgetState();

  WasteWidget(this.waste,
      {this.hideWhenDraggedToTarget = false,
      this.state = EntranceState.NONE,
      this.offset = 1,
      Key key})
      : super(key: key) {
    print(offset);
  }

  @override
  _WasteWidgetState createState() => localState;
}

class _WasteWidgetState extends State<WasteWidget> {
  bool draggedToTarget = false;

  Widget get baseWidget => Container(
        // height: 0,
        // width: WASTE_SIZE,
        child: ClipRect(
          child: Container(
            child: Align(
              alignment: widget.state == EntranceState.ENTER_RIGHT
                  ? Alignment.centerLeft
                  : widget.state == EntranceState.EXIT_LEFT
                      ? Alignment.centerRight
                      : widget.state == EntranceState.ENTER_TOP
                          ? Alignment.bottomCenter
                          : widget.state == EntranceState.EXIT_BOTTOM
                              ? Alignment.topCenter
                              : Alignment.center,
              widthFactor: widget.state != EntranceState.ENTER_RIGHT &&
                      widget.state != EntranceState.EXIT_LEFT
                  ? 1
                  : widget.offset,
              heightFactor: widget.state != EntranceState.ENTER_TOP &&
                      widget.state != EntranceState.EXIT_BOTTOM
                  ? 1
                  : widget.offset,
              child: Image(
                  image: AssetImage(widget.waste.imagePath),
                  width: WASTE_SIZE,
                  height: WASTE_SIZE),
            ),
          ),
        ),
      );

  Widget get emptyWidget => SizedBox(width: WASTE_SIZE, height: WASTE_SIZE);

  Widget get feedbackWidget => Container(
        width: WASTE_SIZE,
        height: WASTE_SIZE,
        child: Align(
          alignment: Alignment(0, -1),
          child: Image(
              image: AssetImage(widget.waste.imagePath),
              width: WASTE_SIZE,
              height: WASTE_SIZE),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Draggable<Waste>(
          data: widget.waste,
          childWhenDragging: emptyWidget,
          feedback: feedbackWidget,
          child: widget.hideWhenDraggedToTarget && draggedToTarget
              ? emptyWidget
              : baseWidget,
          onDragStarted: () => AppData.audioManager.playDrag(),
          onDragCompleted: () => setState(() => draggedToTarget = true),
        )
      ],
    );
  }
}
