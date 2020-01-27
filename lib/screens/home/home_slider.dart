import 'package:flutter/material.dart';
import 'home_slider_painter.dart';

class HomeSlider extends StatefulWidget {
  final double sliderWidth;
  final double sliderHeight;
  final int sliderSegments;
  final bool btt; // bottom to top
  final ValueChanged<double> onChanged;

  final Color color;
  final Color backgroundColor;
  final Color innerShadowTopColor;
  final Color innerShadowBottomColor;

  const HomeSlider({
    this.sliderWidth = 60.0,
    this.sliderHeight = 400.0,
    this.sliderSegments = 12,
    this.btt = true,
    this.color = Colors.white,
    this.backgroundColor = Colors.black12,
    this.innerShadowTopColor = Colors.black38,
    this.innerShadowBottomColor = Colors.white24,
    @required this.onChanged
  }):assert(sliderSegments >= 8 && sliderSegments <= 30);

  @override
  _HomeSliderState createState() => _HomeSliderState();
}

class _HomeSliderState extends State<HomeSlider> with SingleTickerProviderStateMixin {
  double _dragPosition = 0;
  double _dragPercentage = 0;

  HomeSliderController _slideController;

  @override
  void initState() {
    super.initState();
    _slideController = HomeSliderController(vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0.0;
    if (widget.btt) {
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
  }

  void _handleChangeUpdate(double val) {
    assert(widget.onChanged != null);
    widget.onChanged(val);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(update.globalPosition);
    _slideController.setStateToSliding();
    _updateDragPosition(offset);
    _handleChangeUpdate(_dragPercentage);
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject();
    Offset offset = box.globalToLocal(start.globalPosition);
    _slideController.setStateToStart();
    _updateDragPosition(offset);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    _slideController.setStateToStopping();
    setState(() {});
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
              painter: HomeSliderPainter(
                  color: widget.color,
                  backgroundColor: widget.backgroundColor,
                  innerShadowTopColor: widget.innerShadowTopColor,
                  innerShadowBottomColor: widget.innerShadowTopColor,
                  animationProgress: _slideController.progress,
                  sliderState: _slideController.state,
                  dragPercentage: _dragPercentage,
                  sliderPosition: _dragPosition,
                  segments: widget.sliderSegments,
                  btt: widget.btt))),
      onVerticalDragUpdate: (DragUpdateDetails update) =>
          _onDragUpdate(context, update),
      onVerticalDragStart: (DragStartDetails start) =>
          _onDragStart(context, start),
      onVerticalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
    ));
  }
}

class HomeSliderController extends ChangeNotifier {
  final AnimationController controller;
  SliderState _state = SliderState.resting;

  HomeSliderController({@required TickerProvider vsync})
      : controller = AnimationController(vsync: vsync) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _startAnimation() {
    controller.duration = Duration(milliseconds: 200);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}
