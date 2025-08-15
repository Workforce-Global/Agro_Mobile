// widgets/camera_overlay_widgets.dart
import 'package:flutter/material.dart';
import './joystick_widget.dart';

class TopControlsOverlay extends StatelessWidget {
  final bool isStreaming;
  final VoidCallback onSettingsPressed;
  final VoidCallback onStreamToggle;

  const TopControlsOverlay({
    super.key,
    required this.isStreaming,
    required this.onSettingsPressed,
    required this.onStreamToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Connection Status
        ConnectionStatusWidget(isStreaming: isStreaming),
        Spacer(),
        // Top right controls
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OverlayButton(
              icon: Icons.settings,
              onPressed: onSettingsPressed,
            ),
            SizedBox(width: 12),
            OverlayButton(
              icon: isStreaming ? Icons.stop_circle_outlined : Icons.play_circle_outlined,
              onPressed: onStreamToggle,
              color: isStreaming ? Colors.red : Colors.green,
            ),
          ],
        ),
      ],
    );
  }
}

class BottomControlsOverlay extends StatelessWidget {
  final bool isStreaming;
  final bool isCapturing;
  final bool isAnalyzing;
  final VoidCallback onCapture;
  final VoidCallback onGalleryPressed;
  final VoidCallback onSwitchPressed;

  const BottomControlsOverlay({
    super.key,
    required this.isStreaming,
    required this.isCapturing,
    required this.isAnalyzing,
    required this.onCapture,
    required this.onGalleryPressed,
    required this.onSwitchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Gallery/History Button
        OverlayButton(
          icon: Icons.photo_library_outlined,
          onPressed: onGalleryPressed,
          size: 50,
        ),
        Spacer(),
        // Shutter Button
        ShutterButton(
          isStreaming: isStreaming,
          isCapturing: isCapturing,
          isAnalyzing: isAnalyzing,
          onCapture: onCapture,
        ),
        Spacer(),
        // Switch/Other Function Button
        OverlayButton(
          icon: Icons.flip_camera_ios_outlined,
          onPressed: onSwitchPressed,
          size: 50,
        ),
      ],
    );
  }
}

// NEW: Right side controls for landscape mode
class RightSideControlsOverlay extends StatelessWidget {
  final bool isStreaming;
  final bool isCapturing;
  final bool isAnalyzing;
  final VoidCallback onCapture;
  final VoidCallback onGalleryPressed;
  final VoidCallback onSwitchPressed;

  const RightSideControlsOverlay({
    super.key,
    required this.isStreaming,
    required this.isCapturing,
    required this.isAnalyzing,
    required this.onCapture,
    required this.onGalleryPressed,
    required this.onSwitchPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Gallery/History Button
        OverlayButton(
          icon: Icons.photo_library_outlined,
          onPressed: onGalleryPressed,
          size: 50,
        ),
        SizedBox(height: 20),
        // Shutter Button
        ShutterButton(
          isStreaming: isStreaming,
          isCapturing: isCapturing,
          isAnalyzing: isAnalyzing,
          onCapture: onCapture,
        ),
        SizedBox(height: 20),
        // Switch/Other Function Button
        OverlayButton(
          icon: Icons.flip_camera_ios_outlined,
          onPressed: onSwitchPressed,
          size: 50,
        ),
      ],
    );
  }
}

// NEW: Top center controls for landscape mode
class TopCenterControlsOverlay extends StatelessWidget {
  final bool isStreaming;
  final VoidCallback onSettingsPressed;
  final VoidCallback onStreamToggle;

  const TopCenterControlsOverlay({
    super.key,
    required this.isStreaming,
    required this.onSettingsPressed,
    required this.onStreamToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ConnectionStatusWidget(isStreaming: isStreaming),
        SizedBox(width: 20),
        OverlayButton(
          icon: Icons.settings,
          onPressed: onSettingsPressed,
        ),
        SizedBox(width: 12),
        OverlayButton(
          icon: isStreaming ? Icons.stop_circle_outlined : Icons.play_circle_outlined,
          onPressed: onStreamToggle,
          color: isStreaming ? Colors.red : Colors.green,
        ),
      ],
    );
  }
}

// NEW: Compact arm control for portrait mode (above shutter button)
class CompactArmControlOverlay extends StatelessWidget {
  final Function(double) onMove;

  const CompactArmControlOverlay({
    super.key,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: EdgeInsets.symmetric(horizontal: 40),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: JoystickWidget(
        onMove: onMove,
        size: 80,
        isCompact: true, // Use the new compact style
      ),
    );
  }
}

// UPDATED: Full-width arm control for landscape mode (bottom)
class FullWidthArmControlOverlay extends StatelessWidget {
  final Function(double) onMove;

  const FullWidthArmControlOverlay({
    super.key,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5, // 50% of screen width instead of full width
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
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
        child: JoystickWidget(
          onMove: onMove,
          size: 100, // Slightly smaller size for the shorter bar
          isCompact: true,
        ),
      ),
    );
  }
}

class ArmControlOverlay extends StatelessWidget {
  final Function(double) onMove;
  final double size;

  const ArmControlOverlay({
    super.key,
    required this.onMove,
    this.size = 100,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(size / 2 + 16),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: JoystickWidget(
        onMove: onMove,
        size: size,
      ),
    );
  }
}

class ShutterButton extends StatelessWidget {
  final bool isStreaming;
  final bool isCapturing;
  final bool isAnalyzing;
  final VoidCallback onCapture;

  const ShutterButton({
    super.key,
    required this.isStreaming,
    required this.isCapturing,
    required this.isAnalyzing,
    required this.onCapture,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isStreaming && !isCapturing && !isAnalyzing ? onCapture : null,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              blurRadius: 10,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isStreaming && !isCapturing && !isAnalyzing
                ? Colors.white
                : Colors.grey.withOpacity(0.5),
          ),
          child: isCapturing
              ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
            ),
          )
              : null,
        ),
      ),
    );
  }
}

class OverlayButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final Color? color;
  final double size;

  const OverlayButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.color,
    this.size = 44,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white24, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: color ?? Colors.white,
          size: size * 0.45,
        ),
        padding: EdgeInsets.zero,
      ),
    );
  }
}

class ConnectionStatusWidget extends StatelessWidget {
  final bool isStreaming;

  const ConnectionStatusWidget({
    super.key,
    required this.isStreaming,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isStreaming ? Colors.green : Colors.red,
          width: 1,
        ),
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
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: isStreaming ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6),
          Text(
            isStreaming ? 'LIVE' : 'OFFLINE',
            style: TextStyle(
              color: isStreaming ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}