/// Represents a single synchronized lyric line with millisecond timestamp
class LyricLine {
  const LyricLine({
    required this.timeMs,
    required this.text,
    this.translation,
  });

  final int timeMs;
  final String text;
  final String? translation;

  @override
  String toString() => '[$timeMs ms] $text';
}
