import 'package:flutter/material.dart';
import 'dart:async';

import 'package:timer_countdown/app_countdown_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final AppCountdownController cdPhoneController = AppCountdownController();
  @override
  void initState() {
    super.initState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Expanded(
            child: AppCountdown(
                autoStart: true,
                onResend: () {
                  return Future.delayed(Duration.zero);
                },
                colorTimerStart: Colors.black,
                colorTimerEnd: Colors.white,
                controller: cdPhoneController,
                textResend: Text('resend')),
          ),
        ),
      ),
    );
  }
}
