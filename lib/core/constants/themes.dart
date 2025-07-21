import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gurps_character_creation/core/themes/widgets/buttons.dart';
import 'package:gurps_character_creation/core/themes/widgets/card.dart';
import 'package:gurps_character_creation/core/themes/widgets/switch.dart';
import 'package:gurps_character_creation/core/themes/widgets/text_input.dart';

ThemeData defaultTheme(BuildContext context) => ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: Color(0xFF1565C0),
        onPrimary: Color(0xFFeeeeee),
        secondary: Color(0x3E9A9996),
        onSecondary: Color(0xFF363636),
        error: Color(0xFFD81B60),
        onError: Color(0xFFeeeeee),
        surface: Color(0xFFefefef),
        onSurface: Color(0xFF363636),
        shadow: Color(0x64222222),
      ),
      useMaterial3: true,
      fontFamily: GoogleFonts.lato().fontFamily,
      switchTheme: getSwitchThemeData(context),
      inputDecorationTheme: getInputDecorationTheme(context),
      cardTheme: getCardTheme(context),
      textButtonTheme: getTextButtonThemeData(context),
    );

ThemeData darkTheme(BuildContext context) => ThemeData(
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Color(0xFF7289da),
        onPrimary: Color(0xFFEEEEEE),
        secondary: Color(0x3E607D8B),
        onSecondary: Color(0xFFDCDCDC),
        error: Color(0xFFEF5350),
        onError: Color(0xFEFEFEFF),
        surface: Color(0xFF282b30),
        onSurface: Color(0xFFDCDCDC),
        shadow: Color(0x64222222),
      ),
      fontFamily: GoogleFonts.lato().fontFamily,
      useMaterial3: true,
      switchTheme: getSwitchThemeData(context),
      inputDecorationTheme: getInputDecorationTheme(context),
      cardTheme: getCardTheme(context),
      textButtonTheme: getTextButtonThemeData(context),
    );
