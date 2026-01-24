import 'package:forui/forui.dart';
import 'package:flutter/material.dart';
import 'package:pingre/theme/colors.dart';

FThemeData get dark {
  const colors = FColors(
    brightness: .dark,
    systemOverlayStyle: .light,
    barrier: Color(0x33000000),
    background: Color(0xFF18181B),
    foreground: Color(0xFFE4E4E7),
    primary: Color(0xFF8B5CF6),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFF27272A),
    secondaryForeground: Color(0xFFE4E4E7),
    muted: Color(0xFF3F3F46),
    mutedForeground: Color(0xFFA1A1AA),
    destructive: Color(0xFFF87171),
    destructiveForeground: Color(0xFF18181B),
    error: Color(0xFFF87171),
    errorForeground: Color(0xFF18181B),
    border: Color(0xFF52525B),
  );

  final typography = _typography(colors: colors);
  final style = _style(colors: colors, typography: typography);

  return FThemeData(
    colors: colors,
    typography: typography,
    style: style,
    extensions: <ThemeExtension<dynamic>>[CustomColors.dark()],
  );
}

FThemeData get light {
  const colors = FColors(
    brightness: .light,
    systemOverlayStyle: .dark,
    barrier: Color(0x33000000),
    background: Color(0xFFFFFFFF),
    foreground: Color(0xFF09090B),
    primary: Color(0xFF18181B),
    primaryForeground: Color(0xFFFAFAFA),
    secondary: Color(0xFFF4F4F5),
    secondaryForeground: Color(0xFF18181B),
    muted: Color(0xFFF4F4F5),
    mutedForeground: Color(0xFF71717A),
    destructive: Color(0xFFEF4444),
    destructiveForeground: Color(0xFFFAFAFA),
    error: Color(0xFFEF4444),
    errorForeground: Color(0xFFFAFAFA),
    border: Color(0xFFE4E4E7),
  );

  final typography = _typography(colors: colors);
  final style = _style(colors: colors, typography: typography);

  return FThemeData(
    colors: colors,
    typography: typography,
    style: style,
    extensions: <ThemeExtension<dynamic>>[CustomColors.light()],
  );
}

FTypography _typography({
  required FColors colors,
  String defaultFontFamily = 'packages/forui/Inter',
}) => FTypography(
  xs: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 12,
    height: 1,
  ),
  sm: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 14,
    height: 1.25,
  ),
  base: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 16,
    height: 1.5,
  ),
  lg: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 18,
    height: 1.75,
  ),
  xl: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 20,
    height: 1.75,
  ),
  xl2: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 22,
    height: 2,
  ),
  xl3: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 30,
    height: 2.25,
  ),
  xl4: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 36,
    height: 2.5,
  ),
  xl5: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 48,
    height: 1,
  ),
  xl6: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 60,
    height: 1,
  ),
  xl7: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 72,
    height: 1,
  ),
  xl8: TextStyle(
    color: colors.foreground,
    fontFamily: defaultFontFamily,
    fontSize: 96,
    height: 1,
  ),
);

FStyle _style({required FColors colors, required FTypography typography}) =>
    FStyle(
      formFieldStyle: .inherit(colors: colors, typography: typography),
      focusedOutlineStyle: FFocusedOutlineStyle(
        color: colors.primary,
        borderRadius: const .all(.circular(8)),
      ),
      iconStyle: IconThemeData(color: colors.primary, size: 20),
      tappableStyle: FTappableStyle(),
      borderRadius: const FLerpBorderRadius.all(.circular(8), min: 24),
      borderWidth: 1,
      pagePadding: const .symmetric(vertical: 8, horizontal: 12),
      shadow: const [
        BoxShadow(
          color: Color(0x0d000000),
          offset: Offset(0, 1),
          blurRadius: 2,
        ),
      ],
    );
