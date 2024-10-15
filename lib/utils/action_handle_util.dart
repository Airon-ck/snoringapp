import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:snoring_app/common/user_comm.dart';
import 'package:snoring_app/ui/smart_bracelet/bind_device/bind_device_view.dart';
import 'package:snoring_app/ui/smart_bracelet/bound_device/bound_device_view.dart';

/**
 * 业务跳转场景处理
 */

///返回上一级页面并刷新
backAndRefresh({dynamic? result}) {
  Get.back(result: result ?? {'isBack': true});
}

///前往智能手环
Future<T?>? goSmartBraceLetPage<T>() async {
  return !UserComm.readIsFirstComing()! && UserComm.getBoundDevice() != null
      ? Get.to(const BoundDevicePage(key: Key('BoundDevicePage')))
      : Get.to(const BindDevicePage(key: Key('BindDevicePage')));
}
