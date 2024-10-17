import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_sj/util/loading_util.dart';
import 'package:lib_sj/widget/my_text.dart';
import 'package:lib_sj/widget/sj_image_view.dart';
import 'package:snoring_app/common/space.dart';
import 'package:snoring_app/generated/generated_utils.dart';
import 'package:snoring_app/widget/appbar/c_app_bar.dart';
import 'package:snoring_app/widget/smart_button.dart';
import 'guide_logic.dart';

///引导
class GuidePage extends StatefulWidget {
  final String? typeId;

  const GuidePage({Key? key, this.typeId = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {
  late GuideLogic logic = Get.put(GuideLogic(), tag: '${widget.typeId}');

  @override
  void initState() {
    logic.controllerTag = '${widget.typeId}';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        if (logic.time == 0) {
          logic.time = DateTime.now().millisecondsSinceEpoch;
          showInfo(LangCurrent.exit_app);
          return Future.value(false);
        } else {
          if (DateTime.now().millisecondsSinceEpoch - logic.time < 2 * 1000) {
            logic.time = 0;
            exit(0);
            return Future.value(true);
          } else {
            logic.time = DateTime.now().millisecondsSinceEpoch;
            showInfo(LangCurrent.exit_app);
          }
        }
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: _buildBodyViewV2(),
      ),
    );
  }

  _buildBodyViewV2() {
    return Stack(
      children: [
        SjCommonImageView(
          'ic_smart_bracelet_guide_0',
          width: Get.width,
          height: Get.height,
        ),
        const CAppBar(
          showBackImg: false,
        ),
        Positioned(
            left: 0,
            right: 0,
            bottom: 412 * logic.scale,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SjText(
                  '体征健康监测',
                  fontSize: 24 * logic.scale,
                  color: const Color(0xffFFFFFF),
                  fontWeight: FontWeight.w600,
                ),
                H(24 * logic.scale),
                Text(
                  '更全面、更精准的数据，戴上手环，实时心率监\n测，录日常活动管理健康，自动识别您的睡眠状\n态，确认并改善您的睡眠习惯',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15 * logic.scale,
                    color: const Color(0xffFFFFFF),
                    fontWeight: FontWeight.w400,
                    height: 1.6,
                  ),
                ),
              ],
            )),
        Positioned(
            left: 38 * logic.scale,
            right: 38 * logic.scale,
            bottom: 136 * logic.scale,
            child: SmartButton(
              text: '开始',
              height: 46 * logic.scale,
              textColor: const Color(0xff3C7FFF),
              fontSize: 16 * logic.scale,
              fontWeight: FontWeight.w500,
              radius: 100,
              backgroundColor: const Color(0xffFFFFFF),
              onPressed: () {
                logic.startBindDevice();
              },
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 92 * logic.scale,
            child: Center(
              child: SjText(
                '本功能当前仅支持爱都科技智能手环相关产品',
                fontSize: 12 * logic.scale,
                color: const Color(0xffFFFFFF).withOpacity(0.90),
                fontWeight: FontWeight.w400,
              ),
            )),
      ],
    );
  }

  @override
  void dispose() {
    Get.delete<GuideLogic>(tag: logic.controllerTag);
    super.dispose();
  }
}
