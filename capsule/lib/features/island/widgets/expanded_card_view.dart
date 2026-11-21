import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import 'waveform_visualizer.dart';

/// Interactive expanded card view with playback controls and track progress
class ExpandedCardView extends StatefulWidget {
  const ExpandedCardView({
    super.key,
    required this.onCollapse,
    required this.onMaxExpand,
  });

  final VoidCallback onCollapse;
  final VoidCallback onMaxExpand;

  @override
  State<ExpandedCardView> createState() => _ExpandedCardViewState();
}

class _ExpandedCardViewState extends State<ExpandedCardView> {
  bool _isPlaying = true;
  double _progress = 0.42;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top row: Artwork, Track Title, Quick Action Buttons
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Album Art
              Container(
                width: 50.0,
                height: 50.0,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4F46E5), Color(0xFF06B6D4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.35),
                      blurRadius: 12.0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.graphic_eq_rounded,
                  size: 26.0,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14.0),

              // Title and Artist
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Starboy (feat. Daft Punk)',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CapsuleTheme.textPrimary,
                        fontSize: 14.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 3.0),
                    Text(
                      'The Weeknd • Starboy',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: CapsuleTheme.textSecondary,
                        fontSize: 12.0,
                      ),
                    ),
                  ],
                ),
              ),

              // Action buttons (Max Expand & Collapse)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.dashboard_customize_rounded, size: 18.0),
                    color: CapsuleTheme.textSecondary,
                    tooltip: 'Open Hub',
                    onPressed: widget.onMaxExpand,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_fullscreen_rounded, size: 18.0),
                    color: CapsuleTheme.textSecondary,
                    tooltip: 'Minimize',
                    onPressed: widget.onCollapse,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Progress Bar
          Row(
            children: [
              const Text(
                '1:24',
                style: TextStyle(
                  color: CapsuleTheme.textMuted,
                  fontSize: 11.0,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 3.5,
                    thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.5),
                    overlayShape: const RoundSliderOverlayShape(overlayRadius: 10.0),
                    activeTrackColor: CapsuleTheme.accentCyan,
                    inactiveTrackColor: CapsuleTheme.surfaceHighlight,
                    thumbColor: Colors.white,
                  ),
                  child: Slider(
                    value: _progress,
                    onChanged: (val) {
                      setState(() => _progress = val);
                    },
                  ),
                ),
              ),
              const Text(
                '3:50',
                style: TextStyle(
                  color: CapsuleTheme.textMuted,
                  fontSize: 11.0,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ],
          ),

          const SizedBox(height: 4.0),

          // Bottom Control Row: Shuffle, Prev, Play/Pause, Next, Waveform
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.shuffle_rounded, size: 18.0),
                color: CapsuleTheme.textSecondary,
                onPressed: () {},
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.skip_previous_rounded, size: 24.0),
                    color: CapsuleTheme.textPrimary,
                    onPressed: () {},
                  ),
                  const SizedBox(width: 4.0),
                  GestureDetector(
                    onTap: () {
                      setState(() => _isPlaying = !_isPlaying);
                    },
                    child: Container(
                      width: 36.0,
                      height: 36.0,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        size: 22.0,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  IconButton(
                    icon: const Icon(Icons.skip_next_rounded, size: 24.0),
                    color: CapsuleTheme.textPrimary,
                    onPressed: () {},
                  ),
                ],
              ),
              WaveformVisualizer(
                color: CapsuleTheme.accentCyan,
                height: 16.0,
                isPlaying: _isPlaying,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
