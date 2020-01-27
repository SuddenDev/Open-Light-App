import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:open_light_app/screens/home/home_slider.dart';

class HomeSliderPainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercentage;
  final bool btt;

  final double animationProgress;
  final SliderState sliderState;

  double _previousSliderPosition = 0;

  final Color color;
  final Color backgroundColor;
  final Color innerShadowTopColor;
  final Color innerShadowBottomColor;

  final Paint fillPainter;
  final Paint backgroundPainter;
  Paint shadowPainter;

  final double lineHeight;
  final double padding = 4.0;
  final double shadowDistance;
  final int segments;
  double spacing;

  Path _rRectangleMask = Path();
  Path _glowBars = Path();
  Path _innerShadowTop = Path();
  Path _innerShadowBottom = Path();

  HomeSliderPainter({
    @required this.sliderPosition,
    @required this.dragPercentage,
    @required this.animationProgress,
    @required this.sliderState,
    @required this.backgroundColor,
    @required this.color,
    @required this.innerShadowTopColor,
    @required this.innerShadowBottomColor,
    this.segments = 12,
    this.btt = true,
    this.lineHeight = 5.0,
    this.shadowDistance = 1.0,
  })  : fillPainter = Paint()
          ..color = color
          ..style = PaintingStyle.fill,
        backgroundPainter = Paint()
          ..color = backgroundColor
          ..style = PaintingStyle.fill,
        shadowPainter = Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2.5
          ..maskFilter =
              MaskFilter.blur(BlurStyle.outer, _convertRadiusToSigma(6));

  @override
  void paint(Canvas canvas, Size size) {
    spacing = (size.height - lineHeight) / (segments.toDouble() - 1.0);

    for (int i = 0; i < segments; i++) {
      _rRectangleMask.addRRect(_getBar(canvas, size, i));

      // looping over all segments and creating paths for it in seperate functions
      _addToInnerShadowTop(canvas, size, i);
      _addToInnerShadowBottom(canvas, size, i);
      _addToGlowBars(canvas, size, i);
    }

    // glow drawing
    canvas.drawPath(
        _glowBars,
        Paint()
          ..color = color.withAlpha(200)
          ..style = PaintingStyle.fill
          ..maskFilter =
              MaskFilter.blur(BlurStyle.outer, _convertRadiusToSigma(6)));

    // base drawing
    canvas.drawPath(_rRectangleMask, backgroundPainter);

    // clipping
    canvas.clipPath(_rRectangleMask);

    // Dark Shadow
    canvas.drawPath(
        _innerShadowTop, shadowPainter..color = innerShadowTopColor);

    // Bright Shadow
    canvas.drawPath(
        _innerShadowBottom, shadowPainter..color = innerShadowBottomColor);

    // draw progress bar
    _drawProgressBar(canvas, size);
  }

  @override
  bool shouldRepaint(HomeSliderPainter oldDelegate) {
    _previousSliderPosition = oldDelegate._previousSliderPosition;
    return true;
  }

  void _drawProgressBar(Canvas canvas, Size size) {
    canvas.drawRect(
        Rect.fromLTWH(0.0, btt ? size.height : 0.0, size.width,
            btt ? -sliderPosition : sliderPosition),
        fillPainter);
  }

  // Calculating where a bar should be, based on index and spacing
  RRect _getBar(Canvas canvas, Size size, int index) {
    return RRect.fromLTRBR(
        0.0 + padding, // left
        0.0 + spacing * index.toDouble(), // top
        size.width - padding, // right
        lineHeight + spacing * index.toDouble(), //bottom
        Radius.circular(4.0));
  }

  // Adding a path to for the inner top left shadow
  void _addToInnerShadowTop(Canvas canvas, Size size, int index) {
    _innerShadowTop.addPath(
        Path()
          ..moveTo(size.width - padding, -shadowDistance)
          ..lineTo(padding - shadowDistance, -shadowDistance)
          ..lineTo(padding - shadowDistance, lineHeight),
        Offset(
            0.0, //dx
            spacing * index));
  }

  // Adding a path to for the inner bottom right shadow
  void _addToInnerShadowBottom(Canvas canvas, Size size, int index) {
    _innerShadowBottom.addPath(
        Path()
          ..moveTo(0.0 + padding, lineHeight + shadowDistance)
          ..lineTo(size.width - padding + shadowDistance,
              lineHeight + shadowDistance)
          ..lineTo(size.width - padding + shadowDistance, shadowDistance),
        Offset(
            0.0, //dx
            spacing * index));
  }

  // Adding a rrect to a path for drawing a glow later
  void _addToGlowBars(Canvas canvas, Size size, int index) {
    RRect bar = _getBar(canvas, size, index);

    if (btt) {
      if (bar.bottom >= size.height + lineHeight - sliderPosition) {
        _glowBars.addRRect(bar);
      }
    } else {
      if (bar.bottom <= size.height + lineHeight - sliderPosition) {
        _glowBars.addRRect(bar);
      }
    }
  }

  static double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }
}
