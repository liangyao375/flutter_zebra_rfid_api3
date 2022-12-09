import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_zebra_rfid_api3_platform_interface.dart';

/// An implementation of [FlutterZebraRfidApi3Platform] that uses method channels.
class MethodChannelFlutterZebraRfidApi3 extends FlutterZebraRfidApi3Platform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_zebra_rfid_api3');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> connect() async {
    return await methodChannel.invokeMethod<String>('connect');
  }

  @override
  Future<String?> disconnect() async {
    return await methodChannel.invokeMethod<String>('disconnect');
  }

  @override
  Future<String?> read() {
    return methodChannel.invokeMethod<String>('read');
  }

  @override
  Future<String?> stop() {
    return methodChannel.invokeMethod<String>('stop');
  }

  @override
  Future<String?> isConnected() {
    return methodChannel.invokeMethod<String>('isConnected');
  }

}
