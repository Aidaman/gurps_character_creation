import 'package:flutter/material.dart';
import 'package:gurps_character_creation/providers/aspects_provider.dart';
import 'package:gurps_character_creation/pages/homepage.dart';
import 'package:gurps_character_creation/utilities/app_routes.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AspectsProvider()),
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

    Provider.of<AspectsProvider>(context, listen: false).loadCharacteristics();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GURPS Character Sheet',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF1565C0),
          onPrimary: Color(0xFFeeeeee),
          secondary: Color(0x3E9A9996),
          onSecondary: Color(0xFF363636),
          error: Color(0xFFD81B60),
          onError: Color(0xFFeeeeee),
          surface: Color(0xFFeeeeee),
          onSurface: Color(0xFF363636),
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
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
        ),
        useMaterial3: true,
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
