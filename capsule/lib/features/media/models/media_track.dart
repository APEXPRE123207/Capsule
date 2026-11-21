import 'lyric_line.dart';

/// Represents playback track metadata and synchronized lyrics
class MediaTrack {
  const MediaTrack({
    required this.title,
    required this.artist,
    required this.album,
    required this.durationMs,
    required this.positionMs,
    required this.isPlaying,
    this.albumArtUrl,
    this.lyrics = const [],
  });

  final String title;
  final String artist;
  final String album;
  final int durationMs;
  final int positionMs;
  final bool isPlaying;
  final String? albumArtUrl;
  final List<LyricLine> lyrics;

  double get progress => durationMs > 0 ? (positionMs / durationMs).clamp(0.0, 1.0) : 0.0;

  MediaTrack copyWith({
    String? title,
    String? artist,
    String? album,
    int? durationMs,
    int? positionMs,
    bool? isPlaying,
    String? albumArtUrl,
    List<LyricLine>? lyrics,
  }) {
    return MediaTrack(
      title: title ?? this.title,
      artist: artist ?? this.artist,
      album: album ?? this.album,
      durationMs: durationMs ?? this.durationMs,
      positionMs: positionMs ?? this.positionMs,
      isPlaying: isPlaying ?? this.isPlaying,
      albumArtUrl: albumArtUrl ?? this.albumArtUrl,
      lyrics: lyrics ?? this.lyrics,
    );
  }
}
