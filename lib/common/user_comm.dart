import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:lib_sj/util/common_util/text_util.dart';
import 'package:get/get.dart';
import 'package:lib_sj/util/sp_util.dart';
import 'package:lib_sj/widget/popwindows/base/base_pop.dart';

class UserComm {
  static dynamic? boundDevice;

  static dynamic? batteryInfo;

  static dynamic? syncingData;

  /// 保存模块信息
  static void saveBatteryInfo(dynamic? data) {
    batteryInfo = data;
    if (batteryInfo != null) {
      SpUtil.putString('batteryInfo', json.encode(batteryInfo));
    }
  }

  /// 获取模块信息
  static dynamic? getBatteryInfo() {
    if (batteryInfo == null) {
      String? moduleInfo = SpUtil.getString('batteryInfo');
      if (!TextUtil.isEmpty(moduleInfo)) {
        final result = jsonDecode(moduleInfo!);
        batteryInfo = result;
      }
    }
    return batteryInfo;
  }

  /// 清除模块信息
  static clearBatteryInfo() {
    try {
      SpUtil.remove('batteryInfo');
    } on Exception catch (e) {
      debugPrint('e:$e');
    }
  }

  /// 保存模块信息
  static void saveBoundDevice(dynamic? device) {
    boundDevice = device;
    if (boundDevice != null) {
      SpUtil.putString('boundDevice', json.encode(boundDevice));
    }
  }

  /// 获取模块信息
  static dynamic? getBoundDevice() {
    if (boundDevice == null) {
      String? moduleInfo = SpUtil.getString('boundDevice');
      if (!TextUtil.isEmpty(moduleInfo)) {
        final result = jsonDecode(moduleInfo!);
        boundDevice = result;
      }
    }
    return boundDevice;
  }

  /// 保存模块信息
  static void saveSyncingData(dynamic? data) {
    syncingData = data;
    if (syncingData != null) {
      SpUtil.putString('syncingData', json.encode(data));
    }
  }

  /// 获取模块信息
  static dynamic? getSyncingData() {
    if (syncingData == null) {
      String? moduleInfo = SpUtil.getString('syncingData');
      if (!TextUtil.isEmpty(moduleInfo)) {
        final result = jsonDecode(moduleInfo!);
        syncingData = result;
      }
    }
    return syncingData;
  }

  /// 清除模块信息
  static clearSyncingData() {
    try {
      SpUtil.remove('syncingData');
    } on Exception catch (e) {
      debugPrint('e:$e');
    }
  }

  /// 是否第一次进入智能手环引导页
  static bool firstComingGuide = false;

  static saveIsFirstComingGuide(bool firstComing) {
    firstComingGuide = firstComing;
    SpUtil.putBool('firstComing', firstComingGuide);
  }

  static clearIsFirstComing() {
    try {
      SpUtil.remove('firstComing');
    } on Exception catch (e) {
      debugPrint('e:$e');
    }
  }

  static bool? readIsFirstComing() {
    firstComingGuide = SpUtil.getBool('firstComing', defValue: true)!;
    return firstComingGuide;
  }

  /**
   * 整个用户完成退出登录
   */
  static logout(
      {LogOutListener? logOutListener, bool? clearTokenToLogin = true}) async {
    if (clearTokenToLogin!) {
      BasePop.dismiss(Get.context!);
      // Get.until((route) {
      //   return route.settings.name == '/' || route.settings.name == '/HomePage';
      // });
    }
    Future.delayed(const Duration(milliseconds: 600), () {
      if (logOutListener != null) {
        logOutListener?.accountLogOutCallBack!();
      }
    });
  }

  /**
   * 登录成功后返回首页
   */
  static void loginSuccessBackToHome() async {
    // Get.until((route) {
    //   return route.settings.name == '/' || route.settings.name == '/HomePage';
    // });
  }

}

typedef AccountLogOutCallBack = Function();

class LogOutListener {
  final AccountLogOutCallBack? accountLogOutCallBack;

  LogOutListener({this.accountLogOutCallBack});
}


