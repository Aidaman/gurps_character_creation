import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/themes.dart';
import 'package:gurps_character_creation/core/services/app_directory_service.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/equipment/providers/equipment_provider.dart';
import 'package:gurps_character_creation/features/settings/services/settings_provider.dart';
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
  late Future<void> _loadingFuture;
  String _loadingMessage = '';

  Future<void> _loadQueue() async {
    setState(() => _loadingMessage = 'Loading settings...');
    await context.read<SettingsProvider>().loadSettings();

    setState(() => _loadingMessage = 'Loading aspects...');
    await context.read<AspectsProvider>().loadCharacteristics();

    setState(() => _loadingMessage = 'Loading equipment...');
    await context.read<EquipmentProvider>().loadEquipment();

    setState(() => _loadingMessage = 'Ensuring Application Directories');
    await AppDirectoryService().ensureDirectories();

    setState(() => _loadingMessage = 'Finishing up...');
  }

  @override
  void initState() {
    super.initState();
    _loadingFuture = _loadQueue();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: _loadingFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Directionality(
              textDirection: TextDirection.ltr,
              child: Material(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      const Gap(24),
                      Text(
                        _loadingMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

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
        });
  }
}
