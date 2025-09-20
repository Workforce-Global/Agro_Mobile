// widgets/direction_control_widget.dart
import 'package:flutter/material.dart';

class DirectionControlWidget extends StatelessWidget {
  final Function(String) onDirectionPressed;
  final bool isCompact;
  final double buttonSize;

  const DirectionControlWidget({
    Key? key,
    required this.onDirectionPressed,
    this.isCompact = false,
    this.buttonSize = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isCompact) {
      return _buildCompactControl();
    }
    return _buildNormalControl();
  }

  Widget _buildCompactControl() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDirectionButton('Left', 'L', buttonSize * 0.8),
          SizedBox(width: 40),
          _buildDirectionButton('Right', 'R', buttonSize * 0.8),
        ],
      ),
    );
  }

  Widget _buildNormalControl() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDirectionButton('Left', 'L', buttonSize),
          SizedBox(width: 30),
          _buildDirectionButton('Right', 'R', buttonSize),
        ],
      ),
    );
  }

  Widget _buildDirectionButton(String direction, String label, double size) {
    return GestureDetector(
      onTapDown: (_) => onDirectionPressed(direction),
      onTapUp: (_) => onDirectionPressed('Stop'),
      onTapCancel: () => onDirectionPressed('Stop'),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.9),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
              fontSize: size * 0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

// Compact version for portrait mode (above shutter button)
class CompactDirectionControlOverlay extends StatelessWidget {
  final Function(String) onDirectionPressed;

  const CompactDirectionControlOverlay({
    Key? key,
    required this.onDirectionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DirectionControlWidget(
        onDirectionPressed: onDirectionPressed,
        isCompact: true,
        buttonSize: 50,
      ),
    );
  }
}

// Full control for landscape mode (bottom)
class LandscapeDirectionControlOverlay extends StatelessWidget {
  final Function(String) onDirectionPressed;

  const LandscapeDirectionControlOverlay({
    Key? key,
    required this.onDirectionPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DirectionControlWidget(
        onDirectionPressed: onDirectionPressed,
        isCompact: false,
        buttonSize: 70,
      ),
    );
  }
}