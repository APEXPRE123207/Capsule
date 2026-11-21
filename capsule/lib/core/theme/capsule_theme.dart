import 'package:flutter/material.dart';

/// Design tokens and styling for Capsule
class CapsuleTheme {
  CapsuleTheme._();

  // Background colors
  static const Color islandBlack = Color(0xFF000000);
  static const Color islandCard = Color(0xFF141416);
  static const Color surfaceGlass = Color(0xCC1A1A1E);
  static const Color surfaceHighlight = Color(0x1AFFFFFF);

  // Borders & Dividers
  static const Color subtleBorder = Color(0x26FFFFFF);
  static const Color subtleGlow = Color(0x1F38BDF8);

  // Accents
  static const Color accentCyan = Color(0xFF38BDF8);
  static const Color accentGreen = Color(0xFF34D399);
  static const Color accentAmber = Color(0xFFFBBF24);
  static const Color accentRose = Color(0xFFFB7185);

  // Text colors
  static const Color textPrimary = Color(0xFFF3F4F6);
  static const Color textSecondary = Color(0xFF9CA3AF);
  static const Color textMuted = Color(0xFF6B7280);

  // Spring animation curves
  static const Curve springCurve = Curves.easeOutCubic;
  static const Duration fastDuration = Duration(milliseconds: 220);
  static const Duration morphDuration = Duration(milliseconds: 340);
  static const Duration springDuration = Duration(milliseconds: 460);
}
