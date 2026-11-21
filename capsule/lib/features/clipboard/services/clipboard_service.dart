import 'package:flutter/services.dart';

class ClipboardItem {
  const ClipboardItem({
    required this.text,
    required this.timestamp,
    this.isPinned = false,
  });

  final String text;
  final DateTime timestamp;
  final bool isPinned;

  String get preview => text.replaceAll('\n', ' ').trim();
  int get length => text.length;

  ClipboardItem copyWith({bool? isPinned}) {
    return ClipboardItem(
      text: text,
      timestamp: timestamp,
      isPinned: isPinned ?? this.isPinned,
    );
  }
}

/// Clipboard history monitor without excessive CPU polling
class ClipboardService {
  ClipboardService._();
  static final ClipboardService instance = ClipboardService._();

  final List<ClipboardItem> _history = [];
  String _lastText = '';
  bool _monitoring = false;

  List<ClipboardItem> get history => List.unmodifiable(_history);

  void startMonitoring() {
    if (_monitoring) return;
    _monitoring = true;
    _checkClipboard();
  }

  Future<void> _checkClipboard() async {
    while (_monitoring) {
      await Future.delayed(const Duration(milliseconds: 1200));
      try {
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        final text = data?.text?.trim();
        if (text != null && text.isNotEmpty && text != _lastText) {
          _lastText = text;
          // Avoid duplicate top entry
          _history.removeWhere((item) => item.text == text && !item.isPinned);
          _history.insert(0, ClipboardItem(text: text, timestamp: DateTime.now()));
          if (_history.length > 50) _history.removeLast();
        }
      } catch (_) {}
    }
  }

  void stopMonitoring() {
    _monitoring = false;
  }

  Future<void> copyToClipboard(String text) async {
    _lastText = text;
    await Clipboard.setData(ClipboardData(text: text));
  }

  void clearHistory() {
    _history.removeWhere((item) => !item.isPinned);
  }

  void togglePin(int index) {
    if (index >= 0 && index < _history.length) {
      _history[index] = _history[index].copyWith(isPinned: !_history[index].isPinned);
    }
  }
}
