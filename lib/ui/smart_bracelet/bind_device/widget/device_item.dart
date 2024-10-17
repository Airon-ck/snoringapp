import 'package:flutter/material.dart';
import 'package:flutter_bluetooth/ido_bluetooth.dart';
import 'package:snoring_app/common/space.dart';
import 'package:lib_sj/widget/my_text.dart';
import 'package:lib_sj/widget/sj_image_view.dart';
import 'package:snoring_app/widget/smart_button.dart';

/// 搜索设备Item
class DeviceItem extends StatelessWidget {
  final IDOBluetoothDeviceModel? itemData;

  final Function(IDOBluetoothDeviceModel? itemData)? onPressed;

  final EdgeInsets parentMargin;
  final EdgeInsets parentPadding;

  const DeviceItem(
    this.itemData, {
    Key? key,
    this.parentMargin =
        const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
    this.parentPadding =
        const EdgeInsets.symmetric(vertical: 12.0, horizontal: 14.0),
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // onPressed!(itemData);
      },
      child: Container(
        margin: parentMargin,
        padding: parentPadding,
        decoration: const BoxDecoration(
          color: Color(0xffF5F5F5),
          borderRadius: BorderRadius.all(
            Radius.circular(8.0),
          ),
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SjCommonImageView(
              'ic_bind_search_device',
              width: 18,
              height: 30,
            ),
            W(12),
            Expanded(
                child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SjText(
                  itemData?.name ?? '',
                  color: const Color(0xff737373),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
                H(6),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SjCommonImageView(
                      'ic_bind_search_ble_device',
                      width: 14,
                      height: 14,
                    ),
                    W(2),
                    SjCommonImageView(
                      _getRssiIcon(),
                      width: 17.1,
                      height: 10.7,
                    ),
                  ],
                ),
              ],
            )),
            SmartButton(
              width: 66,
              height: 24,
              text: _getDeviceState(),
              textColor: const Color(0xff34D399),
              fontSize: 13,
              fontWeight: FontWeight.w500,
              backgroundColor: Colors.transparent,
              borderColor: const Color(0xff34D399),
              borderWidth: 0.5,
              radius: 100,
              onPressed: () {
                onPressed!(itemData);
              },
            ),
          ],
        ),
      ),
    );
  }

  _getRssiIcon() {
    int? rssi = itemData?.rssi;
    if (rssi! >= -20 && rssi < 0) {
      return 'ic_bind_search_device_rifi_4';
    } else if (rssi >= -40 && rssi < -20) {
      return 'ic_bind_search_device_rifi_3';
    } else if (rssi >= -60 && rssi < -40) {
      return 'ic_bind_search_device_rifi_2';
    } else if (rssi >= -80 && rssi < -60) {
      return 'ic_bind_search_device_rifi_1';
    }
    return 'ic_bind_search_device_rifi_1';
  }

  _getDeviceState() {
    if (itemData?.state == IDOBluetoothDeviceStateType.disconnected) {
      return '绑定';
    } else if (itemData?.state == IDOBluetoothDeviceStateType.connecting) {
      return '连接中';
    } else if (itemData?.state == IDOBluetoothDeviceStateType.connected) {
      return '已连接';
    } else if (itemData?.state == IDOBluetoothDeviceStateType.disconnecting) {
      return '断开连接中';
    }
    return '绑定';
  }
}
