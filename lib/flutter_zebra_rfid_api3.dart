import 'package:flutter/services.dart';

import 'flutter_zebra_rfid_api3_platform_interface.dart';

class FlutterZebraRfidApi3 {
  // 获取安卓版本
  Future<String?> getPlatformVersion() {
    return FlutterZebraRfidApi3Platform.instance.getPlatformVersion();
  }

  // 用于通知回调的方法
  late Function operation;

  // 用于通知回调错误方法
  late Function errorOperation;

  FlutterZebraRfidApi3(this.operation, this.errorOperation) {
    const EventChannel('flutter_zebra_rfid_api3_event').receiveBroadcastStream().listen(eventListener, onError: errorListener);
  }

  void eventListener(dynamic event) {
    operation(Map<String, dynamic>.from(event));
  }

  void errorListener(Object error) {
    errorOperation(error);
  }

  // 连接读卡器
  Future<String?> connect() {
    return FlutterZebraRfidApi3Platform.instance.connect();
  }

  // 断开连接
  Future<String?> disconnect() {
    return FlutterZebraRfidApi3Platform.instance.disconnect();
  }

  // 读RFID
  Future<String?> read() {
    return FlutterZebraRfidApi3Platform.instance.read();
  }

  // 停止读取
  Future<String?> stop() {
    return FlutterZebraRfidApi3Platform.instance.stop();
  }

  // 检测是否连接
  Future<String?> isConnected() {
    return FlutterZebraRfidApi3Platform.instance.isConnected();
  }
}
