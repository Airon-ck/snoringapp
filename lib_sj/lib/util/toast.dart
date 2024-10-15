import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart' as ToastLib;
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/util/device_utils.dart';

class ToastUtil {
  static showShort(String msg) {
    ToastLib.Fluttertoast.showToast(
        msg: msg,
        toastLength: ToastLib.Toast.LENGTH_SHORT,
        gravity: DeviceUtils.isIOS
            ? ToastLib.ToastGravity.CENTER
            : ToastLib.ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: AppSetting.toastTextSize);
  }

  static showLong(String msg) {
    ToastLib.Fluttertoast.showToast(
        msg: msg,
        toastLength: ToastLib.Toast.LENGTH_LONG,
        gravity: DeviceUtils.isIOS
            ? ToastLib.ToastGravity.CENTER
            : ToastLib.ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: AppSetting.toastTextSize);
  }

  static showLongKey(String msgKey) {
    ToastLib.Fluttertoast.showToast(
        msg: getSjTextByKey(msgKey)!,
        toastLength: ToastLib.Toast.LENGTH_LONG,
        gravity: DeviceUtils.isIOS
            ? ToastLib.ToastGravity.CENTER
            : ToastLib.ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black87,
        textColor: Colors.white,
        fontSize: AppSetting.toastTextSize);
  }
}

showShort(String msg) {
  ToastLib.Fluttertoast.showToast(
      msg: msg,
      toastLength: ToastLib.Toast.LENGTH_SHORT,
      gravity: DeviceUtils.isIOS
          ? ToastLib.ToastGravity.CENTER
          : ToastLib.ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: AppSetting.toastTextSize);
}

showLong(String msg) {
  ToastLib.Fluttertoast.showToast(
      msg: msg,
      toastLength: ToastLib.Toast.LENGTH_LONG,
      gravity: DeviceUtils.isIOS
          ? ToastLib.ToastGravity.CENTER
          : ToastLib.ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: AppSetting.toastTextSize);
}
