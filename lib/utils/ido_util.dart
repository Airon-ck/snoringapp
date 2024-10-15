import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/loading_util.dart';

// import 'package:protocol_alexa/protocol_alexa.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:snoring_app/common/user_logic.dart';

class IdoUtil {
  static const clientId =
      'amzn1.application-oa2-client.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx';

  static Future<void> initIdo() async {
    await registerProtocolSDK();
    await registerBluetoothSDK();
    // await registerProtocolAlexa();
    await bridgeConnect();
  }

  /// 注册协议库
  static Future<void> registerProtocolSDK() async {
    // 注册协议库
    await IDOProtocolLibManager.register(
        outputToConsole: true, outputToConsoleClib: true, isReleaseClib: false);
    // ios注册监听更新消息图标
    libManager.messageIcon.registerListenUpdate();
    // 监听设备状态
    libManager.listenDeviceNotification((event) {
      debugPrint('listenDeviceNotification: ${event.toMap().toString()}');
    });
  }

  ///注册蓝牙库
  static Future<void> registerBluetoothSDK() async {
    await bluetoothManager.register();

    /// 获取版本号
    final version = bluetoothManager.getSdkVersion();

    /// deviceName: 只搜索deviceName的设备
    /// deviceID：只搜索deviceID的设备
    /// uuids: 只搜索 uuid设备
    //bluetoothManager.scanFilter();
  }

  // static Future<void> registerProtocolAlexa() async {
  //   await IDOProtocolAlexa.register(clientId: clientId);
  //
  //   Connectivity().onConnectivityChanged.listen((event) {
  //     debugPrint('onConnectivityChanged: ${event.name}');
  //     IDOProtocolAlexa.onNetworkChanged(
  //         hasNetwork: event != ConnectivityResult.none);
  //   });
  // }

  /// 蓝牙与协议库桥接
  static Future<void> bridgeConnect() async {
    // 处理蓝牙返回数据
    bluetoothManager.receiveData().listen((event) {
      if (event.data != null) {
        libManager.receiveDataFromBle(
            event.data!, event.macAddress, event.spp ?? false ? 1 : 0);
      }
    });

    // 监听协议库状态改变
    libManager.listenStatusNotification((status) async {
      if (status == IDOStatusNotification.protocolConnectCompleted) {
        // 协议库设备连接完成初始化
      } else if (status == IDOStatusNotification.fastSyncCompleted) {
        // 快速配置完成
      } else if (status == IDOStatusNotification.deviceInfoUpdateCompleted) {
        // 设备信息更新完成
      } else if (status == IDOStatusNotification.unbindOnBindStateError) {
        // 绑定状态错误，解绑删除当前设备
      } else if (status == IDOStatusNotification.fastSyncFailed) {
        // 快速配置失败，功能表获取失败
      }
    });

    // 写数据到蓝牙设备
    IDOBluetoothWriteType rs = IDOBluetoothWriteType.withoutResponse;
    libManager.registerWriteDataToBle((event) async {
      rs = await bluetoothManager.writeData(event.data, type: event.type);
      if (rs == IDOBluetoothWriteType.withoutResponse && Platform.isIOS) {
        // 无响应发送数据
        libManager.writeDataComplete();
      }
    });

    // 蓝牙写入状态回调
    bluetoothManager.writeState().listen((event) {
      if (event.state ?? false) {
        if (Platform.isAndroid ||
            event.type == IDOBluetoothWriteType.withResponse) {
          // 写入完成
          libManager.writeDataComplete();
        }
      }
    });

    //监听连接状态
    bluetoothManager.deviceState().listen((value) async {
      if (value.errorState == IDOBluetoothDeviceConnectErrorType.pairFail) {
        //  配对异常提示去忽略设备
      }
      if ((value.state == IDOBluetoothDeviceStateType.connected &&
          (value.macAddress != null && value.macAddress!.isNotEmpty))) {
        // 设备连接成功
        // 获取ota枚举类型
        final isTlwOta = bluetoothManager.currentDevice?.isTlwOta ?? false;
        final isOta = bluetoothManager.currentDevice?.isOta ?? false;
        final otaType = isTlwOta
            ? IDOOtaType.telink
            : isOta
                ? IDOOtaType.nordic
                : IDOOtaType.none;

        // 获取设备名字
        final devicenName = bluetoothManager.currentDevice?.name;
        var uniqueId = value.macAddress!;

        // 获取设备uuid(只有ios)
        if (Platform.isIOS && bluetoothManager.currentDevice?.uuid != null) {
          uniqueId = bluetoothManager.currentDevice!.uuid!;
        }

        // 执行协议库连接设备
        await libManager.markConnectedDeviceSafe(
            uniqueId: uniqueId,
            otaType: otaType,
            isBinded: false, // 该状态由使用者记录
            deviceName: devicenName);
      } else if (value.state == IDOBluetoothDeviceStateType.disconnected) {
        // 设备断线
        await libManager.markDisconnectedDevice(
            macAddress: value.macAddress, uuid: value.uuid);
      }
    });

    /// 监听蓝牙状态
    bluetoothManager.bluetoothState().listen((event) async {
      // 获取设备mac地址
      final macAddress = bluetoothManager.currentDevice?.macAddress;

      // 获取设备uuid(只有ios)
      final uuid = bluetoothManager.currentDevice?.uuid;
      if (event.state == IDOBluetoothStateType.poweredOff) {
        /// 蓝牙关闭
        await libManager.markDisconnectedDevice(
            macAddress: macAddress, uuid: uuid);
      }
    });
  }

  static Future<void> requestBLEPermission(
      {ReqCallBackListener? reqCallBackListener}) async {
    if (Platform.isAndroid) {
      if (!await checkLocationPermissionIfNeeded()) {
        return;
      }
      IDOBluetoothStateType bleState =
          await bluetoothManager.getBluetoothState();
      if (bleState != IDOBluetoothStateType.poweredOn) {
        showError('需要打开蓝牙');
        return;
      }
      PermissionStatus bluetoothStatus =
          await Permission.bluetoothScan.request();
      PermissionStatus connectStatus =
          await Permission.bluetoothConnect.request();
      debugPrint("connectStatus: $connectStatus");
      debugPrint("bluetoothStatus: $bluetoothStatus");
      if (bluetoothStatus.isDenied) {
        // bluetoothManager.stopScan();
        showError('没有蓝牙权限');
        if (reqCallBackListener != null) {
          reqCallBackListener.reqCallBack!(false, null);
        }
      } else {
        // bluetoothManager.startScan();
        if (reqCallBackListener != null) {
          reqCallBackListener.reqCallBack!(true, null);
        }
      }
    } else {
      // bluetoothManager.startScan();
      if (reqCallBackListener != null) {
        reqCallBackListener.reqCallBack!(true, null);
      }
    }
  }

  static Future<bool> checkLocationPermissionIfNeeded() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      // mlogD('sssss', 'sdk:${androidInfo.version.sdkInt}');
      if (androidInfo.version.sdkInt >= 29) {
        // 检查定位权限
        var status = await Permission.location.status;
        if (!status.isGranted) {
          // 如果未授权，请求权限
          status = await Permission.location.request();
          if (status.isGranted) {
            // 用户授权了定位权限
          } else {
            // 用户拒绝了定位权限，显示提示
            showError('没有定位权限，无法执行蓝牙扫描');
            return false;
          }
        }
      }
    }
    return true;
  }
}
