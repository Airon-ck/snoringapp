import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/sp_util.dart';
import 'package:lib_sj/util/toast.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static int? versionCode;
  static String? versionName;

  static ValueChanged<dynamic>? valueChanged;

  static init() {
    initPackageInfo();
  }

  static initEvent(ValueChanged<dynamic>? appEvent) {
    valueChanged = appEvent;
  }

  static initPackageInfo() {
    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      versionCode = int.parse(packageInfo.buildNumber);
      versionName = packageInfo.version;
      if (versionCode != null) {
        SpUtil.putInt(AppSetting.versionCodeKey, versionCode!);
      }
      if (versionName != null && versionName!.isNotEmpty) {
        SpUtil.putString(AppSetting.versionKey, versionName!);
      }
    });
  }

  static int getVersionCode() {
    if (versionCode == null || versionCode!.isNaN || versionCode == -1) {
      versionCode = SpUtil.getInt(AppSetting.versionCodeKey, defValue: -1);
      versionName =
          SpUtil.getString(AppSetting.versionKey, defValue: "UnKnowVersion");
    }
    return versionCode ?? -1;
  }

  static String getVersionName() {
    if (versionName == null || versionName!.isEmpty) {
      versionCode = SpUtil.getInt(AppSetting.versionCodeKey, defValue: -1);
      versionName = SpUtil.getString(AppSetting.versionKey, defValue: null);
    }
    return versionName ?? "UnKnowVersion";
  }

  static sendAppInfo(dynamic event) {
    valueChanged?.call(event);
  }

  static bool isIOSAndMac() {
    return Platform.isIOS || Platform.isMacOS;
  }

  static bool isAndroid() {
    return Platform.isAndroid;
  }
}
