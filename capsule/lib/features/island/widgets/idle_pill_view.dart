import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import 'waveform_visualizer.dart';

/// Minimal idle view displayed inside the compact pill
class IdlePillView extends StatelessWidget {
  const IdlePillView({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 14.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading: App / status indicator
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.album_rounded,
                  size: 16.0,
                  color: CapsuleTheme.accentGreen,
                ),
                SizedBox(width: 8.0),
                Text(
                  'Capsule',
                  style: TextStyle(
                    color: CapsuleTheme.textPrimary,
                    fontSize: 12.0,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),

            // Trailing: Real-time waveform
            WaveformVisualizer(
              color: CapsuleTheme.accentGreen,
              height: 14.0,
              isPlaying: true,
            ),
          ],
        ),
      ),
    );
  }
}
