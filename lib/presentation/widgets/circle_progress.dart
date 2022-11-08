import 'package:flutter/material.dart';
import 'dart:math';

class CircleProgress extends StatelessWidget {
  const CircleProgress(
      {Key? key,
      required this.radius,
      this.progress = 0,
      this.strokeColor = Colors.blueAccent,
      this.color = Colors.grey,
      this.fontStyle})
      : super(key: key);

  final int radius;
  final int progress;
  final Color strokeColor;
  final Color color;
  final TextStyle? fontStyle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius.toDouble()),
      ),
      child: CustomPaint(
        painter: _Painter(initialAngle: progress, color: strokeColor),
        child: Center(
          child: Text(
            "$progress%",
            style: fontStyle,
          ),
        ),
      ),
    );
  }
}

class _Painter extends CustomPainter {
  _Painter({this.initialAngle = 0, required this.color});

  final int initialAngle;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.style = PaintingStyle.stroke;
    paint.color = color;
    paint.strokeWidth = 3;
    Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2 - 2);

    canvas.translate(0, 0);
    canvas.drawArc(rect, 1.5 * pi, 2 * pi * initialAngle / 100, false, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
