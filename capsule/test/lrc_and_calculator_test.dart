import 'package:flutter_test/flutter_test.dart';
import 'package:capsule/features/media/services/lrc_parser.dart';
import 'package:capsule/features/toolbox/calculator/services/calculator_service.dart';
import 'package:capsule/features/weather/models/weather_model.dart';

void main() {
  group('LrcParser Tests (Migrated from eIsland)', () {
    test('parseLrcTime correctly converts timestamps to milliseconds', () {
      expect(LrcParser.parseLrcTime('01:23.45'), 83450);
      expect(LrcParser.parseLrcTime('00:05.500'), 5500);
      expect(LrcParser.parseLrcTime('02:00.00'), 120000);
      expect(LrcParser.parseLrcTime('invalid'), isNull);
    });

    test('cleanTitle strips remix, feat, and brackets', () {
      expect(LrcParser.cleanTitle('Blinding Lights (feat. Daft Punk) - Live'), 'Blinding Lights');
      expect(LrcParser.cleanTitle('Starboy [Remastered 2026]'), 'Starboy');
      expect(LrcParser.cleanTitle('Ordinary Song'), 'Ordinary Song');
    });

    test('cleanArtist retains only the primary artist', () {
      expect(LrcParser.cleanArtist('The Weeknd, Daft Punk & Friends'), 'The Weeknd');
      expect(LrcParser.cleanArtist('Kendrick Lamar / SZA'), 'Kendrick Lamar');
      expect(LrcParser.cleanArtist('Dua Lipa'), 'Dua Lipa');
    });

    test('parseSyncedLrc extracts valid lyric lines sorted by timestamp', () {
      const sample = '''
[00:10.00]First line
[00:05.00]Intro line
[00:15.50]Chorus line
[00:01.00]作词: Artist Name
''';
      final lines = LrcParser.parseSyncedLrc(sample);
      expect(lines.length, 3);
      expect(lines[0].timeMs, 5000);
      expect(lines[0].text, 'Intro line');
      expect(lines[1].timeMs, 10000);
      expect(lines[1].text, 'First line');
      expect(lines[2].timeMs, 15500);
      expect(lines[2].text, 'Chorus line');
    });
  });

  group('CalculatorService Tests (Migrated from eIsland)', () {
    final calc = CalculatorService.instance;

    test('evaluates basic arithmetic with proper precedence', () {
      expect(calc.evaluate('2 + 3 * 4'), 14.0);
      expect(calc.evaluate('(2 + 3) * 4'), 20.0);
      expect(calc.evaluate('100 ÷ 4 - 5'), 20.0);
    });

    test('evaluates powers and scientific functions', () {
      expect(calc.evaluate('2 ^ 3'), 8.0);
      expect(calc.evaluate('sqrt(16) + 1'), 5.0);
    });

    test('converts units correctly', () {
      expect(CalculatorService.convertUnit(value: 1000, from: 'm', to: 'km', category: 'Length'), 1.0);
      expect(CalculatorService.convertUnit(value: 32, from: '°F', to: '°C', category: 'Temperature'), 0.0);
      expect(CalculatorService.convertUnit(value: 1024, from: 'MB', to: 'GB', category: 'Storage'), 1.0);
    });
  });

  group('WeatherModel Tests', () {
    test('returns correct weather symbols for WMO codes', () {
      const clear = WeatherModel(
        cityName: 'City',
        temperature: 20,
        weatherCode: 0,
        humidity: 50,
        windSpeed: 5,
        tempMax: 22,
        tempMin: 18,
        description: 'Clear',
      );
      expect(clear.iconSymbol, '☀️');

      const rain = WeatherModel(
        cityName: 'City',
        temperature: 15,
        weatherCode: 61,
        humidity: 90,
        windSpeed: 10,
        tempMax: 18,
        tempMin: 12,
        description: 'Rain',
      );
      expect(rain.iconSymbol, '🌧️');
    });
  });
}
