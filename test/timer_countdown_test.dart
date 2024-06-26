import 'package:flutter_test/flutter_test.dart';
import 'package:timer_countdown/timer_countdown.dart';
import 'package:timer_countdown/timer_countdown_platform_interface.dart';
import 'package:timer_countdown/timer_countdown_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockTimerCountdownPlatform
    with MockPlatformInterfaceMixin
    implements TimerCountdownPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final TimerCountdownPlatform initialPlatform = TimerCountdownPlatform.instance;

  test('$MethodChannelTimerCountdown is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelTimerCountdown>());
  });

  test('getPlatformVersion', () async {
    TimerCountdown timerCountdownPlugin = TimerCountdown();
    MockTimerCountdownPlatform fakePlatform = MockTimerCountdownPlatform();
    TimerCountdownPlatform.instance = fakePlatform;

    expect(await timerCountdownPlugin.getPlatformVersion(), '42');
  });
}
