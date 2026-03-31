import 'package:flutter/material.dart';

ThemeData dark({Color primaryColor = const Color(0xFFF8A718)}) => ThemeData(
  fontFamily: 'TitilliumWeb',
  primaryColor: primaryColor,
  brightness: Brightness.dark,
  highlightColor: const Color(0xFF252525),
  hintColor: const Color(0xFFc7c7c7),
  cardColor: const Color(0xFF242424),
  scaffoldBackgroundColor: const Color(0xFF000000),
  colorScheme : ColorScheme.dark(
    primary: primaryColor,
    secondary: const Color(0xFF78BDFC),
    tertiary: const Color(0xFF865C0A),
    tertiaryContainer: const Color(0xFF6C7A8E),
    background: const Color(0xFF2D2D2D),
    onPrimary: const Color(0xFFB7D7FE),
    onTertiaryContainer: const Color(0xFF0F5835),
    primaryContainer: const Color(0xFF208458),
    onSecondaryContainer: const Color(0x912A2A2A),
    outline: const Color(0xff2C66B4),
    onTertiary: const Color(0xFF545252),
    secondaryContainer: const Color(0xFFF2F2F2),),
  textTheme: const TextTheme(bodyLarge: TextStyle(color: Color(0xFFE9EEF4))),

  pageTransitionsTheme: const PageTransitionsTheme(builders: {
    TargetPlatform.android: ZoomPageTransitionsBuilder(),
    TargetPlatform.iOS: ZoomPageTransitionsBuilder(),
    TargetPlatform.fuchsia: ZoomPageTransitionsBuilder(),
  }),
);
