import 'package:lib_sj/generated/lib_sj_text.dart';

enum ViewState {
  idle,
  loading, //加载中
  empty, //无数据
  error, //加载失败
  errorEmpty, //加载失败,并且该页面空数据
}

enum ModelErrorState {
  NetworkTimeOutError,
  TIMEOUT, //包含连接超时，发送超时，接收超时
  RESPONSE_ERROR,
  CANCLE,
  OTHER_ERROR,
}

class ViewStateError {
  String? errorMsg;
  late ModelErrorState _errorState;

  ViewStateError(this._errorState, {this.errorMsg}) {
    // _errorState ??= ModelErrorState.OTHER_ERROR;
  }

  bool get isNetworkTimeOut => _errorState == ModelErrorState.NetworkTimeOutError;
}
