import 'dart:convert';

import 'package:lib_sj/util/common_util/log_utils.dart';

import 'http_exceptions.dart';
import 'http_setting.dart';

/**
 * 根据服务器返回的数据格式进行解析的最外层数据样式
 */
class MyHttpResponse {
  dynamic? code;
  String? message;

  //当前解析数据的时间
  String? exe_time;
  dynamic? data;

  /**
   * 当前解析出的数据是Map类型还是Body类型
   */
  bool isMapType = false;

  /**
   * 接口返回的全部内容
   */
  String? resultContent;

  HttpException? error;

  /**
   * 请求地址的路径
   */
  String? requestUrlPath;

  MyHttpResponse.successMap(this.data, String? requestUrlPath) {
    this.requestUrlPath = requestUrlPath;
    if (this.data != null) {
      isMapType = true;
      if (this.data is String) {
        //转化成Map类型
        this.data = json.decode(this.data);
      }
      code = this.data![HttpSetting.getCodeKey(requestUrlPath)];
      //错误信息从服务器返回的数据内取出
      message = this.data![HttpSetting.getMsgKey(requestUrlPath)];
      //时间信息从服务器返回的数据内取出
      exe_time = this.data![HttpSetting.getExeTimeKey()];
    }
  }

  MyHttpResponse.successResponseBody(this.data, String? requestUrlPath) {
    this.requestUrlPath = requestUrlPath;
    if (this.data != null) {
      isMapType = false;
      code = this.data.statusCode;
      message = this.data.statusMessage;
      exe_time = DateTime.now().toString();
    }
  }

  @deprecated
  MyHttpResponse.success(this.resultContent, String? requestUrlPath) {
    this.requestUrlPath = requestUrlPath;
    if (this.resultContent != null) {
      // code=int.parse(this.resultContent![AppSetting.code.toString()]);
      // code = int.parse(this.resultContent![code]);
    }
  }

  MyHttpResponse.failure(String? requestUrlPath,{String? errorMsg, int? errorCode}) {
    this.requestUrlPath = requestUrlPath;
    this.error = BadRequestException(message: errorMsg, code: errorCode);
    this.code = errorCode;
  }

  MyHttpResponse.failureFormResponse(String? requestUrlPath,{dynamic? data}) {
    this.requestUrlPath = requestUrlPath;
    this.error = BadResponseException(data);
    this.code = -3;
  }

  MyHttpResponse.failureFromError(String? requestUrlPath,[HttpException? error]) {
    this.requestUrlPath = requestUrlPath;
    this.error = error ?? UnknownException();
    this.code = error?.code ?? -2;
  }



}
