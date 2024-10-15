import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_sj/getx/base/base_refresh_state_model.dart';
import 'package:lib_sj/util/common_util/date_util.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:protocol_lib/protocol_lib.dart';
import 'package:snoring_app/common/user_comm.dart';
import 'package:intl/intl.dart';

class BoundDeviceLogic extends BaseRefreshStateModel {
  late String controllerTag;

  @override
  void onDataInit() {
    boundDevice = UserComm.getBoundDevice();
    mlogD('sssss', 'onDataInit--boundDevice:$boundDevice');
    batteryInfo = UserComm.getBatteryInfo();
    if (batteryInfo != null) {
      batteryLevel = batteryInfo['level'] ?? 100;
    }
    mlogD('sssss', 'onDataInit--batteryInfo:$batteryInfo');
    lastSyncData = UserComm.getSyncingData();
    mlogD('sssss', 'onDataInit--lastSyncData:$lastSyncData');
    if (lastSyncData != null) {
      currentDate = DateUtil.formatDate(
          DateFormat('yyyy/MM/dd HH:mm').parse(lastSyncData['syncTime']),
          format: "yyyy-MM-dd");
    } else {
      currentDate = DateUtil.formatDateStr(DateUtil.getNowDateStr(),
          format: "yyyy-MM-dd");
    }
  }

  dynamic? boundDevice;
  dynamic? lastSyncData;
  dynamic? currentDate;

  /// 获取到字符串
  String resultStr = '';
  bool isSyncing = false;
  double progress = 0;

  List<dynamic> sleepSyncData = [];
  List<dynamic> activitySyncData = [];
  List<dynamic> multiActivitySyncData = [];
  List<dynamic> heartRateSyncData = [];
  List<dynamic> bloodOxygenSyncData = [];

  startSync() {
    isSyncing = true;
    resultStr = '';
    libManager.syncData.startSync(funcProgress: (progress) {
      this.progress = progress;
      debugPrint('startSync-----progress:$progress');
      updateUi();
    }, funcData: (type, jsonStr, errorCode) async {
      resultStr += '\n$type: \n json:$jsonStr';
      debugPrint('startSync-----resultStr:$resultStr');
      updateUi();
      if (type == SyncDataType.sleep) {
        sleepSyncData.add(jsonDecode(jsonStr));
      } else if (type == SyncDataType.activity) {
        multiActivitySyncData.add(jsonDecode(jsonStr));
      } else if (type == SyncDataType.stepCount) {
        activitySyncData.add(jsonDecode(jsonStr));
      } else if (type == SyncDataType.heartRate) {
        heartRateSyncData.add(jsonDecode(jsonStr));
      } else if (type == SyncDataType.bloodOxygen) {
        bloodOxygenSyncData.add(jsonDecode(jsonStr));
      }
    }, funcCompleted: (errorCode) {
      resultStr += '\n sync done';
      isSyncing = false;
      debugPrint('startSync-----resultStr:$resultStr');
      executeGetCmd();
      handleSyncingData();
      updateUi();
    });
  }

  handleSyncingData() {
    Map<String, dynamic>? syncDataResult = {};
    String? currentTime =
    DateUtil.formatDate(DateTime.now(), format: 'yyyy/MM/dd HH:mm');
    syncDataResult.addAll({
      'sleepSyncData': sleepSyncData,
      'multiActivitySyncData': multiActivitySyncData,
      'activitySyncData': activitySyncData,
      'heartRateSyncData': heartRateSyncData,
      'bloodOxygenSyncData': bloodOxygenSyncData,
      'syncTime': currentTime,
    });
    lastSyncData = syncDataResult;
    UserComm.saveSyncingData(syncDataResult);
    mlogD('sssss', 'handleSyncingData--lastSyncData:$lastSyncData');
  }

  stopSync() {
    libManager.syncData.stopSync();
    isSyncing = false;
    // debugPrint( 'stopSync-----resultStr:$resultStr');
    updateUi();
  }

  updateUi() {
    update(['${controllerTag}_detail']);
  }

  dynamic batteryInfo;
  dynamic batteryLevel = 100;

  ///执行相关的获取指令
  executeGetCmd() {
    Future.delayed(const Duration(milliseconds: 600), () {
      TestCmd e = TestCmd(cmd: CmdEvtType.getBatteryInfo, name: '获取电池信息');
      libManager.send(evt: e.cmd, json: jsonEncode(e.json ?? {})).listen((res) {
        debugPrint(
            '${e.name} evtType:${e.cmd.evtType} code:${res.code} json: ${res.json ?? 'NULL'}');
        if ((res.json ?? 'NULL') != 'NULL') {
          batteryInfo = jsonDecode(res.json!);
          batteryLevel = batteryInfo['level'] ?? 100;
          debugPrint('batteryInfo:$batteryInfo');
          UserComm.saveBatteryInfo(batteryInfo);
          updateUi();
        }
      });
    });
  }

  @override
  void onClose() {
    libManager.syncData.stopSync();
    super.onClose();
  }
}

class TestCmd {
  final CmdEvtType cmd;
  Map<String, dynamic>? json;
  final String name;

  TestCmd({required this.cmd, required this.name, this.json});
}
