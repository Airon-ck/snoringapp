import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:lib_sj/util/loading_util.dart';
import 'package:protocol_lib/protocol_lib.dart';

abstract class BaseState<T extends StatefulWidget> extends State<T>
    with WidgetsBindingObserver {
  bool? initialized = false;

  BuildContext? getContext() {
    return context;
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      initialized = true;
    });
  }

  @override
  void dispose() {
    onDestroy();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    } else {
      debugPrint('error, set state unmounted');
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    debugPrint('didChangeAppLifecycleState');
    switch (state) {
      case AppLifecycleState.resumed: //从后台切换前台，界面可见
        onResume();
        break;
      case AppLifecycleState.inactive: //处于这种状态的应用程序应该假设它们可能在任何时候暂停
        onPause();
        break;
      case AppLifecycleState.paused: //界面不可见，后台
        break;
      case AppLifecycleState.detached: //APP结束时调用
        break;
    }
  }

  void onResume() {
    debugPrint('onResume');
  }

  void onPause() {
    debugPrint('onPause');
  }

  void onDestroy() {
    debugPrint('onDestroy');
  }

  bool isBinded = false;
  bool isConnected = false;
  StreamSubscription? streamSubscriptionBleState;
  StreamSubscription? streamSubscriptionLibStatus;

  connectDevice(IDOBluetoothDeviceModel? device, {bool isShowLoading = false}) {
    if (!isConnected) {
      if (isShowLoading) {
        showLoading(dismissOnTap: false);
      }
      bluetoothManager.connect(device);
    }
  }

  unConnectDevice() {
    if (isConnected) {
      bluetoothManager.cancelConnect().then((res) {
        debugPrint(res ? '取消连接成功' : '取消连接失败，请重试');
        showSuccess(res ? '取消连接成功' : '取消连接失败，请重试');
        if (res) {
          isConnected = false;
          unConnectSuccess();
          updateUi();
        }
      });
    }
  }

  unConnectSuccess() {}

  bindDevice({bool isShowLoading = false}) {
    if (isShowLoading) {
      showLoading(dismissOnTap: false);
    }
    libManager.deviceBind
        .startBind(
            osVersion: 15,
            deviceInfo: (d) {
              debugPrint('设备信息：$d');
            },
            functionTable: (f) {})
        .listen((event) {
      dismissLoading();
      switch (event) {
        case BindStatus.failed:
          debugPrint('绑定失败');
          showError('绑定失败');
          isBinded = false;
          break;
        case BindStatus.successful:
          debugPrint('绑定成功');
          isBinded = true;
          showSuccess('绑定成功');
          bindSuccess();
          break;
        case BindStatus.binded:
          debugPrint('该设备已绑定');
          isBinded = true;
          bindSuccess();
          break;
        case BindStatus.needAuth:
          debugPrint('需要配对码绑定');
          isBinded = false;
          break;
        case BindStatus.refusedBind:
          debugPrint('拒绝绑定');
          isBinded = false;
          break;
        case BindStatus.wrongDevice:
          debugPrint('绑定错误设备');
          isBinded = false;
          break;
        case BindStatus.authCodeCheckFailed:
          debugPrint('授权码校验失败，请重试');
          isBinded = false;
          break;
        case BindStatus.canceled:
          debugPrint('取消绑定操作');
          isBinded = false;
          break;
        case BindStatus.failedOnGetFunctionTable:
          debugPrint('BindStatus.failedOnGetFunctionTable');
          isBinded = false;
          break;
        case BindStatus.failedOnGetDeviceInfo:
          debugPrint('BindStatus.failedOnGetDeviceInfo');
          isBinded = false;
          break;
        default:
          isBinded = false;
          break;
      }
      updateUi();
    });
  }

  bindSuccess() {}

  unBindDevice({bool isShowLoading = false}) {
    if (isShowLoading) {
      showLoading(dismissOnTap: false);
    }
    libManager.deviceBind.unbind(macAddress: libManager.macAddress).then((res) {
      debugPrint(res ? '解绑成功' : '解绑失败，请重试');
      showSuccess(res ? '解绑成功' : '解绑失败，请重试');
      if (res) {
        isBinded = false;
        unBindSuccess();
        updateUi();
      }
    });
  }

  unBindSuccess() {}

  String deviceConnectState =
      IDOBluetoothDeviceStateType.disconnected.toString();

  addDeviceConnectListener() {
    streamSubscriptionBleState =
        bluetoothManager.deviceState().listen((event) async {
      debugPrint('ble deviceState:${event.state.toString()}');
      if ((event.state == IDOBluetoothDeviceStateType.connected &&
          event.macAddress != null &&
          event.macAddress!.isNotEmpty)) {
        final device = bluetoothManager.currentDevice!;
        debugPrint('begin markConnectedDevice--device:${device.toMap()}');
        final otaType = device.isTlwOta
            ? IDOOtaType.telink
            : device.isOta
                ? IDOOtaType.nordic
                : IDOOtaType.none;
        isBinded = await libManager.cache
            .loadBindStatus(macAddress: event.macAddress!);
        var uniqueId = event.macAddress!;

        /// 获取设备uuid(只有ios)
        if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
          uniqueId = bluetoothManager.currentDevice!.uuid!;
        }
        await libManager.markConnectedDeviceSafe(
            uniqueId: uniqueId, otaType: otaType, isBinded: isBinded);
        isConnected = libManager.isConnected;
        dismissLoading();
        debugPrint('end markConnectedDevice');
      } else if (event.state == IDOBluetoothDeviceStateType.disconnected) {
        debugPrint('begin markDisconnectedDevice');
        await libManager.markDisconnectedDevice();
        isConnected = libManager.isConnected;
        dismissLoading();
        debugPrint('end markDisconnectedDevice');
      }

      debugPrint('event.toJson()-----${event.toJson()}');
      deviceConnectState = event.state.toString();
      debugPrint(
          'deviceConnectState----$deviceConnectState----isBinded:$isBinded----isConnected:$isConnected');
      updateUi();

      if (event.state == IDOBluetoothDeviceStateType.connected) {
        Future.delayed(const Duration(milliseconds: 1500), () {
          bindDevice(isShowLoading: true);
        });
      }
    });
  }

  removeDeviceConnectListener() {
    streamSubscriptionBleState?.cancel();
  }

  addStatusNotificationListener() {
    streamSubscriptionLibStatus =
        libManager.listenStatusNotification((status) async {
      debugPrint('listenStatusNotification-----${status.name}');
      if (status == IDOStatusNotification.fastSyncCompleted) {
        fastSyncCompleted();
      }
    });
  }

  removeStatusNotificationListener() {
    streamSubscriptionLibStatus?.cancel();
  }

  fastSyncCompleted() {}

  updateUi() {}

  exportLog() async {
    final zipFilePath = await libManager.cache.exportLog();
    debugPrint('exportLog-----zipFilePath:$zipFilePath');
    final bleLogFile = await bluetoothManager.logPath();
    debugPrint('exportLog-----bleLogFile:$bleLogFile');
  }
}
