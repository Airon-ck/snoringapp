import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:get/get.dart';
import 'package:lib_sj/getx/base/get_builder.dart';
import 'package:lib_sj/util/loading_util.dart';
import 'package:lib_sj/widget/sj_scaffold.dart';
import 'package:lib_sj/widget/my_text.dart';
import 'package:lib_sj/widget/sj_image_view.dart';
import 'package:snoring_app/common/space.dart';
import 'package:snoring_app/ui/smart_bracelet/base/base_state.dart';
import 'package:snoring_app/ui/smart_bracelet/bind_device/bind_device_view.dart';
import 'package:snoring_app/utils/action_handle_util.dart';
import 'package:snoring_app/widget/appbar/c_app_bar.dart';
import 'package:snoring_app/widget/ratio_widget.dart';
import 'package:snoring_app/widget/smart_button.dart';
import 'bound_device_logic.dart';

///已绑定设备
class BoundDevicePage extends StatefulWidget {
  final String? typeId;

  final bool isConnected;

  final bool isBinded;

  const BoundDevicePage({
    Key? key,
    this.typeId = '',
    this.isConnected = false,
    this.isBinded = false,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => BoundDevicePageState();
}

class BoundDevicePageState extends BaseState<BoundDevicePage>
    with SingleTickerProviderStateMixin {
  late BoundDeviceLogic logic =
      Get.put(BoundDeviceLogic(), tag: '${widget.typeId}');

  late AnimationController _controller;

  initAnimation() {
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void initState() {
    logic.controllerTag = '${widget.typeId}';
    isConnected = widget.isConnected;
    isBinded = widget.isBinded;
    initAnimation();
    addDeviceConnectListener();
    addStatusNotificationListener();
    super.initState();
    debugPrint(
        'deviceConnectState--$deviceConnectState--isConnected:$isConnected--isBinded:$isBinded');
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
    return _buildBodyView();
  }

  @override
  fastSyncCompleted() {
    if (isBinded) {
      Future.delayed(const Duration(milliseconds: 600), () {
        logic.startSync();
      });
    }
    return super.fastSyncCompleted();
  }

  @override
  updateUi() {
    logic.updateUi();
    return super.updateUi();
  }

  _buildBodyView() {
    return Container(
      color: const Color(0xffF5F5F5),
      child: Stack(
        children: [
          RatioWidget(
            ratio: 375 / 227,
            child: SjCommonImageView('ic_bound_device_new_bg'),
          ),
          SjScaffold(
            enableBackClickListener: true,
            onBackClickListener: _onWillPop,
            backgroundColor: Colors.transparent,
            appBar: CAppBar(
              bgColor: Colors.transparent,
              showBackImg: false,
              title: '体征健康监测',
              titleColor: const Color(0xffFFFFFF),
              titleTextSize: 16,
              titleFontWeight: FontWeight.w500,
              backImgUrl: 'ic_return_white',
              onBack: () {
                backAndRefresh();
              },
            ),
            body: MyGetBuilder(
                id: '${logic.controllerTag}_detail',
                controller: logic,
                tag: logic.controllerTag,
                builder: (BuildContext mContext, BoundDeviceLogic value) {
                  return Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Visibility(
                          visible: logic.isSyncing,
                          child: Container(
                            margin:
                                const EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                AnimatedBuilder(
                                  animation: _controller,
                                  child: SjCommonImageView(
                                    'ic_synchronous_white',
                                    width: 14,
                                    height: 14,
                                  ),
                                  builder: (context, child) {
                                    return Transform.rotate(
                                      angle: _controller.value *
                                          2.0 *
                                          3.1415927, // 旋转的角度值
                                      child: child,
                                    );
                                  },
                                ),
                                W(4),
                                SjText(
                                  '正在同步数据...${logic.progress}%',
                                  color: const Color(0xffffffff),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ],
                            ),
                          )),
                      Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(255, 255, 255, 0.13),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        margin: const EdgeInsets.only(left: 12.0, right: 12.0),
                        child: Stack(
                          children: [
                            RatioWidget(
                              ratio: 351 / 157,
                              child: SjCommonImageView(
                                  'ic_bound_device_synchronous_new_bg'),
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 13.0,
                                right: 16.0,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12.0),
                                    child: SjText(
                                      logic.lastSyncData != null
                                          ? '最近同步时间：${logic.lastSyncData['syncTime']}'
                                          : '尚未同步数据',
                                      color: const Color(0xff737373),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: SmartButton(
                                      text: '手动同步数据',
                                      textColor: const Color(0xffFFFFFF),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      drawablePadding: 5.0,
                                      drawableLeft: Padding(
                                        padding:
                                            const EdgeInsets.only(top: 4.0),
                                        child: SjCommonImageView(
                                          'ic_synchronous_start',
                                          width: 16,
                                          height: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (isBinded) {
                                          logic.startSync();
                                        } else {
                                          showError('设备未连接，请先连接设备！');
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 44),
                              alignment: Alignment.center,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      W(14),
                                      SjCommonImageView(
                                        'ic_bound_device_new',
                                        width: 24,
                                        height: 40.83,
                                      ),
                                      W(12),
                                      Expanded(
                                          child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SjText(
                                            logic.boundDevice['name'] ?? '',
                                            color: const Color(0xff262626),
                                            fontSize: 15,
                                            fontWeight: FontWeight.w500,
                                          ),
                                          H(8),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SmartButton(
                                                text: isBinded ? '已连接' : '未连接',
                                                textColor:
                                                    const Color(0xff262626),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                drawablePadding: 4.0,
                                                drawableLeft: SjCommonImageView(
                                                  isBinded
                                                      ? 'ic_bound_device_connected'
                                                      : 'ic_bound_device_unconnected',
                                                  width: 14,
                                                  height: 14,
                                                ),
                                                onPressed: () {
                                                  connectDevice(
                                                      IDOBluetoothDeviceModel(
                                                        name: logic.boundDevice[
                                                            'name'],
                                                        uuid: logic.boundDevice[
                                                            'uuid'],
                                                        macAddress:
                                                            logic.boundDevice[
                                                                'macAddress'],
                                                      ),
                                                      isShowLoading: true);
                                                },
                                              ),
                                              W(14),
                                              SmartButton(
                                                text: '${logic.batteryLevel}%',
                                                textColor:
                                                    const Color(0xff262626),
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400,
                                                drawablePadding: 4.0,
                                                drawableLeft: SjCommonImageView(
                                                  logic.batteryLevel <= 20
                                                      ? 'ic_bound_device_battery_1'
                                                      : logic.batteryLevel <= 50
                                                          ? 'ic_bound_device_battery_2'
                                                          : 'ic_bound_device_battery_3',
                                                  width: 24.5,
                                                  height: 11.5,
                                                ),
                                                onPressed: () {
                                                  // if (isBinded) {
                                                  //   logic.executeGetCmd();
                                                  // }
                                                  exportLog();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                      Visibility(
                                          // visible: !isBinded,
                                          child: GestureDetector(
                                        child: SjText(
                                          !isBinded ? '连接手环' : '解除绑定',
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff34D399),
                                        ),
                                        onTap: () {
                                          debugPrint('0----isBinded:$isBinded');
                                          if (!isBinded) {
                                            connectDevice(
                                                IDOBluetoothDeviceModel(
                                              name: logic.boundDevice['name'],
                                              uuid: logic.boundDevice['uuid'],
                                              macAddress: logic
                                                  .boundDevice['macAddress'],
                                            ));
                                          } else {
                                            unBindDevice();
                                          }
                                        },
                                      )),
                                      W(12.5),
                                    ],
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                      left: 10,
                                      top: 18,
                                      right: 10,
                                      bottom: 12,
                                    ),
                                    padding: const EdgeInsets.only(
                                      left: 5.0,
                                      top: 8.0,
                                      right: 5.0,
                                      bottom: 8.0,
                                    ),
                                    decoration: const BoxDecoration(
                                      color: Color(0xffF8FAFC),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0)),
                                    ),
                                    child: SjText(
                                      '绑定手环，实时心率监测，记录日常活动管理健康，自动识别您的睡眠状态，确认并改善您的睡眠习惯。',
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xff3B56E6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ),
        ],
      ),
    );
  }

  @override
  unBindSuccess() {
    // TODO: implement unBindSuccess
    Get.off(const BindDevicePage(key: Key('BindDevicePage')));
    return super.unBindSuccess();
  }

  @override
  void dispose() {
    _controller.dispose();
    removeDeviceConnectListener();
    removeStatusNotificationListener();
    // bluetoothManager.cancelConnect();
    Get.delete<BoundDeviceLogic>(tag: logic.controllerTag);
    super.dispose();
  }
}
