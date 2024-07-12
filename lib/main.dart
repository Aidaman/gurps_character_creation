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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Colors.indigo,
          onPrimary: Color(0xFEFEFEFF),
          secondary: Colors.deepOrange,
          onSecondary: Color(0xFEFEFEFF),
          error: Colors.red,
          onError: Color(0xFEFEFEFF),
          surface: Color(0xFEFEFEFF),
          onSurface: Color(0x212121FF),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
          colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: Colors.indigo,
        onPrimary: Color(0xFEFEFEFF),
        secondary: Colors.deepOrange,
        onSecondary: Color(0xFEFEFEFF),
        error: Colors.red,
        onError: Color(0xFEFEFEFF),
        surface: Color(0x212121FF),
        onSurface: Color(0xFEFEFEFF),
      )),
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
