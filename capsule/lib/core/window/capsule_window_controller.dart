import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:screen_retriever/screen_retriever.dart';
import 'package:window_manager/window_manager.dart';
import '../../features/island/models/island_state.dart';

/// Manages the native floating desktop window, positioning, and transparency
class CapsuleWindowController {
  CapsuleWindowController._();
  static final CapsuleWindowController instance = CapsuleWindowController._();

  Window? _window;
  bool _initialized = false;

  // Window bounds allocation to encompass all states without clipping shadows
  static const double maxWindowWidth = 500.0;
  static const double maxWindowHeight = 420.0;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!kIsWeb && Platform.isWindows) {
      try {
        _window = WindowManager.instance.getCurrent();
        if (_window != null) {
          _window!.setFrameless(true);
          _window!.isAlwaysOnTop = true;
          _window!.isVisibleInTaskbar = false;
          _window!.hasShadow = false;
          _window!.backgroundColor = Colors.transparent.toNative();

          // Center the floating window at top of primary screen
          final primary = DisplayManager.instance.getPrimary();
          if (primary != null) {
            final workArea = primary.workArea.toRect();
            final posX = workArea.left + (workArea.width - maxWindowWidth) / 2.0;
            final posY = workArea.top;

            _window!.bounds = Rect.fromLTWH(
              posX,
              posY,
              maxWindowWidth,
              maxWindowHeight,
            ).toNative();
          }

          _window!.show();
        }
      } catch (e) {
        debugPrint('[CapsuleWindowController] Window setup notice: $e');
      }
    }

    _initialized = true;
  }

  void onStateChanged(IslandState newState) {
    debugPrint('[Capsule] Island state switched to: ${newState.name}');
  }
}
