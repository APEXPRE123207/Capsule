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

  bool _initialized = false;

  // Window bounds allocation to encompass all states without clipping shadows
  static const double maxWindowWidth = 500.0;
  static const double maxWindowHeight = 460.0;

  Future<void> initialize() async {
    if (_initialized) return;

    if (!kIsWeb && Platform.isWindows) {
      try {
        await windowManager.ensureInitialized();

        const windowOptions = WindowOptions(
          size: Size(maxWindowWidth, maxWindowHeight),
          center: false,
          backgroundColor: Colors.transparent,
          skipTaskbar: true,
          titleBarStyle: TitleBarStyle.hidden,
          alwaysOnTop: true,
        );

        await windowManager.waitUntilReadyToShow(windowOptions, () async {
          await windowManager.setAsFrameless();
          await windowManager.setHasShadow(false);

          // Center the floating window at top of primary screen
          try {
            final primary = await screenRetriever.getPrimaryDisplay();
            final visiblePos = primary.visiblePosition;
            final visibleSize = primary.visibleSize;
            if (visiblePos != null && visibleSize != null) {
              final posX = visiblePos.dx + (visibleSize.width - maxWindowWidth) / 2.0;
              final posY = visiblePos.dy;
              await windowManager.setPosition(Offset(posX, posY));
            }
          } catch (_) {}

          await windowManager.show();
          await windowManager.focus();
        });
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
