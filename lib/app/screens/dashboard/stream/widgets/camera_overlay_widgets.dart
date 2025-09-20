// widgets/camera_overlay_widgets.dart
import 'package:flutter/material.dart';
import 'directional_control_widget.dart';

// Top controls for portrait mode
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildControlButton(
          icon: Icons.settings,
          onPressed: onSettingsPressed,
          backgroundColor: Colors.black.withOpacity(0.6),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isStreaming ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isStreaming ? Icons.videocam : Icons.videocam_off,
                color: Colors.white,
                size: 16,
              ),
              SizedBox(width: 6),
              Text(
                isStreaming ? 'STREAMING' : 'OFFLINE',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        _buildControlButton(
          icon: isStreaming ? Icons.stop : Icons.play_arrow,
          onPressed: onStreamToggle,
          backgroundColor: isStreaming ? Colors.red.withOpacity(0.8) : Colors.green.withOpacity(0.8),
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: Border.all(color: Colors.white.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }
}

// Top center controls for landscape mode
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
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.6),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
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
          _buildControlButton(
            icon: Icons.settings,
            onPressed: onSettingsPressed,
            backgroundColor: Colors.transparent,
          ),
          SizedBox(width: 20),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isStreaming ? Colors.green.withOpacity(0.8) : Colors.red.withOpacity(0.8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isStreaming ? Icons.videocam : Icons.videocam_off,
                  color: Colors.white,
                  size: 14,
                ),
                SizedBox(width: 4),
                Text(
                  isStreaming ? 'LIVE' : 'OFF',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 20),
          _buildControlButton(
            icon: isStreaming ? Icons.stop : Icons.play_arrow,
            onPressed: onStreamToggle,
            backgroundColor: Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

// Bottom controls for portrait mode
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
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildSideButton(
          icon: Icons.photo_library,
          onPressed: onGalleryPressed,
          enabled: true,
        ),
        _buildShutterButton(),
        _buildSideButton(
          icon: Icons.flip_camera_ios,
          onPressed: onSwitchPressed,
          enabled: isStreaming,
        ),
      ],
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: (isStreaming && !isCapturing) ? onCapture : null,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(6),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCapturing || isAnalyzing
                ? Colors.orange
                : (isStreaming ? Colors.red : Colors.grey),
          ),
          child: Center(
            child: isCapturing || isAnalyzing
                ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? Colors.white.withOpacity(0.9) : Colors.grey.withOpacity(0.5),
          border: Border.all(
            color: enabled ? Colors.white : Colors.grey.withOpacity(0.7),
            width: 2,
          ),
          boxShadow: enabled ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.black : Colors.grey[600],
          size: 24,
        ),
      ),
    );
  }
}

// Right side controls for landscape mode
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
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildSideButton(
          icon: Icons.photo_library,
          onPressed: onGalleryPressed,
          enabled: true,
        ),
        SizedBox(height: 20),
        _buildShutterButton(),
        SizedBox(height: 20),
        _buildSideButton(
          icon: Icons.flip_camera_ios,
          onPressed: onSwitchPressed,
          enabled: isStreaming,
        ),
      ],
    );
  }

  Widget _buildShutterButton() {
    return GestureDetector(
      onTap: (isStreaming && !isCapturing) ? onCapture : null,
      child: Container(
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCapturing || isAnalyzing
                ? Colors.orange
                : (isStreaming ? Colors.red : Colors.grey),
          ),
          child: Center(
            child: isCapturing || isAnalyzing
                ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
                : Icon(
              Icons.camera_alt,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSideButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool enabled,
  }) {
    return GestureDetector(
      onTap: enabled ? onPressed : null,
      child: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: enabled ? Colors.white.withOpacity(0.9) : Colors.grey.withOpacity(0.5),
          border: Border.all(
            color: enabled ? Colors.white : Colors.grey.withOpacity(0.7),
            width: 2,
          ),
          boxShadow: enabled ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ] : [],
        ),
        child: Icon(
          icon,
          color: enabled ? Colors.black : Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }
}

// Compact arm control for portrait mode (above shutter button)
class CompactArmControlOverlay extends StatelessWidget {
  final Function(String) onDirectionPressed;

  const CompactArmControlOverlay({
    super.key,
    required this.onDirectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CompactDirectionControlOverlay(
        onDirectionPressed: onDirectionPressed,
      ),
    );
  }
}

// Full width arm control for landscape mode (bottom)
class FullWidthArmControlOverlay extends StatelessWidget {
  final Function(String) onDirectionPressed;

  const FullWidthArmControlOverlay({
    super.key,
    required this.onDirectionPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LandscapeDirectionControlOverlay(
        onDirectionPressed: onDirectionPressed,
      ),
    );
  }
}