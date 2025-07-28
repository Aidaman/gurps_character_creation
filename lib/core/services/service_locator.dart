import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ServiceLocator {
  static final ServiceLocator _instance = ServiceLocator._internal();

  factory ServiceLocator() => _instance;

  ServiceLocator._internal();

  BuildContext? _context;

  set context(BuildContext context) {
    _context = context;
  }

  T get<T>() {
    if (_context == null) {
      throw Exception(
          'Service locator context is not set. Set the context of your app');
    }

    return _context!.read<T>();
  }
}

final serviceLocator = ServiceLocator();
