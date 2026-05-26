import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary palette — deep emerald + warm gold
  static const Color emeraldDeep = Color(0xFF1C3A2E);
  static const Color emeraldMid = Color(0xFF2D5E45);
  static const Color emeraldLight = Color(0xFF4A8B68);
  static const Color emeraldSurface = Color(0xFFD4E8DB);
  static const Color emeraldTint = Color(0xFFEAF3EE);

  // Gold accents
  static const Color goldPrimary = Color(0xFFC8970A);
  static const Color goldLight = Color(0xFFE8B84B);
  static const Color goldPale = Color(0xFFF5EDD0);

  // Neutral / background
  static const Color ivory = Color(0xFFF5F0E8);
  static const Color ivorySurface = Color(0xFFFBF7EF);
  static const Color warmWhite = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1C3A2E);
  static const Color textSecondary = Color(0xFF5A7A6A);
  static const Color textMuted = Color(0xFF9ABCAB);
  static const Color textOnDark = Color(0xFFF5EDD0);

  // Semantic
  static const Color error = Color(0xFFDC2626);
  static const Color success = Color(0xFF15803D);

  // Card style themes
  static const Map<String, List<Color>> cardThemes = {
    'Classic': [emeraldDeep, Color(0xFF152E24)],
    'Luxe': [Color(0xFF5C2E3A), Color(0xFF3A1A22)],
    'Night': [Color(0xFF1A2744), Color(0xFF0D1528)],
    'Ivory': [Color(0xFFFBF5E6), Color(0xFFEDE5D0)],
    'Sage': [Color(0xFF4A6B5A), Color(0xFF2E4A3A)],
  };
}
