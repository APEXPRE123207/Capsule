import 'dart:math' as math;

/// Scientific calculator calculation and unit conversion engine ported from eIsland
class CalculatorService {
  CalculatorService._();
  static final CalculatorService instance = CalculatorService._();

  final List<String> _history = [];
  List<String> get history => List.unmodifiable(_history);

  /// Evaluates an arithmetic expression string with support for basic and scientific functions
  double evaluate(String expression) {
    String expr = expression.replaceAll('×', '*').replaceAll('÷', '/').replaceAll('π', '${math.pi}').replaceAll('e', '${math.e}').trim();
    if (expr.isEmpty) return 0.0;

    try {
      final result = _parseExpression(expr);
      _history.insert(0, '$expression = $result');
      if (_history.length > 20) {
        _history.removeLast();
      }
      return result;
    } catch (_) {
      throw FormatException('Invalid Expression: $expression');
    }
  }

  double _parseExpression(String expr) {
    List<String> tokens = _tokenize(expr);
    int pos = 0;

    late double Function() parseAddSub;

    double parsePrimary() {
      if (pos >= tokens.length) return 0.0;
      final token = tokens[pos++];

      if (token == '(') {
        final val = parseAddSub();
        if (pos < tokens.length && tokens[pos] == ')') {
          pos++;
        }
        return val;
      } else if (token == 'sin') {
        return math.sin(parsePrimary());
      } else if (token == 'cos') {
        return math.cos(parsePrimary());
      } else if (token == 'tan') {
        return math.tan(parsePrimary());
      } else if (token == 'sqrt' || token == '√') {
        return math.sqrt(parsePrimary());
      } else if (token == 'ln') {
        return math.log(parsePrimary());
      } else if (token == '-') {
        return -parsePrimary();
      }

      return double.tryParse(token) ?? 0.0;
    }

    double parsePower() {
      var val = parsePrimary();
      while (pos < tokens.length && tokens[pos] == '^') {
        pos++;
        val = math.pow(val, parsePrimary()).toDouble();
      }
      return val;
    }

    double parseMulDiv() {
      var val = parsePower();
      while (pos < tokens.length && (tokens[pos] == '*' || tokens[pos] == '/' || tokens[pos] == '%')) {
        final op = tokens[pos++];
        final next = parsePower();
        if (op == '*') {
          val *= next;
        } else if (op == '/') {
          val = next != 0 ? val / next : double.nan;
        } else if (op == '%') {
          val %= next;
        }
      }
      return val;
    }

    parseAddSub = () {
      var val = parseMulDiv();
      while (pos < tokens.length && (tokens[pos] == '+' || tokens[pos] == '-')) {
        final op = tokens[pos++];
        final next = parseMulDiv();
        if (op == '+') {
          val += next;
        } else if (op == '-') {
          val -= next;
        }
      }
      return val;
    };

    return parseAddSub();
  }

  List<String> _tokenize(String s) {
    final tokens = <String>[];
    int i = 0;
    while (i < s.length) {
      final ch = s[i];
      if (ch == ' ') {
        i++;
      } else if ('+-*/%^()'.contains(ch)) {
        tokens.add(ch);
        i++;
      } else if (RegExp(r'[0-9.]').hasMatch(ch)) {
        int start = i;
        while (i < s.length && RegExp(r'[0-9.]').hasMatch(s[i])) {
          i++;
        }
        tokens.add(s.substring(start, i));
      } else if (RegExp(r'[a-zA-Z]').hasMatch(ch)) {
        int start = i;
        while (i < s.length && RegExp(r'[a-zA-Z]').hasMatch(s[i])) {
          i++;
        }
        tokens.add(s.substring(start, i));
      } else {
        i++;
      }
    }
    return tokens;
  }

  /// Convert units (Length, Temperature, Storage)
  static double convertUnit({
    required double value,
    required String from,
    required String to,
    required String category,
  }) {
    if (from == to) return value;

    if (category == 'Length') {
      final toMeters = {'m': 1.0, 'km': 1000.0, 'cm': 0.01, 'mm': 0.001, 'inch': 0.0254, 'ft': 0.3048};
      final m = value * (toMeters[from] ?? 1.0);
      return m / (toMeters[to] ?? 1.0);
    } else if (category == 'Temperature') {
      double c = value;
      if (from == '°F') {
        c = (value - 32) * 5 / 9;
      } else if (from == 'K') {
        c = value - 273.15;
      }

      if (to == '°F') return (c * 9 / 5) + 32;
      if (to == 'K') return c + 273.15;
      return c;
    } else if (category == 'Storage') {
      final toMb = {'KB': 0.0009765625, 'MB': 1.0, 'GB': 1024.0, 'TB': 1048576.0};
      final mb = value * (toMb[from] ?? 1.0);
      return mb / (toMb[to] ?? 1.0);
    }

    return value;
  }
}
