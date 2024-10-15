import 'package:lib_sj/getx/base/base_view_state_request_model.dart';

typedef ReqCallBack = Function(bool? state, dynamic? result);

class ReqCallBackListener {
  final ReqCallBack? reqCallBack;

  ReqCallBackListener({this.reqCallBack});
}

class UserInfoLogic extends ViewStateRequestModel {
  @override
  void onDataInit() {
  }
}
