import 'dart:io';
import 'package:flutter/material.dart';

class AppItem {
  const AppItem({
    required this.name,
    required this.path,
    this.iconData,
  });

  final String name;
  final String path;
  final IconData? iconData;
}

/// Discovers installed Windows applications and common utilities
class AppLauncherService {
  AppLauncherService._();
  static final AppLauncherService instance = AppLauncherService._();

  List<AppItem>? _cachedApps;

  Future<List<AppItem>> getInstalledApps() async {
    if (_cachedApps != null) return _cachedApps!;

    final apps = <AppItem>[
      const AppItem(name: 'File Explorer', path: 'explorer.exe', iconData: Icons.folder_rounded),
      const AppItem(name: 'Command Prompt', path: 'cmd.exe', iconData: Icons.terminal_rounded),
      const AppItem(name: 'PowerShell', path: 'powershell.exe', iconData: Icons.code_rounded),
      const AppItem(name: 'Task Manager', path: 'taskmgr.exe', iconData: Icons.assessment_rounded),
      const AppItem(name: 'Notepad', path: 'notepad.exe', iconData: Icons.description_rounded),
      const AppItem(name: 'Calculator', path: 'calc.exe', iconData: Icons.calculate_rounded),
      const AppItem(name: 'Windows Settings', path: 'ms-settings:', iconData: Icons.settings_rounded),
      const AppItem(name: 'Google Chrome', path: 'chrome.exe', iconData: Icons.public_rounded),
      const AppItem(name: 'Microsoft Edge', path: 'msedge.exe', iconData: Icons.language_rounded),
    ];

    if (Platform.isWindows) {
      // Scan Start Menu shortcuts
      final appData = Platform.environment['APPDATA'];
      final programData = Platform.environment['ProgramData'];

      for (final base in [
        if (appData != null) '$appData\\Microsoft\\Windows\\Start Menu\\Programs',
        if (programData != null) '$programData\\Microsoft\\Windows\\Start Menu\\Programs',
      ]) {
        try {
          final dir = Directory(base);
          if (dir.existsSync()) {
            for (final entity in dir.listSync(recursive: true)) {
              if (entity is File && entity.path.endsWith('.lnk')) {
                final name = entity.uri.pathSegments.last.replaceAll('.lnk', '');
                if (!name.toLowerCase().contains('uninstall') && !apps.any((a) => a.name == name)) {
                  apps.add(AppItem(name: name, path: entity.path, iconData: Icons.launch_rounded));
                }
              }
            }
          }
        } catch (_) {}
      }
    }

    _cachedApps = apps;
    return apps;
  }

  Future<bool> launchApp(AppItem app) async {
    try {
      if (app.path.startsWith('ms-settings:')) {
        await Process.run('cmd', ['/c', 'start', app.path]);
        return true;
      }
      await Process.start(app.path, [], mode: ProcessStartMode.detached);
      return true;
    } catch (_) {
      try {
        await Process.run('cmd', ['/c', 'start', '""', app.path]);
        return true;
      } catch (_) {
        return false;
      }
    }
  }
}
