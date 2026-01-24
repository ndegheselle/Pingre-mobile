import 'package:flutter/material.dart';
import 'package:forui/forui.dart';

class CustomColors extends ThemeExtension<CustomColors> {
  final Color success;
  // Add all your custom colors here

  const CustomColors({
    required this.success,
  });

  @override
  CustomColors copyWith({Color? success}) {
    return CustomColors(
      success: success ?? this.success,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      success: Color.lerp(success, other.success, t)!,
    );
  }

  factory CustomColors.light() => const CustomColors(
    success: Colors.yellow,
  );

  factory CustomColors.dark() => const CustomColors(
    success: Colors.cyan,
  );
}

// Use like this : context.colors.primaryBrand
extension ThemeColors on BuildContext {
  CustomColors get colors => FTheme.of(this).extension<CustomColors>();
}