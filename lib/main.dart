import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/themes/widgets/switch.dart';
import 'package:gurps_character_creation/core/themes/widgets/text_input.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/equipment/providers/equipment_provider.dart';
import 'package:gurps_character_creation/features/settings/services/settings_provider.dart';
import 'package:gurps_character_creation/pages/homepage.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AspectsProvider()),
        ChangeNotifierProvider(create: (_) => EquipmentProvider()),
        ChangeNotifierProvider(create: (_) => CharacterProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
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
  initState() {
    super.initState();

    context.read<AspectsProvider>().loadCharacteristics();
    context.read<EquipmentProvider>().loadEquipment();
    context.read<SettingsProvider>().loadSettings();
  }

  @override
  Widget build(BuildContext context) {
    final SettingsProvider settingsProvider =
        Provider.of<SettingsProvider>(context);

    return MaterialApp(
      title: 'GURPS Composer',
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
          shadow: Color(0x64222222),
        ),
        useMaterial3: true,
        switchTheme: getSwitchThemeData(context),
        inputDecorationTheme: getInputDecorationTheme(context),
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
          shadow: Color(0x64222222),
        ),
        useMaterial3: true,
        switchTheme: getSwitchThemeData(context),
        inputDecorationTheme: getInputDecorationTheme(context),
      ),
      themeMode: settingsProvider.settings.theme,
      routes: Map.fromEntries(
        AppRoutes.values.map(
          (AppRoutes route) => MapEntry(
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
