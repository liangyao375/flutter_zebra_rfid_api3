package com.acbee.flutter_zebra_rfid_api3;

import android.content.Context;
import android.os.Handler;
import android.os.Looper;
import androidx.annotation.NonNull;
import com.zebra.rfid.api3.*;
import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.EventChannel.EventSink;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;

import java.util.ArrayList;
import java.util.HashMap;

/**
 * FlutterZebraRfidApi3Plugin
 */
public class FlutterZebraRfidApi3Plugin implements FlutterPlugin, MethodCallHandler {
    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private MethodChannel channel;
    private Context context;
    private RFIDReader reader;

    private EventChannel.EventSink eventSink = null;
    private EventChannel.StreamHandler streamHandler = new EventChannel.StreamHandler() {
        @Override
        public void onListen(Object o, EventChannel.EventSink sink) {
            eventSink = sink;
        }

        @Override
        public void onCancel(Object o) {
            eventSink = null;
        }
    };

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        channel = new MethodChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zebra_rfid_api3");
        channel.setMethodCallHandler(this);
        // 上下文
        context = flutterPluginBinding.getApplicationContext();
        // 初始化事件
        EventChannel eventChannel = new EventChannel(flutterPluginBinding.getBinaryMessenger(), "flutter_zebra_rfid_api3_event");
        eventChannel.setStreamHandler(streamHandler);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull Result result) {
        if (call.method.equals("getPlatformVersion")) {
            result.success("Android " + android.os.Build.VERSION.RELEASE);
        } else if (call.method.equals("connect")) {
            if (reader == null || !reader.isConnected()) {
                try {
                    Readers readers = new Readers(context, ENUM_TRANSPORT.SERVICE_SERIAL);
                    // 获取读卡器
                    ArrayList<ReaderDevice> availableRFIDReaderList = readers.GetAvailableRFIDReaderList();
                    // 有读卡器进行下面操作
                    if (availableRFIDReaderList.size() > 0) {
                        // 取第一个读卡器
                        ReaderDevice readerDevice = availableRFIDReaderList.get(0);
                        reader = readerDevice.getRFIDReader();
                        // 连接读卡器
                        reader.connect();
                        EventHandler eventHandler = new EventHandler();
                        reader.Events.addEventsListener(eventHandler);
                        // 订阅所需状态通知
                        reader.Events.setInventoryStartEvent(true);
                        reader.Events.setInventoryStopEvent(true);
                        // 读取手柄按钮
                        reader.Events.setHandheldEvent(true);
                        // 启用标记读取通知。如果设置为false，则不发送标记读取通知
                        reader.Events.setTagReadEvent(true);
                        reader.Events.setReaderDisconnectEvent(true);
                        reader.Events.setBatteryEvent(true);
                        // 返回信息
                        result.success("true");
                    } else {
                        // 没有读卡器返回错误
                        result.success("读卡器数量为0");
                    }
                } catch (java.lang.Exception e) {
                    e.printStackTrace();
                    result.success("false");
                }
            }
        } else if (call.method.equals("disconnect")) {
            if (reader != null && reader.isConnected()) {
                try {
                    reader.disconnect();
                    result.success("true");
                } catch (java.lang.Exception e) {
                    e.printStackTrace();
                    result.success("false");
                }
            } else {
                result.success("false");
            }
        } else if (call.method.equals("read")) {
            rfidRead();
        } else if (call.method.equals("stop")) {
            rfidStop();
        } else if (call.method.equals("isConnected")) {
            Boolean isConnected = (reader != null && reader.isConnected());
            result.success(isConnected.toString());
        } else {
            result.notImplemented();
        }
    }

    // rfid读取
    private void rfidRead() {
        try {
            if (reader.isConnected()) {
                reader.Actions.Inventory.perform();
            }
        } catch (java.lang.Exception e) {
            e.printStackTrace();
        }
    }

    // rfid停止
    private void rfidStop() {
        try {
            if (reader.isConnected()) {
                reader.Actions.Inventory.stop();
            }
        } catch (java.lang.Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        channel.setMethodCallHandler(null);
    }

    // RFID读取/状态通知处理程序
    // 实现RfidEventsLister类以接收事件通知
    public class EventHandler implements RfidEventsListener {
        // 读取事件通知
        public void eventReadNotify(RfidReadEvents e) {
            // Recommended to use new method getReadTagsEx for better performance in case of large tag population
            TagData[] myTags = reader.Actions.getReadTags(100);
            if (myTags != null) {
                for (TagData myTag : myTags) {
                    String tagId = myTag.getTagID();
                    HashMap m = new HashMap();
                    m.put("RFID", tagId);
                    try {
                        // 获取主线程，通信只能在主线程中执行，并通知flutter
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                eventSink.success(m);
                            }
                        });
                    } catch (java.lang.Exception exception) {
                        exception.printStackTrace();
                    }
                }
            }
        }

        // 状态事件通知
        public void eventStatusNotify(RfidStatusEvents rfidStatusEvents) {
            System.out.println("状态通知: " + rfidStatusEvents.StatusEventData.getStatusEventType());
            if (rfidStatusEvents.StatusEventData.getStatusEventType() == STATUS_EVENT_TYPE.HANDHELD_TRIGGER_EVENT) {
                // 手柄按钮按下
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData.getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_PRESSED) {
                    // 读取rfid开启
                    rfidRead();
                    // 通知flutter手柄按钮开启
                    HashMap m = new HashMap();
                    m.put("HANDHELD_TRIGGER", true);
                    try {
                        // 获取主线程，通信只能在主线程中执行，并通知flutter
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                eventSink.success(m);
                            }
                        });
                    } catch (java.lang.Exception exception) {
                        exception.printStackTrace();
                    }
                }
                // 手柄按钮抬起
                if (rfidStatusEvents.StatusEventData.HandheldTriggerEventData.getHandheldEvent() == HANDHELD_TRIGGER_EVENT_TYPE.HANDHELD_TRIGGER_RELEASED) {
                    // 读取rfid结束
                    rfidStop();
                    // 通知flutter手柄按钮关闭
                    HashMap m = new HashMap();
                    m.put("HANDHELD_TRIGGER", false);
                    try {
                        // 获取主线程，通信只能在主线程中执行，并通知flutter
                        new Handler(Looper.getMainLooper()).post(new Runnable() {
                            @Override
                            public void run() {
                                eventSink.success(m);
                            }
                        });
                    } catch (java.lang.Exception exception) {
                        exception.printStackTrace();
                    }
                }
            }
        }
    }

}
