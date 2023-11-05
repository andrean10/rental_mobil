import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SharedTheme {
  static const _primaryColor = Color(0xFF006E26);

  static final _primaryTextStyle = GoogleFonts.josefinSans().fontFamily;
  static final _secondaryTextStyle = GoogleFonts.openSans().fontFamily;

  static const thin = FontWeight.w100;
  static const extraLight = FontWeight.w200;
  static const light = FontWeight.w300;
  static const regular = FontWeight.w400;
  static const medium = FontWeight.w500;
  static const semiBold = FontWeight.w600;
  static const bold = FontWeight.w700;
  static const extraBold = FontWeight.w800;
  static const black = FontWeight.w900;

  // static const _lightColorScheme = ColorScheme(
  //   brightness: Brightness.light,
  //   primary: Color(0xFF006E26),
  //   onPrimary: Color(0xFFFFFFFF),
  //   primaryContainer: Color(0xFF86FB91),
  //   onPrimaryContainer: Color(0xFF002106),
  //   secondary: Color(0xFF526350),
  //   onSecondary: Color(0xFFFFFFFF),
  //   secondaryContainer: Color(0xFFD5E8D0),
  //   onSecondaryContainer: Color(0xFF101F10),
  //   tertiary: Color(0xFF39656B),
  //   onTertiary: Color(0xFFFFFFFF),
  //   tertiaryContainer: Color(0xFFBCEBF2),
  //   onTertiaryContainer: Color(0xFF001F23),
  //   error: Color(0xFFBA1A1A),
  //   errorContainer: Color(0xFFFFDAD6),
  //   onError: Color(0xFFFFFFFF),
  //   onErrorContainer: Color(0xFF410002),
  //   background: Color(0xFFFCFDF7),
  //   onBackground: Color(0xFF1A1C19),
  //   surface: Color(0xFFFCFDF7),
  //   onSurface: Color(0xFF1A1C19),
  //   surfaceVariant: Color(0xFFDEE5D9),
  //   onSurfaceVariant: Color(0xFF424940),
  //   outline: Color(0xFF72796F),
  //   onInverseSurface: Color(0xFFF0F1EB),
  //   inverseSurface: Color(0xFF2F312D),
  //   inversePrimary: Color(0xFF69DE77),
  //   shadow: Color(0xFF000000),
  //   surfaceTint: Color(0xFF006E26),
  //   outlineVariant: Color(0xFFC2C9BD),
  //   scrim: Color(0xFF000000),
  // );

  // static const _darkColorScheme = ColorScheme(
  //   brightness: Brightness.dark,
  //   primary: Color(0xFF69DE77),
  //   onPrimary: Color(0xFF003910),
  //   primaryContainer: Color(0xFF00531A),
  //   onPrimaryContainer: Color(0xFF86FB91),
  //   secondary: Color(0xFFB9CCB5),
  //   onSecondary: Color(0xFF243424),
  //   secondaryContainer: Color(0xFF3A4B39),
  //   onSecondaryContainer: Color(0xFFD5E8D0),
  //   tertiary: Color(0xFFA1CED5),
  //   onTertiary: Color(0xFF00363C),
  //   tertiaryContainer: Color(0xFF1F4D53),
  //   onTertiaryContainer: Color(0xFFBCEBF2),
  //   error: Color(0xFFFFB4AB),
  //   errorContainer: Color(0xFF93000A),
  //   onError: Color(0xFF690005),
  //   onErrorContainer: Color(0xFFFFDAD6),
  //   background: Color(0xFF1A1C19),
  //   onBackground: Color(0xFFE2E3DD),
  //   surface: Color(0xFF1A1C19),
  //   onSurface: Color(0xFFE2E3DD),
  //   surfaceVariant: Color(0xFF424940),
  //   onSurfaceVariant: Color(0xFFC2C9BD),
  //   outline: Color(0xFF8C9388),
  //   onInverseSurface: Color(0xFF1A1C19),
  //   inverseSurface: Color(0xFFE2E3DD),
  //   inversePrimary: Color(0xFF006E26),
  //   shadow: Color(0xFF000000),
  //   surfaceTint: Color(0xFF69DE77),
  //   outlineVariant: Color(0xFF424940),
  //   scrim: Color(0xFF000000),
  // );

  static final _textThemeStyle = TextTheme(
    bodyLarge: TextStyle(fontFamily: _secondaryTextStyle),
    bodyMedium: TextStyle(fontFamily: _secondaryTextStyle),
    bodySmall: TextStyle(fontFamily: _secondaryTextStyle),
  );

  static final lightTheme = ThemeData(
    useMaterial3: true,
    colorSchemeSeed: _primaryColor,
    fontFamily: _primaryTextStyle,
    textTheme: _textThemeStyle,
  );

  // static final darkTheme = ThemeData(
  //   useMaterial3: true,
  //   // colorSchemeSeed: const Color(0xff2FA849),
  //   colorScheme: _darkColorScheme,
  //   fontFamily: _primaryTextStyle,
  //   textTheme: _textThemeStyle,
  // );
}
