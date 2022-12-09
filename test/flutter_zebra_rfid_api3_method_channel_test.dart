import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zebra_rfid_api3/flutter_zebra_rfid_api3_method_channel.dart';

void main() {
  MethodChannelFlutterZebraRfidApi3 platform = MethodChannelFlutterZebraRfidApi3();
  const MethodChannel channel = MethodChannel('flutter_zebra_rfid_api3');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
