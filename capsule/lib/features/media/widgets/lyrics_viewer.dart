import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import '../models/lyric_line.dart';

/// Real-time scrolling synchronized lyrics view
class LyricsViewer extends StatefulWidget {
  const LyricsViewer({
    super.key,
    required this.lyrics,
    required this.currentPositionMs,
    this.onLineTap,
  });

  final List<LyricLine> lyrics;
  final int currentPositionMs;
  final ValueChanged<int>? onLineTap;

  @override
  State<LyricsViewer> createState() => _LyricsViewerState();
}

class _LyricsViewerState extends State<LyricsViewer> {
  final ScrollController _scrollController = ScrollController();
  int _lastActiveIndex = -1;

  int _findActiveIndex() {
    if (widget.lyrics.isEmpty) return -1;
    for (int i = widget.lyrics.length - 1; i >= 0; i--) {
      if (widget.currentPositionMs >= widget.lyrics[i].timeMs) {
        return i;
      }
    }
    return 0;
  }

  void _scrollToActive(int index) {
    if (!_scrollController.hasClients || index < 0) return;
    const itemHeight = 38.0;
    final targetOffset = (index * itemHeight) - 80.0;
    _scrollController.animateTo(
      targetOffset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void didUpdateWidget(covariant LyricsViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    final activeIndex = _findActiveIndex();
    if (activeIndex != _lastActiveIndex) {
      _lastActiveIndex = activeIndex;
      _scrollToActive(activeIndex);
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.lyrics.isEmpty) {
      return const Center(
        child: Text(
          'No synchronized lyrics available',
          style: TextStyle(color: CapsuleTheme.textMuted, fontSize: 12.0),
        ),
      );
    }

    final activeIndex = _findActiveIndex();

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
      itemCount: widget.lyrics.length,
      itemBuilder: (context, index) {
        final line = widget.lyrics[index];
        final isActive = index == activeIndex;

        return GestureDetector(
          onTap: () => widget.onLineTap?.call(line.timeMs),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Text(
              line.text,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isActive ? CapsuleTheme.accentCyan : CapsuleTheme.textSecondary.withValues(alpha: 0.5),
                fontSize: isActive ? 15.0 : 13.0,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.2,
              ),
            ),
          ),
        );
      },
    );
  }
}
