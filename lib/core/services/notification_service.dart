import 'package:flutter/material.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  factory NotificationService() => _instance;

  NotificationService._internal();

  final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  void showMessageWithSnackBar(String message) {
    final ScaffoldMessengerState? messenger = messengerKey.currentState;

    if (messenger != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
    }
  }

  void showSnackBar(Widget child) {
    final ScaffoldMessengerState? messenger = messengerKey.currentState;

    if (messenger != null) {
      messenger.showSnackBar(SnackBar(content: child));
    }
  }
}

final notificator = NotificationService();
