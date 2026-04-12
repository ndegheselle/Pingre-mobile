import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forui/forui.dart';
import 'package:pingre/theme_extensions.dart';

/// Pastel light theme — maps the "light" DaisyUI theme palette onto ForUI.
///
/// Key colour decisions:
///  - background / card : base-100 (#FFFFFF)
///  - muted             : base-200 (near-white blue-tinted gray)
///  - border            : base-300 (light gray)
///  - foreground        : base-content  ≈ oklch(20 % 0 0)
///  - primary           : #fbcfb3  (pastel peach)
///  - secondary         : #8bbdc8  (soft blue)
///  - error/destructive : error-content  ≈ oklch(50 % 0.213 27.5)
FThemeData buildPingreLight() {
  const colors = FColors(
    brightness: Brightness.light,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    barrier: Color(0x33000000),
    // base-100 → pure white background
    background: Color(0xFFFFFFFF),
    // base-content oklch(20 % 0 0) → near-black text
    foreground: Color(0xFF333333),
    // primary #fbcfb3 pastel peach
    primary: Color(0xFFFBCFB3),
    // primary-content #912621 dark burgundy
    primaryForeground: Color(0xFF912621),
    // secondary #8bbdc8 soft blue
    secondary: Color(0xFF8BBDC8),
    // secondary-content #1b444c dark teal
    secondaryForeground: Color(0xFF1B444C),
    // base-200 oklch(98.5 % 0.001 247.8) → pale blue-white
    muted: Color(0xFFF5F8FA),
    // neutral oklch(55 % 0.046 257.4) → medium blue-gray
    mutedForeground: Color(0xFF687599),
    // error-content oklch(50 % 0.213 27.5) → readable dark red (used for CTAs that destroy)
    destructive: Color(0xFFC04438),
    destructiveForeground: Color(0xFFFAFAFA),
    // error oklch(80 % 0.114 19.6) → light coral for error surfaces
    error: Color(0xFFE8A09A),
    // error-content again for text on top of error surfaces
    errorForeground: Color(0xFFB83C38),
    card: Color(0xFFFFFFFF),
    // base-300 oklch(92.5 % 0.001 247.8) → light gray border
    border: Color(0xFFE5E8EC),
  );

  return FThemes.zinc.light.copyWith(
    colors: colors,
    extensions: const [
      AppSemanticColors(
        // success-content oklch(50 % 0.118 165.6) → medium green (income)
        positive: Color(0xFF3A9A78),
        // error-content oklch(50 % 0.213 27.5) → dark red (expense)
        negative: Color(0xFFC04438),
      ),
    ],
  );
}

/// Dim dark theme — maps the "dark" DaisyUI theme palette onto ForUI.
///
/// Key colour decisions:
///  - background        : base-100  ≈ oklch(30.9 % 0.023 264.1)  dark navy
///  - card              : base-200  ≈ oklch(28.0 % 0.019 264.2)  slightly deeper navy
///  - border            : base-300  ≈ oklch(26.3 % 0.018 262.2)  even deeper
///  - foreground        : base-content ≈ oklch(82.9 % 0.031 223) light blue-gray
///  - primary           : #f88479  coral / salmon
///  - secondary         : #44b2af  teal
///  - error/destructive : error oklch(82.4 % 0.099 33.8) soft warm peach
FThemeData buildPingreDark() {
  const colors = FColors(
    brightness: Brightness.dark,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    barrier: Color(0x66000000),
    // base-100 oklch(30.9 % 0.023 264.1) → dark navy-charcoal
    background: Color(0xFF2E3447),
    // base-content oklch(82.9 % 0.031 223) → light blue-gray text
    foreground: Color(0xFFB9C8D4),
    // primary #f88479 coral
    primary: Color(0xFFF88479),
    // primary-content oklch(17.2 % 0.028 139.5) → very dark forest green
    primaryForeground: Color(0xFF182618),
    // secondary #44b2af teal
    secondary: Color(0xFF44B2AF),
    // secondary-content oklch(14.7 % 0.033 35.4) → very dark brown
    secondaryForeground: Color(0xFF231510),
    // neutral oklch(24.7 % 0.02 264.1) → dark navy (for muted surfaces)
    muted: Color(0xFF202A38),
    // mid-tone between bg and fg for subdued text
    mutedForeground: Color(0xFF8090A8),
    // error oklch(82.4 % 0.099 33.8) → soft warm peach (used for danger CTAs)
    destructive: Color(0xFFEDAA8A),
    // error-content oklch(16.5 % 0.019 33.8) → very dark brown
    destructiveForeground: Color(0xFF251410),
    // error surface = same peach in dark mode
    error: Color(0xFFEDAA8A),
    errorForeground: Color(0xFF251410),
    // base-200 oklch(28.0 % 0.019 264.2) → card slightly deeper than bg
    card: Color(0xFF252E3E),
    // base-300 oklch(26.3 % 0.018 262.2) → border even deeper
    border: Color(0xFF222A38),
  );

  return FThemes.zinc.dark.copyWith(
    colors: colors,
    extensions: const [
      AppSemanticColors(
        // success oklch(90 % 0.093 164.2) → soft mint, readable on dark
        positive: Color(0xFFAADECA),
        // error oklch(82.4 % 0.099 33.8) → warm peach, readable on dark
        negative: Color(0xFFEDAA8A),
      ),
    ],
  );
}
