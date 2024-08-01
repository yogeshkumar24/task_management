import 'package:flutter/foundation.dart';

class Log {
  static void i(dynamic value) {
    if (kDebugMode) {
      print('Task Manager info logs: $value');
    }
  }

  static void e(dynamic value) {
    if (kDebugMode) {
      print('Task Manager error logs: $value');
    }
  }

  static void d(dynamic value) {
    if (kDebugMode) {
      print('Task Manager debug logs: $value');
    }
  }
}
