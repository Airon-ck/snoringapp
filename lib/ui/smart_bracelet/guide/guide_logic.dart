import 'package:get/get.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/common_util/num_util.dart';
import 'package:snoring_app/common/user_comm.dart';
import 'package:snoring_app/common/user_logic.dart';
import 'package:snoring_app/utils/action_handle_util.dart';
import 'package:snoring_app/utils/ido_util.dart';

class GuideLogic extends ViewStateRequestModel {
  late String controllerTag;
  late double scale = 1.0;
  late int time = 0;

  @override
  void onDataInit() {
    double uiScale = NumUtil.divide(375, 812);
    MLog.d('sssss',
        'uiScale:$uiScale,screenWidth:${Get.width},screenHeight:${Get.height}');
    double screenScale = NumUtil.divide(Get.width, Get.height);
    MLog.d('sssss', 'screenScale:$screenScale');
    scale = NumUtil.divide(uiScale, screenScale);
    MLog.d('sssss', 'scale:$scale');
  }

  startBindDevice() {
    IdoUtil.requestBLEPermission(reqCallBackListener:
        ReqCallBackListener(reqCallBack: (bool? success, dynamic? result) {
      if (success!) {
        Future.delayed(Duration.zero, () {
          UserComm.saveIsFirstComingGuide(false);
          goSmartBraceLetPage();
        });
      }
    }));
  }
}
