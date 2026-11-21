import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import '../../media/models/lyric_line.dart';
import '../../media/services/lrc_parser.dart';
import '../../media/widgets/lyrics_viewer.dart';
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
  bool _showLyrics = false;
  double _progress = 0.42;

  // Sample lyrics parsed via LrcParser
  late final List<LyricLine> _lyrics = LrcParser.parseSyncedLrc('''
[00:00.00]Starboy - The Weeknd
[00:15.20]I'm tryna put you in the worst mood, ah
[00:19.40]P1 cleaner than your church shoes, ah
[00:23.10]Milli point two just to hurt you, ah
[00:27.00]All red Lamb' just to tease you, ah
[00:30.80]None of these toys on lease too, ah
[00:34.60]Made your whole year in a week too, yah
[00:38.50]Main bitch out your league too, ah
[00:42.40]Side bitch out of your league too, ah
[00:46.20]Look what you've done
[00:48.10]I'm a motherfuckin' starboy
''');

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top row: Artwork, Track Title, Lyrics Toggle, Quick Action Buttons
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Album Art
                Container(
                  width: 44.0,
                  height: 44.0,
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
                        blurRadius: 10.0,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.graphic_eq_rounded,
                    size: 22.0,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 12.0),

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
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      Text(
                        'The Weeknd • Starboy',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: CapsuleTheme.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action buttons: Lyrics toggle, Hub, Collapse
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(
                        _showLyrics ? Icons.music_note_rounded : Icons.subtitles_rounded,
                        size: 18.0,
                      ),
                      color: _showLyrics ? CapsuleTheme.accentCyan : CapsuleTheme.textSecondary,
                      tooltip: _showLyrics ? 'Show Controls' : 'Show Lyrics',
                      visualDensity: VisualDensity.compact,
                      onPressed: () => setState(() => _showLyrics = !_showLyrics),
                    ),
                    IconButton(
                      icon: const Icon(Icons.dashboard_customize_rounded, size: 18.0),
                      color: CapsuleTheme.textSecondary,
                      tooltip: 'Open Hub',
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.onMaxExpand,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_fullscreen_rounded, size: 18.0),
                      color: CapsuleTheme.textSecondary,
                      tooltip: 'Minimize',
                      visualDensity: VisualDensity.compact,
                      onPressed: widget.onCollapse,
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 6.0),

            // Middle View: Either Lyrics or Playback Controls
            if (_showLyrics)
              SizedBox(
                height: 105.0,
                child: LyricsViewer(
                  lyrics: _lyrics,
                  currentPositionMs: (_progress * 50000).toInt(),
                  onLineTap: (timeMs) {
                    setState(() => _progress = (timeMs / 50000.0).clamp(0.0, 1.0));
                  },
                ),
              )
            else ...[
              // Progress Bar
              Row(
                children: [
                  const Text(
                    '1:24',
                    style: TextStyle(
                      color: CapsuleTheme.textMuted,
                      fontSize: 10.5,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.0,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5.0),
                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 8.0),
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
                      fontSize: 10.5,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 2.0),

              // Bottom Control Row: Shuffle, Prev, Play/Pause, Next, Waveform
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shuffle_rounded, size: 18.0),
                    color: CapsuleTheme.textSecondary,
                    visualDensity: VisualDensity.compact,
                    onPressed: () {},
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.skip_previous_rounded, size: 22.0),
                        color: CapsuleTheme.textPrimary,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                      ),
                      const SizedBox(width: 4.0),
                      GestureDetector(
                        onTap: () {
                          setState(() => _isPlaying = !_isPlaying);
                        },
                        child: Container(
                          width: 34.0,
                          height: 34.0,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                            size: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4.0),
                      IconButton(
                        icon: const Icon(Icons.skip_next_rounded, size: 22.0),
                        color: CapsuleTheme.textPrimary,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  WaveformVisualizer(
                    color: CapsuleTheme.accentCyan,
                    height: 14.0,
                    isPlaying: _isPlaying,
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
