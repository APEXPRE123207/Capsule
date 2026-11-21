/// Weather representation matching Open-Meteo data models
class WeatherModel {
  const WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.weatherCode,
    required this.humidity,
    required this.windSpeed,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    this.forecasts = const [],
  });

  final String cityName;
  final double temperature;
  final int weatherCode;
  final int humidity;
  final double windSpeed;
  final double tempMax;
  final double tempMin;
  final String description;
  final List<DailyForecast> forecasts;

  /// Returns an emoji or iconic symbol for the WMO weather code
  String get iconSymbol {
    switch (weatherCode) {
      case 0:
        return '☀️'; // Clear sky
      case 1:
      case 2:
      case 3:
        return '⛅'; // Partly cloudy
      case 45:
      case 48:
        return '🌫️'; // Fog
      case 51:
      case 53:
      case 55:
      case 61:
      case 63:
      case 65:
        return '🌧️'; // Rain
      case 71:
      case 73:
      case 75:
        return '❄️'; // Snow
      case 80:
      case 81:
      case 82:
        return '🌦️'; // Showers
      case 95:
      case 96:
      case 99:
        return '⛈️'; // Thunderstorm
      default:
        return '🌤️';
    }
  }
}

class DailyForecast {
  const DailyForecast({
    required this.dayName,
    required this.tempMax,
    required this.tempMin,
    required this.weatherCode,
  });

  final String dayName;
  final double tempMax;
  final double tempMin;
  final int weatherCode;

  String get iconSymbol {
    if (weatherCode == 0) return '☀️';
    if (weatherCode <= 3) return '⛅';
    if (weatherCode >= 51 && weatherCode <= 65) return '🌧️';
    if (weatherCode >= 71 && weatherCode <= 77) return '❄️';
    if (weatherCode >= 95) return '⛈️';
    return '🌤️';
  }
}
