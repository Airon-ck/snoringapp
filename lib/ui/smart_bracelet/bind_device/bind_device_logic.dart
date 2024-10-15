import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:get/get.dart';
import 'package:lib_sj/getx/base/base_view_state_request_model.dart';
import 'package:snoring_app/common/user_comm.dart';
import 'package:snoring_app/ui/smart_bracelet/bound_device/bound_device_view.dart';

class BindDeviceLogic extends ViewStateRequestModel {
  late String controllerTag;

  @override
  void onDataInit() {}

  bool isForward = true;
  bool isScanning = true;
  List<IDOBluetoothDeviceModel> devices = [];

  startScanDevice() {
    isScanning = true;
    animationController.forward();
    Future.delayed(const Duration(milliseconds: 600), () {
      bluetoothManager.startScan();
    });
  }

  addScanResultListener() {
    // 扫描设备
    bluetoothManager.scanResult().listen((event) {
      isScanning = false;
      devices = event;
      animationController.animateTo(1.0);
      animationController.stop();
      debugPrint(
          'addScanResultListener----state:${devices[0].state.toString()},rssi:${devices[0].rssi.toString()}');
      update(['${controllerTag}_detail']);
    });
  }

  goToBoundDevice({bool isConnected = false, bool isBinded = false}) {
    final device = bluetoothManager.currentDevice!;
    debugPrint('goToBoundDevice--device:${device.toMap()}');
    UserComm.saveBoundDevice(device.toMap());
    Get.off(BoundDevicePage(
      key: const Key('BoundDevicePage'),
      isConnected: isConnected,
      isBinded: isBinded,
    ));
  }

  late AnimationController animationController;
}
