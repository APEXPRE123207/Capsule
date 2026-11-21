import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';

/// Animated mini audio waveform bars mimicking Apple Dynamic Island media playback
class WaveformVisualizer extends StatefulWidget {
  const WaveformVisualizer({
    super.key,
    this.color = CapsuleTheme.accentGreen,
    this.barCount = 4,
    this.height = 14.0,
    this.isPlaying = true,
  });

  final Color color;
  final int barCount;
  final double height;
  final bool isPlaying;

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant WaveformVisualizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        _controller.repeat();
      } else {
        _controller.stop();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(widget.barCount, (index) {
            final phase = (index * 0.7) + (_controller.value * 2 * math.pi);
            final scale = widget.isPlaying
                ? (math.sin(phase).abs() * 0.65) + 0.35
                : 0.35;
            final barH = widget.height * scale;

            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 1.2),
              width: 2.5,
              height: barH,
              decoration: BoxDecoration(
                color: widget.color,
                borderRadius: BorderRadius.circular(1.5),
              ),
            );
          }),
        );
      },
    );
  }
}
