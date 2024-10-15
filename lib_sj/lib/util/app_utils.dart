import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';

class AppUtil {
  static initDefaultStatusBarStatus(bool dark) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: dark ? Brightness.dark : Brightness.light));
  }

  /**
   * 修改状态栏颜色
   */
  static changeStatusBarStatus(bool dark) {
    if (dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarBrightness:
              Brightness.light // Dark == white status bar -- for IOS.
          ));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent, // Color for Android
          statusBarBrightness:
              Brightness.light // Dark == white status bar -- for IOS.
          ));
    }
  }

  static closeKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  /**
   * 复制到粘贴板
   */
  static copyValue2Clipboard(String value) {
    Clipboard.setData(ClipboardData(text: value));
  }

  /**
   * 获取粘贴板的内容
   */
  static Future<String?> getClipboardValue() async {
    var clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    return clipboardData?.text;
  }
}
