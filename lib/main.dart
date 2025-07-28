import 'package:flutter/material.dart';
import 'package:gurps_character_creation/core/constants/app_routes.dart';
import 'package:gurps_character_creation/core/constants/themes.dart';
import 'package:gurps_character_creation/core/services/notification_service.dart';
import 'package:gurps_character_creation/features/aspects/providers/aspects_provider.dart';
import 'package:gurps_character_creation/features/equipment/providers/equipment_provider.dart';
import 'package:gurps_character_creation/features/initialization/widgets/app_initializer.dart';
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
      child: const AppInitializer(app: MyApp()),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GURPS Composer',
      scaffoldMessengerKey: notificator.messengerKey,
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
