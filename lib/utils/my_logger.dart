import 'package:flutter/cupertino.dart';

class MyLogger {
  MyLogger();

  static void e(dynamic msg) {
    // ignore: avoid_print
    print('MyLogger: $msg');
  }

  static void d(dynamic msg) {
    debugPrint('MyLogger: $msg');
  }
}
