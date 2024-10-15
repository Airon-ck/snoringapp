import 'package:flutter/foundation.dart';
import 'package:lib_sj/function/value_change_listener_func.dart';

class HttpSetting {
  /**
   * 是否是方法注入方式传递常用参数，如key
   * 请求过程中的各种key注入的方式，false:直接字段注入，true:使用方法注入，可随时在app层根据业务逻辑即时进行调整
   */
  static bool funcInjectionType = true;

  /**
   * 接口请求地址
   */
  static const String RequestBaseUrl = '';

  /**
   * 是否强制接口返回的数据用String格式进行处理解析
   * 用来防止接口返回数据时，Response里面的Header里面的Content-Type乱七八糟时，做一个统一性的处理
   */
  static const bool forceResponseToStringContentType = true;

  /**
   * 网络请求参数
   */
  static const int connectTimeout = 60 * 1000;
  static const int receiveTimeout = 30 * 60 * 1000;
  static const int sendTimeout = 30 * 60 * 1000;

  static String _dataKey = 'data';
  static String _messageKey = 'msg';
  static String _codeKey = 'code';
  static String _rowCountKey = 'rowCount';
  static String _pageCountKey = 'pageCount';
  static String _totalCountKey = 'totalCount';
  static String _exe_timeKey = 'exe_time';
  static dynamic _javaReqSuccessCode = 'A00000';
  static String _javaTimeOutCodeKey = 'A00003';

  static const int HttpRequstCancelInt = -997;
  static const String HttpRequstCancelString = "B000010";

  static getCancleCode() {
    return HttpSetting.isJavaServer
        ? HttpSetting.HttpRequstCancelString
        : HttpSetting.HttpRequstCancelInt;
  }

  /**
   * 对外提供配置服务器返回数据内的字段的key
   */
  static setJavaResponseKey({
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
    _dataKey = dataKey;
    _messageKey = msgKey;
    _codeKey = codeKey;
    if (rowCountKey != null) {
      _rowCountKey = rowCountKey;
    }
    if (pageCountKey != null) {
      _pageCountKey = pageCountKey;
    }
    if (totalCountKey != null) {
      _totalCountKey = totalCountKey;
    }
    if (exe_timeKey != null) {
      _exe_timeKey = exe_timeKey;
    }
    if (javaReqSuccessCode != null) {
      _javaReqSuccessCode = javaReqSuccessCode;
    }
    if (javaTimeOutCodeKey != null) {
      _javaTimeOutCodeKey = javaTimeOutCodeKey;
    }
  }

  //如果要使用“Content-Type", "application/json; charset=UTF-8"，则改为true,一般公司JAVA api时使用
  static const bool isJavaServer = true;

  static Function _myDataKeyFunc = _getDefaultCommonRequestDataKey;
  static Function _myCodeKeyFunc = _getDefaultCommonRequestCodeCode;
  static Function _myMessageKeyFunc = _getDefaultCommonRequestMessageCode;
  static Function _myExeTimeKeyFunc = _getDefaultCommonRequestExeTimeCode;
  static Function _myRowCountKeyFunc = _getDefaultCommonRequestRowCountCode;
  static Function _myPageCountKeyFunc = _getDefaultCommonRequestPageCountCode;
  static Function _myTotalCountKeyFunc = _getDefaultCommonRequestTotalCountCode;

  static Function _myJavaRequestSuccessCodeFunc = _getJavaCommonRequestSuccessCode;
  static Function _myJavaRequestTimeOutCodeFunc = _getJavaCommonRequestTimeOutCode;
  static Function _handResponseExceptionDesc = _getHandMyResponseExcetionDesc;

  /**
   * 对外提供用于随时修改服务器返回值的一些固定配置参数
   * javaRequestSuccessCodeFun:服务器请求成功时返回的code码
   * javaRequestTimeOutCodeFun：服务器请求超时时返回的code码
   * javaRequestMessageKeyFun：服务器请求失败时返回的信息内容对应的key
   */
  static initJavaRequestResultParamer(
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
    _myJavaRequestSuccessCodeFunc = javaRequestSuccessCodeFun;
    if (javaRequestTimeOutCodeFun != null) {
      _myJavaRequestTimeOutCodeFunc = javaRequestTimeOutCodeFun;
    }
    if (javaRequestDataKeyFun != null) {
      _myDataKeyFunc = javaRequestDataKeyFun;
    }
    if (javaRequestCodeKeyFun != null) {
      _myCodeKeyFunc = javaRequestCodeKeyFun;
    }
    if (javaRequestMessageKeyFun != null) {
      _myMessageKeyFunc = javaRequestMessageKeyFun;
    }
    if (javaRequestExeTimeKeyFun != null) {
      _myExeTimeKeyFunc = javaRequestExeTimeKeyFun;
    }
    if (javaRequestRowCountKeyFun != null) {
      _myRowCountKeyFunc = javaRequestRowCountKeyFun;
    }
    if (javaRequestPageCountKeyFun != null) {
      _myPageCountKeyFunc = javaRequestPageCountKeyFun;
    }
    if (javaRequestTotalCountKeyFun != null) {
      _myTotalCountKeyFunc = javaRequestTotalCountKeyFun;
    }
  }

  static _getJavaCommonRequestSuccessCode(String? urlPath) {
    return 'A00000';
  }

  static _getJavaCommonRequestTimeOutCode(String? urlPath) {
    return 'A00003';
  }

  static _getDefaultCommonRequestDataKey(String? urlPath) {
    return 'data';
  }

  static _getDefaultCommonRequestCodeCode(String? urlPath) {
    return 'code';
  }

  static _getDefaultCommonRequestMessageCode(String? urlPath) {
    return 'message';
  }

  static _getDefaultCommonRequestExeTimeCode() {
    return 'exe_time';
  }

  static _getDefaultCommonRequestRowCountCode() {
    return 'rowCount';
  }

  static _getDefaultCommonRequestPageCountCode() {
    return 'pageCount';
  }

  static _getDefaultCommonRequestTotalCountCode() {
    return 'totalCount';
  }

  static _getHandMyResponseExcetionDesc(Exception exception,bool isSocketException,dynamic statusCode) {
    return null;
  }


  static initHandMyResponseExcetionDescListener(Value3ChangeReturnListener<Exception,bool,dynamic,dynamic> responseExceptionDesc) {
    _handResponseExceptionDesc = responseExceptionDesc;
  }

  /**
   * 用于监听http全部状态码的回调
   */
  static ValueChanged<int?>? responseStatusCodeListener;

  static initResponseStatusCodeListener(ValueChanged<int?>? statusCodeListener) {
    responseStatusCodeListener = statusCodeListener;
  }

  /**
   * 用于监听服务器返回的全部状态码的回调
   */
  static ValueChanged<dynamic?>? responseJavaCodeListener;

  static initResponseJavaCodeListener(ValueChanged<dynamic?>? javaCodeListener) {
    responseJavaCodeListener = javaCodeListener;
  }

  /**
   * 网络请求时携带的固定不变的header数据
   */
  static Map<String, dynamic>? requestCommonHeaderMap;

  static initRequestCommonHeaderMap(Map<String, dynamic>? commonHeaderMap) {
    requestCommonHeaderMap = commonHeaderMap;
  }

  /**
   * 网络请求时携带的有业务逻辑的header数据
   */
  static ValueInitFunc<Map<String, dynamic>>? requestDynamicHeaderMap;

  static initRequestDynamicHeaderMap(ValueInitFunc<Map<String, dynamic>>? function) {
    requestDynamicHeaderMap = function;
  }

  /**
   * 网络请求的基本请求地址
   */
  static String BASE_URL = "";

  static initHttpBaseUrl(String url, {bool reqFuncInjectionType = false}) {
    BASE_URL = url;
    funcInjectionType = reqFuncInjectionType;
  }

  static getDataKey(String? urlPath) {
    return !funcInjectionType ? _dataKey : _myDataKeyFunc.call(urlPath);
  }

  static String getCodeKey(String? urlPath) {
    return !funcInjectionType ? _codeKey : _myCodeKeyFunc.call(urlPath);
  }

  static getMsgKey(String? urlPath) {
    return !funcInjectionType ? _messageKey : _myMessageKeyFunc.call(urlPath);
  }

  static getExeTimeKey() {
    return !funcInjectionType ? _exe_timeKey : _myExeTimeKeyFunc.call();
  }

  static getRowCountKey() {
    return !funcInjectionType ? _rowCountKey : _myRowCountKeyFunc.call();
  }

  static getPageCountKey() {
    return !funcInjectionType ? _pageCountKey : _myPageCountKeyFunc.call();
  }

  static getTotalCountKey() {
    return !funcInjectionType ? _totalCountKey : _myTotalCountKeyFunc.call();
  }

  static getJavaRequestSuccessCode(String? urlPath) {
    return !funcInjectionType ? _javaReqSuccessCode : _myJavaRequestSuccessCodeFunc.call(urlPath);
  }

  static getJavaRequestTimeOutCode(String? urlPath) {
    return !funcInjectionType ? _javaTimeOutCodeKey : _myJavaRequestTimeOutCodeFunc.call(urlPath);
  }

  static getMyResponseExceptionDesc(Exception exception,bool isSocketException,dynamic statusCode){
    return _handResponseExceptionDesc.call(exception,isSocketException,statusCode);
  }

}
