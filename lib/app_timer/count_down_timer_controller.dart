import 'dart:async';

import 'package:timer_countdown/app_timer/timer_handle.dart';

class CountDownController {
  int _countdownSeconds;
  late Timer _timer;
  final Function(int)? _onTick;
  final Function()? _onFinished;
  final timerHandler = TimerDifferenceHandler.instance;
  bool onPausedCalled = false;

  CountDownController({
    required int seconds,
    Function(int)? onTick,
    Function()? onFinished,
    bool? autoStart,
  })  : _countdownSeconds = seconds,
        _onTick = onTick,
        _onFinished = onFinished;

  void start() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _countdownSeconds--;
      if (_onTick != null) {
        _onTick(_countdownSeconds);
      }

      if (_countdownSeconds <= 0) {
        stop();
        if (_onFinished != null) {
          _onFinished();
        }
      }
    });
  }

  void pause(int endTime) {
    onPausedCalled = true;
    stop();
    timerHandler.setEndingTime(endTime); //setting end time
  }

  void resume() {
    if (!onPausedCalled) {
      return;
    }
    if (timerHandler.remainingSeconds > 0) {
      _countdownSeconds = timerHandler.remainingSeconds;
      start();
    } else {
      stop();
      _onTick!(_countdownSeconds); //callback
    }
    onPausedCalled = false;
  }

  void stop() {
    _timer.cancel();
    _countdownSeconds = 0;
  }
}
