import 'package:flutter/material.dart';
import '../../../core/theme/capsule_theme.dart';
import '../models/weather_model.dart';
import '../services/weather_service.dart';

/// Glassmorphic weather widget for the Dynamic Island
class WeatherWidget extends StatefulWidget {
  const WeatherWidget({super.key});

  @override
  State<WeatherWidget> createState() => _WeatherWidgetState();
}

class _WeatherWidgetState extends State<WeatherWidget> {
  WeatherModel? _weather;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadWeather();
  }

  Future<void> _loadWeather() async {
    final data = await WeatherService.instance.fetchWeather();
    if (mounted) {
      setState(() {
        _weather = data;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _weather == null) {
      return Container(
        height: 120.0,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20.0,
          height: 20.0,
          child: CircularProgressIndicator(strokeWidth: 2.0, color: CapsuleTheme.accentCyan),
        ),
      );
    }

    final w = _weather!;

    return Container(
      padding: const EdgeInsets.all(14.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Top: Location & Current Temp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    w.iconSymbol,
                    style: const TextStyle(fontSize: 28.0),
                  ),
                  const SizedBox(width: 10.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        w.cityName,
                        style: const TextStyle(
                          color: CapsuleTheme.textPrimary,
                          fontSize: 14.0,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        w.description,
                        style: const TextStyle(
                          color: CapsuleTheme.textSecondary,
                          fontSize: 11.5,
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${w.temperature.toStringAsFixed(1)}°',
                    style: const TextStyle(
                      color: CapsuleTheme.textPrimary,
                      fontSize: 22.0,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    'H:${w.tempMax.toInt()}° L:${w.tempMin.toInt()}°',
                    style: const TextStyle(
                      color: CapsuleTheme.textMuted,
                      fontSize: 10.5,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12.0),

          // Mini Daily Forecast Row
          Row(
            children: w.forecasts.map((f) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  padding: const EdgeInsets.symmetric(vertical: 6.0),
                  decoration: BoxDecoration(
                    color: CapsuleTheme.surfaceHighlight,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    children: [
                      Text(
                        f.dayName,
                        style: const TextStyle(color: CapsuleTheme.textSecondary, fontSize: 10.5),
                      ),
                      const SizedBox(height: 2.0),
                      Text(f.iconSymbol, style: const TextStyle(fontSize: 14.0)),
                      const SizedBox(height: 2.0),
                      Text(
                        '${f.tempMax.toInt()}°',
                        style: const TextStyle(
                          color: CapsuleTheme.textPrimary,
                          fontSize: 11.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
