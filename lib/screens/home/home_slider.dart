import 'package:flutter/material.dart';
import 'package:open_light_app/screens/home/home_slider_painter.dart';

class HomeSlider extends StatefulWidget {
  final double sliderWidth;
  final double sliderHeight;
  final int sliderSegments;
  final bool btt; // bottom to top

  const HomeSlider({
      this.sliderWidth = 60.0,
      this.sliderHeight = 400.0,
      this.sliderSegments = 12,
      this.btt = true
  });

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> {
  double _dragPosition = 0;
  double _dragPercentage = 0;

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0.0;
    if(widget.btt) {
      if (val.dy <= 0.0) {
        newDragPosition = widget.sliderHeight;
      } else if (val.dy >= widget.sliderHeight) {
        newDragPosition = 0.0;
      } else {
        newDragPosition = widget.sliderHeight - val.dy;
      }
    } else {
      if (val.dy <= 0.0) {
        newDragPosition = 0.0;
      } else if (val.dy >= widget.sliderHeight) {
        newDragPosition = widget.sliderHeight;
      } else {
        newDragPosition = val.dy;
      }
    }


    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.sliderHeight;
    });
    
    print(_dragPercentage);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _updateDragPosition(offset);
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(start.globalPosition);
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GestureDetector(
        child: Container(
          width: widget.sliderWidth,
          height: widget.sliderHeight,
          // color: Colors.green,
          child: CustomPaint(
            painter:HomeSliderPainter(
              color: Colors.blueGrey[200].withAlpha(200),
              dragPercentage: _dragPercentage,
              sliderPosition: _dragPosition,
              segments: widget.sliderSegments
            )
          )
        ),
        onVerticalDragUpdate: (DragUpdateDetails update) => _onDragUpdate(context, update),
        onVerticalDragStart: (DragStartDetails start) => _onDragStart(context, start),
        onVerticalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
      )
    );
  }
}