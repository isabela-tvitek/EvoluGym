import 'package:flutter/services.dart';

class TimerChannel {
  static const MethodChannel _channel = MethodChannel('com.evolugym/timer');

  static Future<int> startTimer() async {
    final int result = await _channel.invokeMethod('startTimer');
    return result;
  }

  static Future<int> stopTimer() async {
    final int result = await _channel.invokeMethod('stopTimer');
    return result;
  }
}
