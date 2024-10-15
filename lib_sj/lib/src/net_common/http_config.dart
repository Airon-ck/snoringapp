import 'package:dio/dio.dart';

import 'http_setting.dart';

/**
 * dio 配置项
 */

class HttpConfig {
  final String? baseUrl;
  final String? proxy;
  final String? cookiesPath;
  final List<Interceptor>? interceptors;
  final Duration connectTimeout;
  final Duration sendTimeout;
  final Duration receiveTimeout;
  final ValidateStatus? validateStatus;

  HttpConfig({
    this.baseUrl,
    this.proxy,
    this.cookiesPath,
    this.interceptors,
    this.connectTimeout =const  Duration(milliseconds: HttpSetting.connectTimeout),
    this.sendTimeout = const  Duration(milliseconds: HttpSetting.sendTimeout),
    this.receiveTimeout = const  Duration(milliseconds: HttpSetting.receiveTimeout),
    this.validateStatus,
  });
}
