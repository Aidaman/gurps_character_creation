import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/characteristics_provider.dart';
import 'package:gurps_character_creation/pages/homepage.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CharacteristicsProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Provider.of<CharacteristicsProvider>(context, listen: false)
        .loadCharacteristics();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GURPS Character Sheet',
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
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color(0xFF2eb398),
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
          (route) => MapEntry(
            route.destination,
            route.pageBuilder,
          ),
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
