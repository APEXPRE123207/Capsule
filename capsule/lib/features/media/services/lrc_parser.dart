import '../models/lyric_line.dart';

/// Synchronized LRC / YRC parser ported from eIsland's lrcParser implementation
class LrcParser {
  LrcParser._();

  static const List<String> _metaPrefixes = [
    '作词', '作曲', '编曲', '制作', '混音', '母带', '录音',
    'Lyrics by', 'Composed by', 'Produced by', 'Arranged by',
  ];

  /// Parses an LRC timestamp string (e.g. "01:23.45" or "02:14.500") into milliseconds
  static int? parseLrcTime(String tag) {
    final parts = tag.split(':');
    if (parts.length != 2) return null;

    final min = int.tryParse(parts[0]);
    if (min == null) return null;

    final secParts = parts[1].split('.');
    if (secParts.isEmpty) return null;

    final sec = int.tryParse(secParts[0]);
    if (sec == null) return null;

    int ms = 0;
    if (secParts.length > 1) {
      final frac = secParts[1];
      final val = int.tryParse(frac);
      if (val != null) {
        if (frac.length == 1) {
          ms = val * 100;
        } else if (frac.length == 2) {
          ms = val * 10;
        } else {
          ms = val;
        }
      }
    }

    return min * 60000 + sec * 1000 + ms;
  }

  /// Parses full LRC lyric text into sorted synchronized [LyricLine] entries
  static List<LyricLine> parseSyncedLrc(String lrc) {
    final lines = <LyricLine>[];
    for (final raw in lrc.split('\n')) {
      final trimmed = raw.trim();
      if (!trimmed.startsWith('[')) continue;
      final endIndex = trimmed.indexOf(']');
      if (endIndex == -1) continue;

      final tag = trimmed.substring(1, endIndex);
      final text = trimmed.substring(endIndex + 1).trim();
      final timeMs = parseLrcTime(tag);

      if (timeMs != null && text.isNotEmpty) {
        final isMeta = _metaPrefixes.any((prefix) => text.startsWith(prefix));
        if (!isMeta) {
          lines.add(LyricLine(timeMs: timeMs, text: text));
        }
      }
    }

    lines.sort((a, b) => a.timeMs.compareTo(b.timeMs));
    return lines;
  }

  /// Cleans track title by stripping brackets, feat suffixes, and audio tags (e.g. - Remix, feat. X)
  static String cleanTitle(String title) {
    var result = _normalize(title);
    result = _stripBrackets(result);
    result = result.replaceAll(RegExp(r'\s*(?:feat\.?|ft\.?|prod\.?|with)\s+.*', caseSensitive: false), '');
    result = result.replaceAll(RegExp(r'\s*-\s+.*$', caseSensitive: false), '');
    result = result.replaceAll(
      RegExp(r'\s*(?:remix|remaster(?:ed)?|live|acoustic|instrumental|demo|radio\s*edit|explicit|clean|deluxe|bonus\s*track|original\s*mix)\s*$', caseSensitive: false),
      '',
    );
    result = result.replaceAll(RegExp(r'[.\-_~·]+$'), '').trim();
    return result.isNotEmpty ? result : _normalize(title);
  }

  /// Cleans artist name by keeping the primary artist
  static String cleanArtist(String artist) {
    var result = _normalize(artist);
    result = _stripBrackets(result);
    result = result.replaceAll(RegExp(r'\s*(?:feat\.?|ft\.?|prod\.?|with)\s+.*', caseSensitive: false), '');
    final parts = result.split(RegExp(r'[/,;&×·、]|\s+x\s+', caseSensitive: false));
    result = (parts.isNotEmpty ? parts[0] : '').trim();
    result = result.replaceAll(RegExp(r'^["' "'" r']+|["' "'" r']+$'), '');
    return result.isNotEmpty ? result : _normalize(artist);
  }

  static String _normalize(String s) {
    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static String _stripBrackets(String s) {
    return s.replaceAll(RegExp(r'[\(（\[【〔{＜<《][^)）\]】〕}＞>》]*[)）\]】〕}＞>》]'), '').trim();
  }
}
