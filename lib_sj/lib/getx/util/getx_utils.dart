import 'package:get/get.dart';

S? findLogic<S>({String? tag}) {
  if (Get.isRegistered<S>(tag: tag)) {
    return Get.find<S>(tag: tag);
  } else {
    return null;
  }
}
