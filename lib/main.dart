import 'package:flutter/material.dart';
import 'package:gurps_character_creation/pages/homepage.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GURPS Character Creation',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 134, 53, 39),
          onPrimary: Color(0xFFfefefe),
          secondary: Color(0xFF4527A0),
          onSecondary: Color(0xFFfefefe),
          error: Color(0xFFFF6E40),
          onError: Color(0xFFfefefe),
          surface: Color(0xFFfefefe),
          onSurface: Color(0xFF212121),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme(
          brightness: Brightness.dark,
          primary: Colors.cyan[100]!,
          onPrimary: Color(0xFF212121),
          secondary: Color(0xFFB39DDB),
          onSecondary: Color(0xFEFEFEFF),
          error: Colors.red,
          onError: Color(0xFEFEFEFF),
          surface: Color(0xFF212121),
          onSurface: Color(0xFFfefefe),
        ),
      ),
      themeMode: ThemeMode.system,
      routes: Map.fromEntries(
        routes.map(
          (route) => MapEntry(route.destination, (context) => route.page),
        ),
      ),
      initialRoute: '/',
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Homepage();
  }
}
