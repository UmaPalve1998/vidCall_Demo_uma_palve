import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

bool isValidEmail(String email) {
  final regex = RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
  );
  return regex.hasMatch(email);
}

class PipHelper {
  static const _channel = MethodChannel("com.example.video/pip");

  static Future<void> enterPip() async {
    try {
      await _channel.invokeMethod("enterPip");
    } catch (e) {
      print("Error entering PIP: $e");
    }
  }

  static void setPipListener(Function(bool) onChanged) {
    _channel.setMethodCallHandler((call) async {
      if (call.method == "pipChanged") {
        onChanged(call.arguments as bool);
      }
    });
  }
}