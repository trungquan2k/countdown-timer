## I need help to update this package because I'm not playing with dart anymore

## Countdown - yet another countdown !!

Countdown is countdown with pause/resume controls.


### Simple use


### Use with controls
```
import 'package:countdown_timer/countdown_timer.dart';
  AppCountdown(
    autoStart: true,
    onResend: () {
      return Future.delayed(Duration.zero);
    },
    colorTimerStart: Colors.black,
    colorTimerEnd: Colors.white,
    controller: cdPhoneController,
    textResend: Text('resend'),
  )
