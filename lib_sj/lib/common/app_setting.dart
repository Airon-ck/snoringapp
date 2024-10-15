import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/common/app_base.dart';
import 'package:lib_sj/function/value_change_listener_func.dart';
import 'package:lib_sj/src/net_common/http_setting.dart';

import '../util/sp_util.dart';

class AppSetting {
  // App运行在Release环境时，inProduction为true；当App运行在Debug和Profile环境时，inProduction为false
  static const bool isReleaseMode = kReleaseMode;
  // static const bool isReleaseMode = true;
  static const String versionCodeKey = 'versionCode';
  static const String versionKey = 'version';

  static String DefaultPicHolder = '';

  static String locale = "zh_CN";

  /**
   * 在debug模式下是否展示请求时的log
   */
  static bool openRequestLog = true;

  /**
   * 图片加载时的前缀
   * 举例：ImageUtils如果传入一个name后，会自动变为：picPrefix+name
   */
  static String picPrefix = "";

  /**
   * 网络图片加载失败时的错误占位符
   */
  static LoadingErrorWidgetBuilder? picErrorHolder;

  /**
   * 设置lib_sj使用的语言包
   */
  static initLocale(String currentLocale) {
    locale = currentLocale;
  }

  /**
   * 框架层的初始化
   */
  static init() async {
    await SpUtil.getInstance();
    await AppInfo.init();
  }

  /**
   * 配置默认图片
   * 目前仅在SjLoadImage中有使用
   */
  static initDefaultPicHolder(String picName) {
    DefaultPicHolder = picName;
  }

  /**
   * 对外提供用于随时修改服务器返回值的一些固定配置参数
   */
  static initRequestResultParamer(
    Function javaRequestSuccessCodeFun, {
    Function? javaRequestTimeOutCodeFun,
    Function? javaRequestDataKeyFun,
    Function? javaRequestCodeKeyFun,
    Function? javaRequestMessageKeyFun,
    Function? javaRequestExeTimeKeyFun,
    Function? javaRequestRowCountKeyFun,
    Function? javaRequestPageCountKeyFun,
    Function? javaRequestTotalCountKeyFun,
  }) {
    HttpSetting.initJavaRequestResultParamer(
      javaRequestSuccessCodeFun,
      javaRequestTimeOutCodeFun: javaRequestTimeOutCodeFun,
      javaRequestDataKeyFun: javaRequestDataKeyFun,
      javaRequestCodeKeyFun: javaRequestCodeKeyFun,
      javaRequestMessageKeyFun: javaRequestMessageKeyFun,
      javaRequestExeTimeKeyFun: javaRequestExeTimeKeyFun,
      javaRequestRowCountKeyFun: javaRequestRowCountKeyFun,
      javaRequestPageCountKeyFun: javaRequestPageCountKeyFun,
      javaRequestTotalCountKeyFun: javaRequestTotalCountKeyFun,
    );
  }

  /**
   * 对外提供配置服务器返回数据内的data对应的key
   */
  static setResponseKey({
    required String dataKey,
    required String codeKey,
    required String msgKey,
    String? rowCountKey,
    String? pageCountKey,
    String? totalCountKey,
    String? exe_timeKey,
    dynamic? javaReqSuccessCode,
    String? javaTimeOutCodeKey,
  }) {
    HttpSetting.setJavaResponseKey(
        dataKey: dataKey,
        codeKey: codeKey,
        msgKey: msgKey,
        rowCountKey: rowCountKey,
        pageCountKey: pageCountKey,
        totalCountKey: totalCountKey,
        exe_timeKey: exe_timeKey,
        javaReqSuccessCode: javaReqSuccessCode,
        javaTimeOutCodeKey: javaTimeOutCodeKey);
  }

  static getMessageKey(String? urlPath) {
    return HttpSetting.getMsgKey(urlPath);
  }

  /**
   * 对外提供用于监听http全部状态码的回调
   */
  static initResponseStatusCodeListener(
      ValueChanged<int?>? statusCodeListener) {
    HttpSetting.initResponseStatusCodeListener(statusCodeListener);
  }

  /**
   * 对外提供用于监听返回异常时的文案处理
   */
  static initHandMyResponseExcetionDescListener(
      Value3ChangeReturnListener<Exception, bool, dynamic, dynamic>
          responseExceptionDesc) {
    HttpSetting.initHandMyResponseExcetionDescListener(responseExceptionDesc);
  }

  /**
   * 对外提供用于监听服务器自定义的状态码的回调
   */
  static initResponseJavaCodeListener(
      ValueChanged<dynamic?>? javaCodeListener) {
    HttpSetting.initResponseJavaCodeListener(javaCodeListener);
  }

  /**
   * 网络请求时携带的固定不变的header数据
   */
  static initRequestCommonHeaderMap(Map<String, dynamic>? commonHeaderMap) {
    HttpSetting.initRequestCommonHeaderMap(commonHeaderMap);
  }

  /**
   * 网络请求时设置携带有业务逻辑的header数据
   */
  static initRequestDynamicHeaderMap(
      ValueInitFunc<Map<String, dynamic>>? function) {
    HttpSetting.initRequestDynamicHeaderMap(function);
  }

  /**
   * 对外初始化网络请求的基本http url
   */
  static initHttpBaseUrl(String url, {bool reqFuncInjectionType = false}) {
    HttpSetting.initHttpBaseUrl(url,
        reqFuncInjectionType: reqFuncInjectionType);
  }

  /**
   * 监听页面跳转
   * 当前展示的页面
   */
  static Value2ChangeListener<String?, String>? listenerPageResult;

  /**
   * 监听页面跳转
   * 当前关闭的页面
   */
  static Value2ChangeListener<String?, String>? listenerClosePageResult;

  /**
   * 当app的navigatorObservers使用了MyRoutingObservers的观察者后才会生效
   */
  static initPageChangeListener(
      Value2ChangeListener<String?, String?> listener) {
    listenerPageResult = listener;
  }

  /**
   * 当app的navigatorObservers使用了MyRoutingObservers的观察者后才会生效
   */
  static initClosePageChangeListener(
      Value2ChangeListener<String?, String?> listener) {
    listenerClosePageResult = listener;
  }

  /**
   * 应用Toast的文字大小
   */
  static double toastTextSize = 14.0;

  static getCancleCode() {
    return HttpSetting.isJavaServer
        ? HttpSetting.HttpRequstCancelString
        : HttpSetting.HttpRequstCancelInt;
  }
}
