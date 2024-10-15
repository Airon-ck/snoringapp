// 成功回调

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';

import 'http_response.dart';
import 'http_setting.dart';
import 'transformer/default_http_transformer.dart';
import 'http_exceptions.dart';
import 'transformer/http_transformer.dart';

/**
 * 将dio请求结果Response转化成自定义的HttpResponse
 */
MyHttpResponse handleResponse(Response? response, {HttpTransformer? httpTransformer}) {
  // mlogD("xzcasdxzczxc", "测试阿=${response}");
  // 返回值异常
  if (response == null) {
    return MyHttpResponse.failureFromError(response?.realUri.path);
  }

  try {
    //向外部传递http请求的所有的状态码
    HttpSetting.responseStatusCodeListener?.call(response.statusCode);
  } on Exception catch (e) {
    mlogE("handleResponse", "exception=${e.toString()}");
  }

  // 服务器鉴权失效
  if (_isTokenTimeout(response.statusCode)) {
    return MyHttpResponse.failureFromError(
        response.realUri.path,
        UnauthorisedException(
            message: HttpSetting.getMyResponseExceptionDesc(Exception(), false,response.statusCode) ??
                getSjTextByKey('no_permissions'),
            code: response.statusCode));
  }
  // 接口调用成功
  if (_isRequestSuccess(response.statusCode)) {
    httpTransformer ??= DefaultHttpTransformer.getInstance();
    return httpTransformer.parse(response);
  } else {
    // 接口调用失败
    return MyHttpResponse.failure(response.realUri.path,
        errorMsg: response.statusMessage, errorCode: response.statusCode);
  }
}

MyHttpResponse handleException(Exception exception, String urlPath) {
  if (!AppSetting.isReleaseMode && (exception is DioError)) {
    mlogD("_handResponseResult",
        "-----------------------------start------------------------------------");
    mlogD("_handResponseResult", "Exception--urlPath=${urlPath}");
    mlogD("_handResponseResult", "Exception--e.error=${exception.error}");
    mlogD("_handResponseResult", "Exception--e.message=${exception.message}");
    mlogD("_handResponseResult", "Exception--e.type=${exception.type}");
    mlogD("_handResponseResult",
        "-----------------------------end------------------------------------");
  }
  var parseException = _parseException(exception);
  return MyHttpResponse.failureFromError(urlPath, parseException);
}

/// 鉴权失败
bool _isTokenTimeout(int? code) {
  return code == 401;
}

/// 请求成功
bool _isRequestSuccess(int? statusCode) {
  return (statusCode != null && statusCode >= 200 && statusCode < 300);
}

HttpException _parseException(Exception error) {
  // mlogD("_parseException", "首次解析Exceptionerror=${error}---type=${error.runtimeType}");
  // mlogD("_parseException", "error is DioError===${error is DioError}");
  // mlogD("_handResponseResult", "error is DioError===${error is DioError}");
  if (error is DioError) {
    // mlogD("_parseException", "111111111111111111111111111111==${error.error.runtimeType}");
    if (error.error is SocketException) {
      // mlogD("_parseException", "网络不可用拦截了");
      // mlogD("_handResponseResult", "网络不可用拦截了");
      return NetworkException(
          message: HttpSetting.getMyResponseExceptionDesc(error, true,error.response?.statusCode) ??
              getSjTextByKey('network_unavailable'),response: error.response??error);
    }
    // mlogD("_parseException", "error=${error}---type=${error.type}-message=${error.message}---innererror=${error.error.runtimeType}");
    switch (error.type) {
      case DioErrorType.connectionTimeout:
      case DioErrorType.receiveTimeout:
      case DioErrorType.sendTimeout:
        return NetworkException(
            message: HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ?? error.message,
            response: error);
      case DioErrorType.badCertificate:
        return BadCertificateException(
            HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ?? error.message, error);
      case DioErrorType.cancel:
        return CancelException(
            HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ?? error.message, error);
      case DioErrorType.badResponse:
        try {
          int? errCode = error.response?.statusCode;
          switch (errCode) {
            case 400:
              return BadRequestException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('request_error'),
                  code: errCode,
                  response: error.response??error);
            case 401:
              return UnauthorisedException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('no_permissions'),
                  code: errCode,
                  response: error.response??error);
            case 403:
              return BadRequestException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('server_refused_to_execute'),
                  code: errCode,
                  response: error.response??error);
            case 404:
              return BadRequestException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('unable_to_connect_to_server'),
                  code: errCode,
                  response: error.response??error);
            case 405:
              return BadRequestException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('request_method_is_prohibited'),
                  code: errCode,
                  response: error.response??error);
            case 500:
              return BadServiceException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('server_internal_error'),
                  code: errCode,
                  response: error.response??error);
            case 502:
              return BadServiceException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('invalid_request'),
                  code: errCode,
                  response: error.response??error);
            case 503:
              return BadServiceException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('server_bad'),
                  code: errCode,
                  response: error.response??error);
            case 505:
              return UnauthorisedException(
                  message: HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      getSjTextByKey('HTTP_protocol_request_not_supported'),
                  code: errCode,
                  response: error.response??error);
            default:
              return UnknownException(
                  HttpSetting.getMyResponseExceptionDesc(error, false,errCode) ??
                      error.message ??
                      getSjTextByKey('failed_to_obtain_data'),
                  error);
          }
        } on Exception catch (_) {
          return UnknownException(
              HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ?? error.message, error);
        }

      case DioErrorType.unknown:
        if (error.error is SocketException) {
          return NetworkException(
              message:
                  HttpSetting.getMyResponseExceptionDesc(error, true,error.response?.statusCode) ?? error.error.toString(),
              response: error.response??error);
        } else {
          // return UnknownException(error.error.toString());
          if (AppSetting.isReleaseMode) {
            return UnknownException(
                HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ??
                    getSjTextByKey('unknown_error'),
                error);
          } else {
            return UnknownException(error.error.toString(), error);
          }
        }
      default:
        return UnknownException(
            HttpSetting.getMyResponseExceptionDesc(error, false,error.response?.statusCode) ?? error.message, error);
    }
  } else if (error is SocketException) {
    return NetworkException(
        message: HttpSetting.getMyResponseExceptionDesc(error, true,error.osError?.errorCode) ??
            getSjTextByKey('network_unavailable'),
        response: error);
  } else {
    return UnknownException(
        HttpSetting.getMyResponseExceptionDesc(error, false,error.toString()) ?? error.toString(), error);
  }
}
