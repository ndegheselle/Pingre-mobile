import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color success = const Color(0xFF48c78e);
  
  const CustomColors();

  @override
  CustomColors copyWith({Color? success}) {
    return CustomColors();
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors();
  }

  factory CustomColors.light() => const CustomColors();
  factory CustomColors.dark() => const CustomColors();
}

// Use like this : context.colors.primaryBrand
extension ThemeColors on BuildContext {
  CustomColors get colors => FTheme.of(this).extension<CustomColors>();
}