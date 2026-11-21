import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import 'waveform_visualizer.dart';

/// Hovered state view: peek preview of track & quick actions
class HoverPillView extends StatelessWidget {
  const HoverPillView({
    super.key,
    required this.onExpand,
  });

  final VoidCallback onExpand;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onExpand,
      borderRadius: BorderRadius.circular(24.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Leading: Album art & track info peek
            Expanded(
              child: Row(
                children: [
                  Container(
                    width: 26.0,
                    height: 26.0,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF10B981)],
                      ),
                      borderRadius: BorderRadius.circular(13.0),
                    ),
                    child: const Icon(
                      Icons.music_note_rounded,
                      size: 15.0,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  const Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Blinding Lights',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CapsuleTheme.textPrimary,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'The Weeknd',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: CapsuleTheme.textSecondary,
                            fontSize: 10.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8.0),

            // Trailing: Live waveform + expand prompt hint
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const WaveformVisualizer(
                  color: CapsuleTheme.accentGreen,
                  height: 16.0,
                  isPlaying: true,
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.all(4.0),
                  decoration: const BoxDecoration(
                    color: CapsuleTheme.surfaceHighlight,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.open_in_full_rounded,
                    size: 11.0,
                    color: CapsuleTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
