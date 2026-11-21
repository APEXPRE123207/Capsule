import 'package:flutter/material.dart';
import '../../../../core/theme/capsule_theme.dart';
import '../services/calculator_service.dart';

/// Compact scientific calculator widget for the Capsule Hub
class CalculatorWidget extends StatefulWidget {
  const CalculatorWidget({super.key});

  @override
  State<CalculatorWidget> createState() => _CalculatorWidgetState();
}

class _CalculatorWidgetState extends State<CalculatorWidget> {
  String _display = '0';
  String _expression = '';
  bool _newNumber = true;

  void _onKey(String key) {
    setState(() {
      if (key == 'C') {
        _display = '0';
        _expression = '';
        _newNumber = true;
      } else if (key == '⌫') {
        if (_display.length > 1) {
          _display = _display.substring(0, _display.length - 1);
        } else {
          _display = '0';
          _newNumber = true;
        }
      } else if (key == '=') {
        try {
          final res = CalculatorService.instance.evaluate(_expression + _display);
          _display = res % 1 == 0 ? res.toInt().toString() : res.toStringAsFixed(4);
          _expression = '';
          _newNumber = true;
        } catch (_) {
          _display = 'Error';
          _newNumber = true;
        }
      } else if ('+-×÷^%'.contains(key)) {
        _expression += ' $_display $key ';
        _newNumber = true;
      } else {
        if (_newNumber) {
          _display = key;
          _newNumber = false;
        } else {
          _display += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      ['C', '⌫', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['0', '.', '^', '='],
    ];

    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: CapsuleTheme.islandCard,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: CapsuleTheme.subtleBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Display
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            alignment: Alignment.centerRight,
            decoration: BoxDecoration(
              color: CapsuleTheme.surfaceHighlight,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression,
                  style: const TextStyle(color: CapsuleTheme.textMuted, fontSize: 11.0),
                ),
                Text(
                  _display,
                  style: const TextStyle(
                    color: CapsuleTheme.textPrimary,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10.0),

          // Keypad
          Column(
            children: buttons.map((row) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: row.map((b) {
                    final isOp = '+-×÷=^%'.contains(b);
                    final isAction = 'C⌫'.contains(b);
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 3.0),
                        child: Material(
                          color: isOp
                              ? CapsuleTheme.accentCyan.withValues(alpha: 0.2)
                              : isAction
                                  ? CapsuleTheme.accentRose.withValues(alpha: 0.2)
                                  : CapsuleTheme.surfaceHighlight,
                          borderRadius: BorderRadius.circular(8.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(8.0),
                            onTap: () => _onKey(b),
                            child: Container(
                              height: 32.0,
                              alignment: Alignment.center,
                              child: Text(
                                b,
                                style: TextStyle(
                                  color: isOp
                                      ? CapsuleTheme.accentCyan
                                      : isAction
                                          ? CapsuleTheme.accentRose
                                          : CapsuleTheme.textPrimary,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
