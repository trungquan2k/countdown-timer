import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timer_countdown/app_timer/count_down_timer_controller.dart';
import 'package:timer_countdown/utils/base_state.dart';

class AppCountdownController {
  VoidCallback? _restart;
  VoidCallback? _stop;

  void restart() {
    if (_restart != null) {
      _restart!();
    }
  }

  void stop() {
    if (_stop != null) {
      _stop!();
    }
  }
}

class AppCountdown extends StatefulWidget {
  final bool autoStart;
  final int seconds;
  final Color? colorTimeDown;
  final Future<bool> Function()? onResend;
  final AppCountdownController? controller;
  final Brightness? theme;
  final Color? colorTitle;
  final Color? colorTimerStart;
  final Color? colorTimerEnd;
  final Widget? textResend;
  final Duration animationDuration;
  final TextStyle? timerStyle;

  const AppCountdown({
    super.key,
    this.autoStart = true,
    this.seconds = 180,
    this.colorTimeDown,
    this.onResend,
    this.controller,
    this.colorTimerStart,
    this.colorTimerEnd,
    this.theme = Brightness.dark,
    this.colorTitle,
    this.textResend,
    this.animationDuration = Durations.medium3,
    this.timerStyle,
  });

  @override
  State<AppCountdown> createState() => _AppCountdownState();
}

class _AppCountdownState extends BaseState<AppCountdown>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation animation;
  late Color color = Colors.transparent;
  void _animationListener() {
    setState(() {
      color = animation.value;
    });
  }

  int countdownSeconds = 0;
  late CountDownController countdownTimerController;
  bool _isTimerRunning = false;

  void initTimerOperation() {
    countdownSeconds = widget.seconds;
    countdownTimerController = CountDownController(
      seconds: countdownSeconds,
      onTick: (seconds) {
        _isTimerRunning = true;
        countdownSeconds = seconds;
        if (seconds == 0) {
          _isTimerRunning = false;
        }
        setState(() {});
      },
      onFinished: () {
        _isTimerRunning = false;
        countdownTimerController.stop();
        setState(() {});
      },
    );

    SystemChannels.lifecycle.setMessageHandler((msg) {
      if (msg == AppLifecycleState.paused.toString()) {
        if (_isTimerRunning) {
          countdownTimerController.pause(countdownSeconds);
        }
      }
      if (msg == AppLifecycleState.resumed.toString()) {
        if (_isTimerRunning) {
          countdownTimerController.resume();
        }
      }
      return Future(() => null);
    });

    _isTimerRunning = true;
    if (widget.autoStart) {}
    countdownTimerController.start();
  }

  void stopTimer() {
    _isTimerRunning = false;
    countdownTimerController.stop();
  }

  void resetTimer() {
    stopTimer();
    controller.reset();
    initTimerOperation();
  }

  bool get isRunning => _isTimerRunning;
  bool get isCompleted => !_isTimerRunning;
  @override
  initState() {
    super.initState();
    initTimerOperation();
    controller = AnimationController(
        duration: Duration(seconds: widget.seconds), vsync: this);

    animation =
        ColorTween(begin: widget.colorTimerStart, end: widget.colorTimerEnd)
            .animate(controller);
    animation.addListener(_animationListener);
    controller.forward();
    widget.controller?._restart = resetTimer;
    widget.controller?._stop = stopTimer;
  }

  @override
  void dispose() {
    countdownTimerController.stop();
    controller.dispose();
    animation.removeListener(_animationListener);
    super.dispose();
  }

  resend() async {
    if (await widget.onResend!()) {
      resetTimer();
      setState(() {});
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isResendAble =
        isCompleted && widget.onResend is Future<bool> Function();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: isResendAble ? () async => resend() : null,
          borderRadius: const BorderRadius.all(Radius.circular(4)),
          child: widget.textResend,
        ),
        AnimatedSwitcher(
          duration: widget.animationDuration,
          child: isRunning
              ? Text(
                  countdownSeconds == 0
                      ? ''
                      : '(${Duration(seconds: countdownSeconds.toInt()).toString().substring(2, 7)})',
                  style: widget.timerStyle ??
                      TextStyle(
                        color: widget.colorTimeDown ??
                            Colors.white.withOpacity(0.5),
                      ),
                )
              : null,
        )
      ],
    );
  }
}
