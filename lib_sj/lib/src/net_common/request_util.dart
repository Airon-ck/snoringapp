import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/common/app_base.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/net_util.dart';
import 'package:lib_sj/util/toast.dart';

import 'dio_http_client.dart';
import 'http_exceptions.dart';
import 'http_response.dart';
import 'http_setting.dart';
import 'net_options.dart';
import 'request_other.dart';

/**
 * 向外部只仅提供一些网络请求方法
 * 并且根据服务器实际返回的数据进行解析处理
 */
mixin IRequestUtil {
  Future<bool> _asyncRequestNetwork(
    String reqUrl, {
    NetSuccessCallback? onSuccessFunc,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onErrorFunc,
    NetErrorExCallback? onExError,
    dynamic param,
    Map<String, dynamic>? queryParameter,
    CancelToken? cancelTokenFunc,
    SjNetOpitions? option,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.get(reqUrl,
          queryParameters: queryParameter,
          options: option != null ? option.getOptions() : null);
      return _handResponseResult(
          result, onSuccessFunc, onSuccessByResponse, onErrorFunc, onExError);
    } else {
      return _returnNetErrorResponse(onErrorFunc, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.get(reqUrl,
    //     queryParameters: queryParameter, options: option != null ? option.getOptions() : null);
    // return _handResponseResult(result, onSuccessFunc, onSuccessByResponse, onErrorFunc, onExError);
  }

  Future<bool> asyncGetRequestNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) {
    return _asyncRequestNetwork(
      url,
      onSuccessFunc: onSuccess,
      onSuccessByResponse: onSuccessByResponse,
      onErrorFunc: onError,
      param: params,
      queryParameter: queryParameters,
      cancelTokenFunc: cancelToken,
      option: options,
    );
  }

  Future<bool> asyncGetRequestByBodyNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.getByBody(url,
          data: data,
          queryParameters: queryParameters,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.getByBody(url,
    //     data: data,
    //     queryParameters: queryParameters,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> asyncPostRequestNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.post(url,
          data: data,
          queryParameters: queryParameters,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }

    // MyHttpResponse result = await DioHttpClient.instance.post(url,
    //     data: data,
    //     queryParameters: queryParameters,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> asyncPutRequestNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.put(url,
          data: data,
          queryParameters: queryParameters,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.put(url,
    //     data: data,
    //     queryParameters: queryParameters,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> asyncPatchRequestNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.patch(url,
          data: data,
          queryParameters: queryParameters,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.patch(url,
    //     data: data,
    //     queryParameters: queryParameters,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> asyncDeleteRequestNetwork(
    String url, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    dynamic params,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.delete(url,
          data: data,
          queryParameters: queryParameters,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.delete(url,
    //     data: data,
    //     queryParameters: queryParameters,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> upLoadAudioFile(
    String url,
    String path, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    CancelToken? cancelToken,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.upLoadAudioFile(
          url, path,
          fileKeyName: fileKey,
          queryParameters: queryParameters,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.upLoadAudioFile(url, path,
    //     fileKeyName: fileKey,
    //     queryParameters: queryParameters,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress,
    //     cancelToken: cancelToken,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError);
  }

  Future<bool> uploadFile(
    String url,
    String path, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    CancelToken? cancelToken,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    SjNetOpitions? options,
    dynamic successCode,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.upLoadFile(url, path,
          fileKeyName: fileKey,
          queryParameters: queryParameters,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
          cancelToken: cancelToken,
          successCode: successCode,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError,
          successCode: successCode);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
    // MyHttpResponse result = await DioHttpClient.instance.upLoadFile(url, path,
    //     fileKeyName: fileKey,
    //     queryParameters: queryParameters,
    //     onSendProgress: onSendProgress,
    //     onReceiveProgress: onReceiveProgress,
    //     cancelToken: cancelToken,
    //     successCode: successCode,
    //     options: options != null ? options.getOptions() : null);
    // return _handResponseResult(result, onSuccess, onSuccessByResponse, onError, onExError,
    //     successCode: successCode);
  }

  Future<bool> uploadMulFile(
    String url,
    List<String> paths, {
    NetSuccessCallback? onSuccess,
    NetSuccessHttpResponseCallback? onSuccessByResponse,
    NetErrorCallback? onError,
    NetErrorExCallback? onExError,
    String? fileKey,
    Map<String, dynamic>? queryParameters,
    SjNetOpitions? options,
  }) async {
    bool netIsAvailable = await checkNetIsAvailable();
    if (netIsAvailable) {
      MyHttpResponse result = await DioHttpClient.instance.upLoadMulFile(
          url, paths,
          queryParameters: queryParameters,
          fileKeyName: fileKey,
          options: options != null ? options.getOptions() : null);
      return _handResponseResult(
          result, onSuccess, onSuccessByResponse, onError, onExError);
    } else {
      return _returnNetErrorResponse(onError, onExError);
    }
  }

  Future<bool> _returnNetErrorResponse(
      NetErrorCallback? onError, NetErrorExCallback? onExError) {
    dynamic thisCodeA = HttpSetting.isJavaServer ? "NetError01-a" : -1996;
    setStatusError();
    onError?.call(
        thisCodeA,
        HttpSetting.getMyResponseExceptionDesc(
                NetworkException(), true, thisCodeA) ??
            getSjTextByKey('server_error'));
    dynamic thisCodeB = HttpSetting.isJavaServer ? "NetError01-b" : -1996;
    onExError?.call(
        thisCodeB,
        HttpSetting.getMyResponseExceptionDesc(
                NetworkException(), true, thisCodeB) ??
            getSjTextByKey('server_error'),
        null);
    return Future.value(false);
  }

  Future<void> download(
    String url,
    String savePaths, {
    NetSuccessCallback? onSuccess,
    NetErrorCallback? onError,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
    SjNetOpitions? options,
  }) async {
    MyHttpResponse result = await DioHttpClient.instance.download(
        url, savePaths,
        onReceiveProgress: onReceiveProgress,
        cancelToken: cancelToken,
        options: options != null ? options.getOptions() : null);
    if (result == null || result.data == null) {
      onError?.call(
          HttpSetting.isJavaServer ? "B000001-a" : -996,
          HttpSetting.getMyResponseExceptionDesc(
                  Exception(), false, "B000001-a") ??
              getSjTextByKey('server_error'));
      return;
    }
    // mlogD("DefaultHttpTransformer", "result=${result.code}---${result.message}");
    if (result.code == 200) {
      onSuccess?.call(result.code, savePaths, result.message);
    } else {
      onError?.call(
          result.data, result.message ?? getSjTextByKey('download_failed')!);
    }
    // if (HttpSetting.isJavaServer) {
    //   String code = result.data[HttpSetting.getCodeKey(result.requestUrlPath)];
    //   if (code == HttpSetting.getJavaRequestSuccessCode(result.requestUrlPath)) {
    //     onSuccess?.call(code, result.data[HttpSetting.getDataKey(result.requestUrlPath)],
    //         result.data[HttpSetting.getMsgKey(result.requestUrlPath)]);
    //   } else {
    //     onError?.call(code, result.data[HttpSetting.getMsgKey(result.requestUrlPath)]);
    //   }
    // } else {
    //   int code = result.code;
    //   if (code == 200) {
    //     onSuccess?.call(code, result.data, result.message);
    //   } else {
    //     onError?.call(result.data, result.message ?? getSjTextByKey('download_failed'));
    //   }
    // }
  }

  /**
   * 针对服务器返回的数据结果进行处理
   * 返回是否请求成功
   */
  Future<bool> _handResponseResult(
      MyHttpResponse result,
      NetSuccessCallback? onSuccessFunc,
      NetSuccessHttpResponseCallback? onSuccessByResponse,
      NetErrorCallback? onErrorFunc,
      NetErrorExCallback? onExError,
      {dynamic successCode}) async {
    // mlogD("_parseException", "_handResponseResult  result=${result.error}  type=${result.error.runtimeType}");
    if (result != null && result.error is CancelException) {
      setStatusError();
      onErrorFunc?.call(
          HttpSetting.getCancleCode(), getSjTextByKey('request_is_cancel')!);
      onExError?.call(HttpSetting.getCancleCode(),
          getSjTextByKey('request_is_cancel')!, result.error?.response?.data);
      return Future.value(false);
    }

    if (result == null || result.data == null) {
      HttpException? thisError = result.error;
      dynamic thisCodeB =
          HttpSetting.isJavaServer ? thisError?.code ?? "B000001-b" : -996;
      // mlogD("_handResponseResult", "msg----------------------------${result.error.runtimeType}");
      setStatusError();
      onErrorFunc?.call(
          thisCodeB,
          HttpSetting.getMyResponseExceptionDesc(thisError ?? Exception(),
                  thisError is NetworkException, thisCodeB) ??
              thisError?.message ??
              getSjTextByKey('server_error'));
      mlogD("zxczxcadsdas",
          "-----------------aaa-------------------result.error=${result.error}---${thisError?.code}");
      dynamic thisCodeC =
          HttpSetting.isJavaServer ? thisError?.code ?? "B000001-c" : -996;
      onExError?.call(
          thisCodeC,
          HttpSetting.getMyResponseExceptionDesc(thisError ?? Exception(),
                  result.error is NetworkException, thisCodeC) ??
              result.error?.message ??
              getSjTextByKey('server_error'),
          result.error?.response is DioError
              ? result.error?.response
              : (result.error?.response is Response)
                  ? result.error?.response?.data
                  : result.error);
      return Future.value(false);
    }
    String dataKey = HttpSetting.getDataKey(result.requestUrlPath);
    String codeKey = HttpSetting.getCodeKey(result.requestUrlPath);
    String msgKey = HttpSetting.getMsgKey(result.requestUrlPath);
    bool isResponseSucess = HttpSetting.isJavaServer
        ? (successCode == null
            ? (result.data[codeKey] ==
                HttpSetting.getJavaRequestSuccessCode(result.requestUrlPath))
            : successCode == result.data[codeKey])
        : (result.data[codeKey] == 0);
    // mlogE("_handResponseResultaaa",
    //     "===========================isResponseSucess=${isResponseSucess}---${codeKey}--");
    // mlogE("_handResponseResult", "===========================isResponseSucess=${isResponseSucess}---${codeKey}---${HttpSetting.getJavaRequestSuccessCode()}");
    try {
      //向外部传递请求过程中所有的来自服务器自定义的状态码
      HttpSetting.responseJavaCodeListener
          ?.call(result.data[HttpSetting.getCodeKey(result.requestUrlPath)]);
    } on Exception catch (e) {
      mlogE("_handResponseResult", "Exception=${e.toString()}");
    }

    if (isResponseSucess) {
      setStatusIdle();
      if (HttpSetting.isJavaServer &&
          result.data[codeKey] ==
              HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath)) {
        //登录超时
        AppInfo.sendAppInfo(
            HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath));
        onErrorFunc?.call(
            HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath),
            result.data[msgKey]);
        onExError?.call(
            HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath),
            result.data[msgKey],
            Exception());
        return Future.value(false);
      }
      _handResponseDataStatus(result.data[dataKey]);
      if (onSuccessFunc != null) {
        // mlogD("dasdzz", "codeKey=${codeKey}---type=${codeKey.runtimeType}");
        // mlogD("dasdzz",
        //     "result.data[codeKey]=${result.data[codeKey]}---type=${result.data[codeKey].runtimeType}");
        // mlogD("dasdzz", "dataKey=${dataKey}---type=${dataKey.runtimeType}");
        // mlogD("dasdzz",
        //     "result.data[dataKey]=${result.data[dataKey]}---type=${result.data[dataKey].runtimeType}");
        // mlogD("dasdzz", "msgKey=${msgKey}---type=${msgKey.runtimeType}");
        // mlogD("dasdzz",
        //     "result.data[msgKey]=${result.data[msgKey]}---type=${result.data[msgKey].runtimeType}");
        onSuccessFunc.call(
          result.data[codeKey],
          result.data[dataKey],
          result.data[msgKey],
        );
      }
      if (onSuccessByResponse != null) {
        onSuccessByResponse.call(result.data[codeKey], result.data[dataKey],
            result.data[msgKey], result.data);
      }

      return Future.value(true);
    } else {
      // mlogD("_handResponseResultaaa", "result.data[codeKey]=${result.data[codeKey]}");
      if (HttpSetting.isJavaServer &&
          result.data[codeKey] ==
              HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath)) {
        //登录超时
        AppInfo.sendAppInfo(
            HttpSetting.getJavaRequestTimeOutCode(result.requestUrlPath));
      }
      setStatusError();
      // String errMsg =
      //     '${result.data[msgKey] ?? ""}${result.data['exception'] ?? ""}';
      onErrorFunc?.call(result.data[codeKey], result.data[msgKey] ?? "");
      onExError?.call(result.data[codeKey], result.data[msgKey] ?? "",
          result.error?.response?.data);
      return Future.value(false);
    }
  }

  getFormData(Map<String, dynamic> dataMap,
      [ListFormat format = ListFormat.multi]) {
    return FormData.fromMap(dataMap);
  }

  _handResponseDataStatus(dynamic data) {
    if (!openStatus) {
      return;
    }
    if (data == null) {
      setStatusEmpty();
      return;
    }
    if ((data is String) && data.isEmpty) {
      setStatusEmpty();
      return;
    }
    if ((data is Map) && data.isEmpty) {
      setStatusEmpty();
      return;
    }
  }

  /// 当前的页面状态,默认为idle,可在viewModel的构造方法中指定;
  ViewState? _viewState;

  /// ViewStateError
  ViewStateError? _viewStateError;

  bool openStatus = false;

  ViewState get viewState => _viewState ?? ViewState.idle;

  ViewState getViewState() {
    return _viewState ?? ViewState.idle;
  }

  set viewState(ViewState viewState) {
    _viewStateError = null;
    _viewState = viewState;
  }

  ViewStateError? get viewStateError => _viewStateError;

  bool get isLoading => viewState == ViewState.loading;

  bool get isIdle => viewState == ViewState.idle;

  bool get isEmpty => viewState == ViewState.empty;

  bool get isError => viewState == ViewState.error;

  bool get isErrorEmptyData => viewState == ViewState.errorEmpty;

  void setStatusIdle() {
    viewState = ViewState.idle;
  }

  void setStatusLoading() {
    if (openStatus) {
      viewState = ViewState.loading;
    }
  }

  void setStatusEmpty() {
    if (openStatus) {
      viewState = ViewState.empty;
    }
  }

  void setStatusError() {
    if (openStatus) {
      viewState = ViewState.error;
    }
  }

  void setStatusErrorEmptyData() {
    if (openStatus) {
      viewState = ViewState.errorEmpty;
    }
  }

  Future<bool> checkNetIsAvailable() async {
    return await NetUtil.netIsAvailable();
  }

  // /// [e]分类Error和Exception两种
  // void setError(e, stackTrace, {String? message}) {
  //   _viewStateError = ErrorParse.getViewStateError(e);
  //   printErrorStack(e, stackTrace);
  //   onError(viewStateError);
  // }
  //
  // void onError(ViewStateError? viewStateError) {}

  /// 显示错误消息
  showErrorMessage(String? message) {
    if (message != null) {
      Future.microtask(() {
        ToastUtil.showShort(message);
      });
    }
  }

  /// [e]为错误类型 :可能为 Error , Exception ,String
  /// [s]为堆栈信息
  printErrorStack(e, s) {
    debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----error-----↓↓↓↓↓↓↓↓↓↓----->
$e
<-----↑↑↑↑↑↑↑↑↑↑-----error-----↑↑↑↑↑↑↑↑↑↑----->''');
    if (s != null) debugPrint('''
<-----↓↓↓↓↓↓↓↓↓↓-----trace-----↓↓↓↓↓↓↓↓↓↓----->
$s
<-----↑↑↑↑↑↑↑↑↑↑-----trace-----↑↑↑↑↑↑↑↑↑↑----->
    ''');
  }
}
