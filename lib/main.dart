import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:snoring_app/common/g.dart';
import 'package:snoring_app/utils/ido_util.dart';
import 'base/base_app_widget.dart';

void main() async {
  /// 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  /// App初始化
  await AppSetting.init();

  /**
   * 强制竖屏朝上展示应用
   */
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });

  Global.init();

  /// 初始化手环相关
  IdoUtil.initIdo();
}
