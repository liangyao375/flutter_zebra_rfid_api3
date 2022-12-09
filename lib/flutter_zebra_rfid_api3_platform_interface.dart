import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_zebra_rfid_api3_method_channel.dart';

abstract class FlutterZebraRfidApi3Platform extends PlatformInterface {
  /// Constructs a FlutterZebraRfidApi3Platform.
  FlutterZebraRfidApi3Platform() : super(token: _token);

  static final Object _token = Object();

  static FlutterZebraRfidApi3Platform _instance = MethodChannelFlutterZebraRfidApi3();

  /// The default instance of [FlutterZebraRfidApi3Platform] to use.
  ///
  /// Defaults to [MethodChannelFlutterZebraRfidApi3].
  static FlutterZebraRfidApi3Platform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterZebraRfidApi3Platform] when
  /// they register themselves.
  static set instance(FlutterZebraRfidApi3Platform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> connect() {
    throw UnimplementedError('connect() has not been implemented.');
  }

  Future<String?> disconnect() {
    throw UnimplementedError('disconnect() has not been implemented.');
  }

  Future<String?> read() {
    throw UnimplementedError('read() has not been implemented.');
  }

  Future<String?> stop() {
    throw UnimplementedError('stop() has not been implemented.');
  }

  Future<String?> isConnected() {
    throw UnimplementedError('isConnected() has not been implemented.');
  }
}
