import 'dart:io';

/// Windows Master Audio & Volume control service
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  double _volume = 0.65;
  bool _isMuted = false;

  double get volume => _volume;
  bool get isMuted => _isMuted;

  Future<void> setVolume(double level) async {
    _volume = level.clamp(0.0, 1.0);
    _isMuted = false;
    if (Platform.isWindows) {
      // Direct Windows volume adjustment
    }
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    if (Platform.isWindows) {
      // Direct Windows mute toggle
    }
  }
}
