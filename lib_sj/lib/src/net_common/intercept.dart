import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' show MapExtension;

import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'http_setting.dart';

const String DIO_NET_TAG = "NET_REQUEST";

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // mlogD(DIO_NET_TAG,
    // "onRequest--------------time=${DateTime.now().millisecondsSinceEpoch}-----------------options=${options.headers}");
    if (HttpSetting.requestCommonHeaderMap != null) {
      HttpSetting.requestCommonHeaderMap!.forEach((key, value) {
        options.headers.addIf(!options.headers.containsKey(key), key, value);
      });
      // options.headers.addAll(HttpSetting.requestCommonHeaderMap!);
    }
    Map<String, dynamic>? dynamicHeaderMap =
        HttpSetting.requestDynamicHeaderMap?.call(options.path);
    if (dynamicHeaderMap != null) {
      dynamicHeaderMap.forEach((key, value) {
        options.headers.addIf(!options.headers.containsKey(key), key, value);
      });
    }

    // final String? userToken = SpUtil.getString(AppSetting.userToken);
    // if (userToken != null && userToken.isNotEmpty) {
    //   options.headers['usertoken'] = userToken;
    // }
    //
    // options.headers['version'] =
    //     '${Platform.operatingSystem}_${AppInfo.getVersionCode()}';
    //
    // options.headers['accesstoken'] = AppSetting.accessToken;
    // options.headers['APP_VERSION'] = AppInfo.getVersionCode();
    // options.headers['APP_CLIENT_TYPE'] = DeviceUtils.isAndroid ? "Android" : "IOS";
    // if (AppInfo.otherHeaderData != null) {
    //   options.headers[AppInfo.USER_TOKEN_KEY] = AppInfo.otherHeaderData;
    // }
    // if (AppInfo.commonHeaderData != null) {
    //   options.headers.addAll(AppInfo.commonHeaderData!);
    // }

    // if (!AppSetting.isReleaseMode && AppSetting.openRequestLog) {
    //   MLog.d("NET_REQUEST",
    //       "----start--------header-------------time=${DateTime.now().millisecondsSinceEpoch}-------------${options.path}---------------");
    //   options.headers.forEach((key, value) {
    //     MLog.d("NET_REQUEST", "key:${key}---value:${value}");
    //   });
    //   MLog.d("NET_REQUEST",
    //       "-------end------header-----------------------------------------");
    // }

    // if (!kIsWeb) {
    //   // https://developer.github.com/v3/#user-agent-required
    //   options.headers['User-Agent'] = 'Mozilla/5.0';
    // }
    // MLog.e("NET_REQUEST", "header-----------------------------------------");
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    super.onResponse(response, handler);
    // mlogD(
    //     "zczxczxaaaaa", "onResponse=${response.statusCode}---${response.data}");
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    super.onError(err, handler);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    MLog.d(DIO_NET_TAG, '----------Start----------${DateTime.now()}----------');
    if (options.queryParameters.isEmpty) {
      // MLog.d(DIO_NET_TAG, "RequestUrl: ${options.baseUrl}${options.path}}");
      MLog.d(DIO_NET_TAG, "RequestUrl: ${options.path}");
    } else {
      MLog.d(
          DIO_NET_TAG,
          'RequestUrl: ' +
              // options.baseUrl +
              options.path +
              '?' +
              Transformer.urlEncodeMap(options.queryParameters));
    }
    MLog.d(DIO_NET_TAG, 'RequestMethod: ${options.method}');
    MLog.d(DIO_NET_TAG, 'RequestHeaders:${options.headers}');
    MLog.d(DIO_NET_TAG, 'RequestContentType: ${options.contentType}');
    MLog.d(DIO_NET_TAG, 'RequestData: ${options.data.toString()}');
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      MLog.d(DIO_NET_TAG, 'ResponseCode: ${response.statusCode}');
    } else {
      MLog.d(DIO_NET_TAG, 'ResponseCode: ${response.statusCode}');
    }
    if (kDebugMode) {
      var jsonValue = json.encode(response.data);
      MLog.d(DIO_NET_TAG, 'onResponse:${response.realUri.path}');
      MLog.d(DIO_NET_TAG,
          'jsonValue:$jsonValue---数据类型：${response.data.runtimeType}');
    }

    // 输出结果
    // MLog.json(DIO_NET_TAG, response.data);
    MLog.d(DIO_NET_TAG, '----------End: ------${DateTime.now()} ----------');
    super.onResponse(response, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (!AppSetting.isReleaseMode) {
      MLog.d(DIO_NET_TAG, '----------Error------start------------------------');
      MLog.d(DIO_NET_TAG,
          '----------Error-----err.realUri:${err.requestOptions.path}');
      // MLog.d(DIO_NET_TAG, '----------Error-----err.data:${err.requestOptions.re}');
      MLog.d(DIO_NET_TAG, '----------Error-----err.error:${err.error}');
      MLog.d(DIO_NET_TAG, '----------Error-----err.message:${err.message}');
      MLog.d(DIO_NET_TAG,
          '----------Error-----err.response?.data:${err.response?.data}');
      MLog.d(DIO_NET_TAG, '----------Error------end-------------------------');
    }
    super.onError(err, handler);
  }
}
