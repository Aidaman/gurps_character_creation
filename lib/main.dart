import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/themes.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/equipment/providers/equipment_provider.dart';
import 'package:gurps_character_creation/features/settings/services/settings_provider.dart';
import 'package:gurps_character_creation/features/character/providers/character_provider.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  Queue<Future<void> Function()> loadQueue = Queue.from([]);

  @override
  void initState() {
    super.initState();

    loadQueue.addAll(
      [
        context.read<SettingsProvider>().loadSettings,
        context.read<AspectsProvider>().loadCharacteristics,
        context.read<EquipmentProvider>().loadEquipment,
      ],
    );

    while (loadQueue.isNotEmpty) {
      _runNextLoadTask();
    }

    FlutterNativeSplash.remove();
  }

  Future _runNextLoadTask() async {
    final task = loadQueue.removeFirst();

    await task();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GURPS Composer',
      theme: defaultTheme(context),
      darkTheme: darkTheme(context),
      themeMode: context.watch<SettingsProvider>().settings.theme,
      routes: Map.fromEntries(
        AppRoutes.values.map(
          (AppRoutes route) => MapEntry(
            route.destination,
            route.pageBuilder,
          ),
        ),
      ),
      initialRoute: AppRoutes.HOMEPAGE.destination,
    );
  }
}
