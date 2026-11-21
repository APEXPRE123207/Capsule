import 'package:shared_preferences/shared_preferences.dart';

/// Persistent user configuration for Capsule
class SettingsService {
  SettingsService._();
  static final SettingsService instance = SettingsService._();

  static const String _keyIslandWidth = 'island_width';
  static const String _keyCornerRadius = 'corner_radius';
  static const String _keyAlwaysOnTop = 'always_on_top';
  static const String _keyWeatherCity = 'weather_city';
  static const String _keyLaunchOnStartup = 'launch_on_startup';

  late SharedPreferences _prefs;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();
    _initialized = true;
  }

  double get islandWidth => _prefs.getDouble(_keyIslandWidth) ?? 210.0;
  set islandWidth(double val) => _prefs.setDouble(_keyIslandWidth, val);

  double get cornerRadius => _prefs.getDouble(_keyCornerRadius) ?? 19.0;
  set cornerRadius(double val) => _prefs.setDouble(_keyCornerRadius, val);

  bool get alwaysOnTop => _prefs.getBool(_keyAlwaysOnTop) ?? true;
  set alwaysOnTop(bool val) => _prefs.setBool(_keyAlwaysOnTop, val);

  String get weatherCity => _prefs.getString(_keyWeatherCity) ?? 'Kolkata';
  set weatherCity(String val) => _prefs.setString(_keyWeatherCity, val);

  bool get launchOnStartup => _prefs.getBool(_keyLaunchOnStartup) ?? false;
  set launchOnStartup(bool val) => _prefs.setBool(_keyLaunchOnStartup, val);
}
