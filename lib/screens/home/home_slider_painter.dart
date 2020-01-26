import 'dart:ui';

import 'package:flutter/material.dart';

class HomeSliderPainter extends CustomPainter {
  final double sliderPosition;
  final double dragPercentage;

  final Color color;
  final Paint fillPainter;
  final Paint linePainter;

  final double lineHeight = 5.0;
  final double padding = 4.0;
  final int segments;

  HomeSliderPainter({
    @required this.sliderPosition,
    @required this.dragPercentage,
    @required this.color,
    @required this.segments,
  }): fillPainter = Paint()
      ..color = color
      ..style = PaintingStyle.fill,
      linePainter = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;


  @override
  void paint(Canvas canvas, Size size) {
    for(int i = 0; i < segments; i++) {
      _drawRectangles(canvas, size, i);
    }
    
    _abc(canvas, size);
  }

  static double _convertRadiusToSigma(double radius) {
    return radius * 0.57735 + 0.5;
  }

  Path _rectangleMask = Path();

  void _abc(Canvas c, Size s) {
    c.drawPath(_rectangleMask, fillPainter);
    c.clipPath(_rectangleMask);

    //  Dark Shadow
    c.drawPath(_rectangleMask.shift(Offset(-40.0, -lineHeight - 10.0)),
        Paint() 
        ..color= Colors.blueGrey[600]
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _convertRadiusToSigma(12))
    );

    // Bright Shadow
    c.drawPath(_rectangleMask.shift(Offset(20.0, lineHeight + 4.0)),
        Paint() 
        ..color=  Colors.white.withAlpha(200)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, _convertRadiusToSigma(8))
    );


  }

  void _drawRectangles(Canvas canvas, Size size, int index) {
    double spacing = (size.height - lineHeight) / (segments.toDouble() - 1.0);

    double left = 0.0 + padding;
    double top = 0.0 + spacing * index.toDouble();
    double right = size.width - padding;
    double bottom = lineHeight + spacing * index.toDouble();
    Radius radius = Radius.circular(4.0);

    RRect rrect = RRect.fromLTRBR(left, top, right, bottom, radius);
    // canvas.drawRRect(rrect, fillPainter);
    _rectangleMask.addRRect(rrect);
    

    // _rectangleMask.addRRect(rrect);

 
    
  }
    
  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
    
      
}