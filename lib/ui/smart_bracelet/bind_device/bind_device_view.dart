import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:get/get.dart';
import 'package:lib_sj/getx/base/get_builder.dart';
import 'package:lib_sj/widget/scroll_view/no_shadow_scroll_behavior.dart';
import 'package:lib_sj/widget/sj_scaffold.dart';
import 'package:lib_sj/widget/my_text.dart';
import 'package:lib_sj/widget/sj_image_view.dart';
import 'package:snoring_app/common/space.dart';
import 'package:snoring_app/ui/smart_bracelet/base/base_state.dart';
import 'package:snoring_app/ui/smart_bracelet/bind_device/widget/device_item.dart';
import 'package:snoring_app/ui/smart_bracelet/bind_device/widget/gradient_circular_progress_indicator.dart';
import 'package:snoring_app/ui/smart_bracelet/bind_device/widget/turn_box.dart';
import 'package:snoring_app/utils/action_handle_util.dart';
import 'package:snoring_app/widget/appbar/c_app_bar.dart';
import 'package:snoring_app/widget/smart_button.dart';
import 'bind_device_logic.dart';

///绑定设备
class BindDevicePage extends StatefulWidget {
  final String? typeId;

  const BindDevicePage({Key? key, this.typeId = ''}) : super(key: key);

  @override
  State<StatefulWidget> createState() => BindDevicePageState();
}

class BindDevicePageState extends BaseState<BindDevicePage>
    with TickerProviderStateMixin {
  late BindDeviceLogic logic =
      Get.put(BindDeviceLogic(), tag: '${widget.typeId}');

  @override
  void initState() {
    logic.controllerTag = '${widget.typeId}';
    initAnimation();
    addDeviceConnectListener();
    addStatusNotificationListener();
    logic.addScanResultListener();
    super.initState();
    logic.startScanDevice();
  }

  Future<bool> _onWillPop() {
    if (Navigator.canPop(context)) {
      backAndRefresh();
      return Future.value(false);
    } else {
      backAndRefresh();
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SjScaffold(
      enableBackClickListener: true,
      onBackClickListener: _onWillPop,
      backgroundColor: const Color(0xffFFFFFF),
      appBar: const CAppBar(
        showBackImg: false,
        bgColor: Colors.white,
        title: '绑定设备',
        titleColor: Color(0xff2A2A2A),
        titleTextSize: 16,
        titleFontWeight: FontWeight.w500,
      ),
      body: MyGetBuilder(
          id: '${logic.controllerTag}_detail',
          controller: logic,
          tag: logic.controllerTag,
          builder: (BuildContext mContext, BindDeviceLogic value) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(child: _buildBodyView()),
                _buildBottomView(),
              ],
            );
          }),
    );
  }

  _buildBodyView() {
    return ScrollConfiguration(
      behavior: NoShadowScrollBehavior(),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            H(73),
            Container(
              color: Colors.transparent,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                      animation: logic.animationController,
                      builder: (BuildContext context, Widget? child) {
                        return TurnBox(
                          turns: 5 / 8,
                          child: GradientCircularProgressIndicator(
                              colors: const [
                                Color(0xff38BDF8),
                                Color(0xffF5F5F5),
                              ],
                              radius: (Get.width - 2 * 66) / 2,
                              stokeWidth: 5.0,
                              strokeCapRound: true,
                              backgroundColor: const Color(0xffF5F5F5),
                              totalAngle: 1.5 * pi,
                              value: CurvedAnimation(
                                      parent: logic.animationController,
                                      curve: Curves.ease)
                                  .value),
                        );
                      }),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SjCommonImageView(
                        'ic_bind_wristband',
                        width: 47,
                        height: 80,
                      ),
                      W(14),
                      SjCommonImageView(
                        'ic_bind_connection_status_0',
                        width: 24,
                        height: 24,
                      ),
                      W(14),
                      SjCommonImageView(
                        'ic_bind_mobile',
                        width: 34,
                        height: 74,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // H(44),
            SjText(
              logic.isScanning ? '正在搜索设备...' : '已搜索设备',
              color: const Color(0xff0A0A0A),
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
            H(10),
            SjText(
              '取出设备，充电激活，并靠近手机',
              color: const Color(0xff737373),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
            H(44),
            MyGetBuilder(
              id: '${logic.controllerTag}_deviceList',
              controller: logic,
              tag: logic.controllerTag,
              builder: (BuildContext mContext, BindDeviceLogic value) {
                return MediaQuery.removePadding(
                  context: context,
                  removeTop: true,
                  removeBottom: true,
                  removeLeft: true,
                  removeRight: true,
                  child: ListView.separated(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: logic.devices.length,
                    itemBuilder: (context, index) {
                      return DeviceItem(logic.devices[index],
                          onPressed: (itemValue) {
                        connectDevice(itemValue);
                      });
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return H(10);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  _buildBottomView() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: 16.0,
        top: 16.0,
        right: 16.0,
        bottom: 15.0 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SmartButton(
            width: double.infinity,
            height: 46,
            backgroundColor: const Color(0xff364DCC),
            borderWidth: 1.0,
            borderColor: const Color(0xff364DCC),
            radius: 100,
            text: '重新搜索',
            textColor: const Color(0xffFFFFFF),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            onPressed: () {
              logic.startScanDevice();
              logic.update(['${logic.controllerTag}_detail']);
            },
          ),
          H(15),
          SmartButton(
            width: double.infinity,
            height: 46,
            backgroundColor: Colors.transparent,
            borderWidth: 1.0,
            borderColor: const Color(0xffA3A3A3),
            radius: 100,
            text: '暂不绑定',
            textColor: const Color(0xffA3A3A3),
            fontSize: 16,
            fontWeight: FontWeight.w500,
            onPressed: () {
              bluetoothManager.cancelConnect();
            },
          ),
        ],
      ),
    );
  }

  initAnimation() {
    logic.animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 3000));
    logic.animationController.addStatusListener((status) {
      if (status == AnimationStatus.forward) {
        logic.isForward = true;
      } else if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        // if (logic.isForward) {
        //   logic.animationController.reverse();
        // } else {
        //   logic.animationController.forward();
        // }
        logic.animationController.repeat();
      } else if (status == AnimationStatus.reverse) {
        logic.isForward = false;
      }
    });
    // logic.animationController.forward();
  }

  @override
  bindSuccess() {
    logic.goToBoundDevice(isConnected: isConnected, isBinded: isBinded);
    return super.bindSuccess();
  }

  @override
  updateUi() {
    logic.update(['${logic.controllerTag}_detail']);
    return super.updateUi();
  }

  @override
  void dispose() {
    logic.animationController.dispose();
    removeDeviceConnectListener();
    removeStatusNotificationListener();
    // bluetoothManager.cancelConnect();
    Get.delete<BindDeviceLogic>(tag: logic.controllerTag);
    super.dispose();
  }
}
