// joystick_widget.dart
import 'package:flutter/material.dart';
import 'dart:math' as math;

class JoystickWidget extends StatefulWidget {
  final Function(double) onMove;
  final double size;
  final bool isCompact; // New parameter for zoom bar style

  const JoystickWidget({
    super.key,
    required this.onMove,
    this.size = 100,
    this.isCompact = false, // Default to original style
  });

  @override
  _JoystickWidgetState createState() => _JoystickWidgetState();
}

class _JoystickWidgetState extends State<JoystickWidget> {
  double _knobPosition = 0.0; // -1.0 to 1.0 (left to right)
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    if (widget.isCompact) {
      return _buildCompactJoystick();
    }
    return _buildNormalJoystick();
  }

  Widget _buildCompactJoystick() {
    return SizedBox(
      width: widget.size * 2, // Make it wider like a zoom bar
      height: 40, // Fixed height for compact style
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdateCompact,
        onPanEnd: _onPanEnd,
        child: CustomPaint(
          painter: CompactJoystickPainter(
            knobPosition: _knobPosition,
            isDragging: _isDragging,
          ),
          size: Size(widget.size * 2, 40),
        ),
      ),
    );
  }

  Widget _buildNormalJoystick() {
    return SizedBox(
      width: widget.size,
      height: widget.size * 0.6, // Make it more rectangular for left-right movement
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

  void _onPanUpdateCompact(DragUpdateDetails details) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.globalPosition);
    final centerX = (widget.size * 2) / 2; // Adjusted for wider bar
    final maxDistance = (widget.size * 2) / 2 - 30; // Leave margin

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

class CompactJoystickPainter extends CustomPainter {
  final double knobPosition;
  final bool isDragging;

  CompactJoystickPainter({
    required this.knobPosition,
    required this.isDragging,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    final trackHeight = 6.0;

    // Draw background track
    paint.color = Colors.black.withOpacity(0.3);
    paint.style = PaintingStyle.fill;
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: center,
        width: size.width - 20,
        height: trackHeight,
      ),
      Radius.circular(trackHeight / 2),
    );
    canvas.drawRRect(trackRect, paint);

    // Draw active track (from center to knob position)
    paint.color = isDragging ? Colors.blue : Colors.white;
    final knobX = center.dx + (knobPosition * (size.width / 2 - 30));
    final activeWidth = (knobX - center.dx).abs();
    final activeRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(
        knobPosition >= 0 ? center.dx : knobX,
        center.dy - trackHeight / 2,
        knobPosition >= 0 ? knobX : center.dx,
        center.dy + trackHeight / 2,
      ),
      Radius.circular(trackHeight / 2),
    );
    canvas.drawRRect(activeRect, paint);

    // Draw center indicator
    paint.color = Colors.white70;
    canvas.drawCircle(center, 3, paint);

    // Draw knob
    final knobCenter = Offset(knobX, center.dy);
    paint.color = isDragging ? Colors.blue : Colors.white;
    canvas.drawCircle(knobCenter, 12, paint);

    // Draw knob border
    paint.style = PaintingStyle.stroke;
    paint.color = isDragging ? Colors.blueAccent : Colors.white70;
    paint.strokeWidth = 2;
    canvas.drawCircle(knobCenter, 12, paint);

    // Draw direction indicators (L and R)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white54;

    // Left "L"
    final leftTextPainter = TextPainter(
      text: TextSpan(
        text: 'L',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    leftTextPainter.layout();
    leftTextPainter.paint(canvas, Offset(15, center.dy - 6));

    // Right "R"
    final rightTextPainter = TextPainter(
      text: TextSpan(
        text: 'R',
        style: TextStyle(
          color: Colors.white54,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    rightTextPainter.layout();
    rightTextPainter.paint(canvas, Offset(size.width - 25, center.dy - 6));
  }

  @override
  bool shouldRepaint(CompactJoystickPainter oldDelegate) {
    return oldDelegate.knobPosition != knobPosition ||
        oldDelegate.isDragging != isDragging;
  }
}

class JoystickPainter extends CustomPainter {
  final double knobPosition;
  final bool isDragging;

  JoystickPainter({
    required this.knobPosition,
    required this.isDragging,
  });

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
        Rect.fromCenter(center: center, width: size.width - 20, height: size.height - 20),
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