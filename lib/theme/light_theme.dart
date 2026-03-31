import 'package:flutter/material.dart';

ThemeData light({Color primaryColor = const Color(0xFFF8A718)}) => ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: primaryColor,
  brightness: Brightness.light,
  highlightColor: Colors.white,
  hintColor: const Color(0xFF9E9E9E),
  colorScheme: ColorScheme.light(primary: primaryColor,
    secondary: const Color(0xFF004C8E),
    tertiary: const Color(0xFFF9D4A8),
    tertiaryContainer: const Color(0xFFADC9F3),
    onTertiaryContainer: const Color(0xFF33AF74),
    onPrimary: const Color(0xFF7FBBFF),
    background: const Color(0xFFF4F8FF),
    onSecondary: const Color(0xFFF88030),
    error: const Color(0xFFFF5555),
    onSecondaryContainer: const Color(0xFFF3F9FF),
    outline: const Color(0xff2C66B4),
    onTertiary: const Color(0xFFE9F3FF),


    primaryContainer: const Color(0xFF9AECC6),secondaryContainer: const Color(0xFFF2F2F2),),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: CupertinoPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);