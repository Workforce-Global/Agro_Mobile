// joystick_widget.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class JoystickWidget extends StatefulWidget {
  final Function(double) onMove;
  final double size;

  const JoystickWidget({Key? key, required this.onMove, this.size = 100})
    : super(key: key);

  @override
  _JoystickWidgetState createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _knobPosition = 0.0; // -1.0 to 1.0 (left to right)
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.size,
      height:
          widget.size * 0.6, // Make it more rectangular for left-right movement
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: JoystickPainter(
            knobPosition: _knobPosition,
            isDragging: _isDragging,
          ),
          size: Size(widget.size, widget.size * 0.6),
        ),
      ),
    );
  }

  void _onPanStart(DragStartDetails details) {
    setState(() {
      _isDragging = true;
    });
  }

  void _onPanUpdate(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final centerX = widget.size / 2;
    final maxDistance = widget.size / 2 - 20; // Leave some margin

    double deltaX = localPosition.dx - centerX;
    deltaX = math.max(-maxDistance, math.min(maxDistance, deltaX));

    setState(() {
      _knobPosition = deltaX / maxDistance;
    });

    widget.onMove(_knobPosition);
  }

  void _onPanEnd(DragEndDetails details) {
    setState(() {
      _knobPosition = 0.0;
      _isDragging = false;
    });
    widget.onMove(0.0);
  }
}

class JoystickPainter extends CustomPainter {
  final double knobPosition;
  final bool isDragging;

  JoystickPainter({required this.knobPosition, required this.isDragging});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.height / 2;
    final trackRadius = radius - 10;

    // Draw track
    paint.color = Colors.white24;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = 4;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: center,
          width: size.width - 20,
          height: size.height - 20,
        ),
        Radius.circular(radius),
      ),
      paint,
    );

    // Draw center line
    paint.color = Colors.white12;
    paint.strokeWidth = 1;
    canvas.drawLine(
      Offset(20, center.dy),
      Offset(size.width - 20, center.dy),
      paint,
    );

    // Draw knob
    final knobX = center.dx + (knobPosition * (size.width / 2 - 30));
    final knobCenter = Offset(knobX, center.dy);

    paint.style = PaintingStyle.fill;
    paint.color = isDragging ? Colors.blue : Colors.white;
    canvas.drawCircle(knobCenter, 15, paint);

    // Draw knob border
    paint.style = PaintingStyle.stroke;
    paint.color = isDragging ? Colors.blueAccent : Colors.white70;
    paint.strokeWidth = 2;
    canvas.drawCircle(knobCenter, 15, paint);

    // Draw direction indicators
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white54;

    // Left arrow
    final leftArrow = Path();
    leftArrow.moveTo(35, center.dy);
    leftArrow.lineTo(25, center.dy - 5);
    leftArrow.lineTo(25, center.dy + 5);
    leftArrow.close();
    canvas.drawPath(leftArrow, paint);

    // Right arrow
    final rightArrow = Path();
    rightArrow.moveTo(size.width - 35, center.dy);
    rightArrow.lineTo(size.width - 25, center.dy - 5);
    rightArrow.lineTo(size.width - 25, center.dy + 5);
    rightArrow.close();
    canvas.drawPath(rightArrow, paint);
  }

  @override
  bool shouldRepaint(JoystickPainter oldDelegate) {
    return oldDelegate.knobPosition != knobPosition ||
        oldDelegate.isDragging != isDragging;
  }
}
