import 'package:flutter/material.dart';
import 'package:gurps_character_creation/features/initialization/models/load_queue_entry.dart';
import 'package:gurps_character_creation/features/initialization/services/initialization_service.dart';
import 'package:gurps_character_creation/features/initialization/view/error_screen.dart';
import 'package:gurps_character_creation/features/initialization/view/loading_screen.dart';

class AppInitializer extends StatefulWidget {
  final Widget app;
  const AppInitializer({super.key, required this.app});

  @override
  State<AppInitializer> createState() => _AppInitializerState();
}

class _AppInitializerState extends State<AppInitializer> {
  Future<void>? _loadingFuture;
  bool _ignoreLoadingErrors = false;
  String _loadingMessage = '';

  Future<dynamic> _processLoadQueue(LoadQueueEntry entry) async {
    setState(() => _loadingMessage = entry.message);
    await entry.task();
  }

  @override
  void initState() {
    super.initState();
    if (_loadingFuture == null) {
      final service = InitializationService(context);
      _loadingFuture = service.init(_processLoadQueue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadingFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return LoadingScreen(loadingMessage: _loadingMessage);
        }

        if (snapshot.hasError && !_ignoreLoadingErrors) {
          return ErrorScreen(
            onIgnoreErrorsClick: () => setState(() {
              _ignoreLoadingErrors = true;
            }),
            onReportBugClick: () {},
          );
        }

        return widget.app;
      },
    );
  }
}
