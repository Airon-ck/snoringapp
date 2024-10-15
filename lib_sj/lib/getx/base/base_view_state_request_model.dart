import 'package:lib_sj/lib_sj.dart';

import 'package:get/get.dart';
import 'package:lib_sj/src/net_common/http_setting.dart';
import 'package:lib_sj/src/net_common/request_util.dart';

abstract class ViewStateRequestModel extends GetxController with IRequestUtil {
  String getRequestUrl(String requestUrl) {
    return HttpSetting.BASE_URL + requestUrl;
  }

  @override
  void onInit() {
    super.onInit();
    onDataInit();
  }

  /**
   * 状态管理新创建时进行数据的初始化操作
   */
  void onDataInit();

  /**
   * 状态管理被销毁时
   */
  void onDestroy() {}

  @override
  void onClose() {
    onDestroy();
    super.onClose();
  }
}
