import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_zebra_rfid_api3/flutter_zebra_rfid_api3.dart';
import 'package:flutter_zebra_rfid_api3/flutter_zebra_rfid_api3_platform_interface.dart';
import 'package:flutter_zebra_rfid_api3/flutter_zebra_rfid_api3_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterZebraRfidApi3Platform 
    with MockPlatformInterfaceMixin
    implements FlutterZebraRfidApi3Platform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterZebraRfidApi3Platform initialPlatform = FlutterZebraRfidApi3Platform.instance;

  test('$MethodChannelFlutterZebraRfidApi3 is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterZebraRfidApi3>());
  });

  test('getPlatformVersion', () async {
    FlutterZebraRfidApi3 flutterZebraRfidApi3Plugin = FlutterZebraRfidApi3();
    MockFlutterZebraRfidApi3Platform fakePlatform = MockFlutterZebraRfidApi3Platform();
    FlutterZebraRfidApi3Platform.instance = fakePlatform;
  
    expect(await flutterZebraRfidApi3Plugin.getPlatformVersion(), '42');
  });
}
