import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class AppSemanticColors extends ThemeExtension<AppSemanticColors> {
  final Color positive;
  final Color negative;

  const AppSemanticColors({
    required this.positive,
    required this.negative,
  });

  @override
  AppSemanticColors copyWith({
    Color? positive,
    Color? negative,
  }) {
    return AppSemanticColors(
      positive: positive ?? this.positive,
      negative: negative ?? this.negative,
    );
  }

  @override
  AppSemanticColors lerp(
      ThemeExtension<AppSemanticColors>? other, double t) {
    if (other is! AppSemanticColors) return this;

    return AppSemanticColors(
      positive: Color.lerp(positive, other.positive, t)!,
      negative: Color.lerp(negative, other.negative, t)!,
    );
  }
}

extension AppSemanticColorsGetter on FThemeData {
  AppSemanticColors get semantic => extension<AppSemanticColors>();
}