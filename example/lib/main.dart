import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_zebra_rfid_api3/flutter_zebra_rfid_api3.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Set<String> rfidSet = <String>{};
  late FlutterZebraRfidApi3 _flutterZebraRfidApi3;
  String isConnected = "false";

  @override
  void initState() {
    super.initState();
    initZebraRfid();
  }

  Future<void> initZebraRfid() async {
    _flutterZebraRfidApi3 = FlutterZebraRfidApi3((Map<String, dynamic> map) {
      map.forEach((key, value) {
        if (key == "RFID") {
          print("接收到RFID:$value");
          setState(() {
            rfidSet.add(value);
          });
        } else if (key == "HANDHELD_TRIGGER") {
          print("手柄按钮$value");
        }
      });
    }, (Object error) {
      print("错误信息$error");
    });
    await _flutterZebraRfidApi3.connect();
    isConnected = await _flutterZebraRfidApi3.isConnected() ?? "false";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print(1);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Column(
            children: [
              Text("读卡器连接状态$isConnected"),
              ElevatedButton(
                onPressed: () async {
                  await _flutterZebraRfidApi3.disconnect();
                  isConnected = await _flutterZebraRfidApi3.isConnected() ?? "false";
                  setState(() {
                    print(isConnected);
                  });
                },
                child: Text("断开"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _flutterZebraRfidApi3.read();
                },
                child: Text("读取"),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _flutterZebraRfidApi3.stop();
                },
                child: Text("停止"),
              ),
              ElevatedButton(
                onPressed: () async {
                  rfidSet.clear();
                  setState(() {});
                },
                child: Text("清空"),
              ),
              Text(rfidSet.toString()),
            ],
          ),
        ),
      ),
    );
  }
}
