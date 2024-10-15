import 'package:flutter_easyloading/flutter_easyloading.dart';

/**
 * 显示loading
 */
showLoading({bool dismissOnTap = true}) {
  EasyLoading.show(
      dismissOnTap: dismissOnTap, maskType: EasyLoadingMaskType.clear);
}

/**
 * 隐藏loading
 */
dismissLoading() {
  EasyLoading.dismiss();
}

/**
 * progress loading
 */
showProgress(double progress, String status) {
  EasyLoading.showProgress(progress,
      maskType: EasyLoadingMaskType.none, status: status);
}

showSuccess(String status) {
  EasyLoading.showSuccess(status);
}

showError(String status) {
  EasyLoading.showError(status);
}

showInfo(String status) {
  EasyLoading.showInfo(status);
}

showToast(String status) {
  EasyLoading.showToast(status);
}
