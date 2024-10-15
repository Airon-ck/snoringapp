import 'package:get/get.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/common_util/num_util.dart';
import 'package:snoring_app/common/user_comm.dart';
import 'package:snoring_app/common/user_logic.dart';
import 'package:snoring_app/model/config_entity.dart';
import 'package:snoring_app/utils/action_handle_util.dart';
import 'package:snoring_app/utils/ido_util.dart';

class GuideLogic extends ViewStateRequestModel {
  late String controllerTag;
  late double scale = 1.0;

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

  List<ConfigEntity> bannerList = [
    ConfigEntity(
        img: 'ic_smart_bracelet_guide_1',
        name: '监测身体，改善健康',
        desc: '本功能当前仅支持爱都科技智能手环相关产品',
        type: 0),
    ConfigEntity(
        img: 'ic_smart_bracelet_guide_2',
        name: '记录活动，一路突破',
        desc: '本功能当前仅支持爱都科技智能手环相关产品',
        type: 1),
  ];

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
