import 'package:dio/dio.dart';

class HttpException implements Exception {
  final String? _message;

  /**
   * 保存DioError里面的response
   */
  final dynamic response;

  String get message => _message ?? this.runtimeType.toString();

  final int? _code;

  int get code => _code ?? -1;

  HttpException([this._message, this._code, this.response]);

  String toString() {
    return "code:$code--message=$message---response:${(response is DioError)?((response as DioError).error):response}";
  }
}

/// 客户端请求错误
class BadRequestException extends HttpException {
  BadRequestException({String? message, int? code, dynamic response})
      : super(message, code, response);
}

/// 服务端响应错误
class BadServiceException extends HttpException {
  BadServiceException({String? message, int? code, dynamic response})
      : super(message, code, response);
}

class UnknownException extends HttpException {
  UnknownException([String? message, dynamic response]) : super(message, null, response);
}

class CancelException extends HttpException {
  CancelException([String? message, dynamic response]) : super(message, null, response);
}

class BadCertificateException extends HttpException {
  BadCertificateException([String? message, dynamic response])
      : super(message, null, response);
}

class NetworkException extends HttpException {
  NetworkException({String? message, int? code,dynamic response})
      : super(message, code, response);
}

/// 401
class UnauthorisedException extends HttpException {
  UnauthorisedException({String? message, int? code = 401, dynamic response})
      : super(message, code, response);
}

class BadResponseException extends HttpException {
  dynamic? data;

  BadResponseException([this.data,dynamic response]) : super("",null,response);
}
