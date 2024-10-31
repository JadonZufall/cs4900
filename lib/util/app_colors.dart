import 'package:flutter/material.dart';

class AppColors {
  static const Color backgroundColor = Color.fromRGBO(18, 25, 33,1);

  static Color darken(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }
  static Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }
}