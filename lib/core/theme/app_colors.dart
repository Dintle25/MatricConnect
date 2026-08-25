import 'package:flutter/material.dart';

// All the brand colors live here so we never hardcode a hex code
// somewhere random in a widget. Pulled from the app's moodboard:
// soft lavender background, deep purple accents, a pink highlight
// card, and a teal "done" color.
class AppColors {
  AppColors._();

  // Backgrounds
  static const Color background = Color(0xFFEDE6F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceMuted = Color(0xFFF5F1FB);

  // Purple family (primary brand color)
  static const Color primary = Color(0xFF8B6FD9);
  static const Color primaryDark = Color(0xFF4B2E83);
  static const Color primarySoft = Color(0xFFD9CDF2);

  // Accent colors, one per resource "type" so students can scan fast
  static const Color pinkAccent = Color(0xFFF3AFC0);
  static const Color tealAccent = Color(0xFF3F7C74);
  static const Color goldAccent = Color(0xFFE0A94E);
  static const Color blueAccent = Color(0xFF6E9CE0);

  // Text
  static const Color textPrimary = Color(0xFF221C35);
  static const Color textMuted = Color(0xFF8E859E);
  static const Color textOnDark = Color(0xFFFFFFFF);

  // Status colors used by the friendly error snackbars
  static const Color success = Color(0xFF3F9D6F);
  static const Color warning = Color(0xFFE0A94E);
  static const Color error = Color(0xFFE0637A);
  static const Color info = Color(0xFF6E9CE0);

  // Dark mode variants (kept close to the light palette so the brand
  // still feels the same at night, just deeper).
  static const Color backgroundDark = Color(0xFF1B1526);
  static const Color surfaceDark = Color(0xFF261E38);
}
