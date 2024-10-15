import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';

import 'dio_api.dart';
import 'http_config.dart';
import 'http_response.dart';
import 'http_response_parse.dart';
import 'http_setting.dart';
import 'intercept.dart';
import 'transformer/http_transformer.dart';
import 'package:http_parser/http_parser.dart';

/**
 * 对AppDio进行一些配置，并对外提供一个请求单例
 * 以及一些基础的网络请求方法
 * 只对http返回的结果进行简单处理，没有对服务器自定义的具体数据类型进行解析处理
 * 只对外抛出一个服务器整体数据内容的泛型实体
 */
class DioHttpClient {
  late AppDio _appDio;

  factory DioHttpClient() => _singleton;

  static final DioHttpClient _singleton = DioHttpClient._();

  static DioHttpClient get instance => DioHttpClient();

  static late DioHttpClient _dioHttpClient;

  DioHttpClient get dioHttpClient => _dioHttpClient;

  DioHttpClient._() {
    HttpConfig dioConfig = HttpConfig(
      baseUrl: HttpSetting.RequestBaseUrl,
      connectTimeout: const Duration(milliseconds: HttpSetting.connectTimeout),
      sendTimeout: const Duration(milliseconds: HttpSetting.sendTimeout),
      interceptors: [AuthInterceptor()],
      receiveTimeout: const Duration(milliseconds: HttpSetting.receiveTimeout),
      // responseType: ResponseType.plain,
      validateStatus: (_) {
        // 不使用http状态码判断状态，使用来处理（适用于标准REST风格）
        return true;
      },
    );
    if (!AppSetting.isReleaseMode && AppSetting.openRequestLog) {
      dioConfig.interceptors?.add(LoggingInterceptor());
    }

    _appDio = AppDio(dioConfig: dioConfig);
  }

  Future<Response<T>> _getWithBody<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) {
    return _appDio.request<T>(
      path,
      data: data,
      queryParameters: queryParameters,
      options: options ??
          Options(
              method: 'GET', contentType: Headers.formUrlEncodedContentType),
      onReceiveProgress: onReceiveProgress,
      cancelToken: cancelToken,
    );
  }

  Future<MyHttpResponse> getByBody(String uri,
      {Map<String, dynamic>? queryParameters,
      dynamic data,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = HttpSetting.forceResponseToStringContentType
          ? await _getWithBody<String>(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
            )
          : await _getWithBody(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  Future<MyHttpResponse> get(String uri,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      // if (kDebugMode) {
      //   MLog.d("DioHttpClient", "接口请求地址：${uri}");
      //   MLog.d("DioHttpClient", "接口参数data-map ：${queryParameters}");
      // }
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.get<String>(
              uri,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.get(
              uri,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  Future<MyHttpResponse> post(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      // if (kDebugMode) {
      //   MLog.d("DioHttpClient", "接口请求地址：${uri}");
      //   MLog.d("DioHttpClient", "接口参数data-：${data.runtimeType}-${data}");
      //   MLog.d("DioHttpClient", "接口参数data-map ：${queryParameters}");
      // }
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.post<String>(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.post(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  //上传录音文件
  Future<MyHttpResponse> upLoadAudioFile(String url, String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer,
      String? fileKeyName}) async {
    // var upFile = path.substring(path.lastIndexOf("/") + 1, path.length);
    // var contentType = MediaType.parse("video/mp4");
    FormData formdata = FormData.fromMap({
      // fileKeyName ?? "file":
      //     await MultipartFile.fromFile(path, filename: upFile),
      fileKeyName ?? "file": MultipartFile.fromBytes(
        File(path).readAsBytesSync(),
        filename: path.split("/").last,
        // contentType: contentType,
      ),
    });
    try {
      // if (kDebugMode) {
      //   MLog.d("DioHttpClient", "接口请求地址：${url}");
      //   MLog.d("DioHttpClient", "接口参数file-：${path}");
      //   MLog.d("DioHttpClient", "接口参数data-：${formdata.toString()}");
      //   MLog.d("DioHttpClient", "接口参数data-map ：${queryParameters}");
      // }
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.post<String>(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(contentType: "multipart/form-data")
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.post(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(contentType: "multipart/form-data")
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, url);
    }
  }

  //上传图片
  Future<MyHttpResponse> upLoadFile(String url, String path,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer,
      String? fileKeyName,
      dynamic successCode}) async {
    var upFile = path.substring(path.lastIndexOf("/") + 1, path.length);
    FormData formdata = FormData.fromMap({
      fileKeyName ?? "file":
          await MultipartFile.fromFile(path, filename: upFile)
    });
    try {
      // if (kDebugMode) {
      //   MLog.d("DioHttpClient", "接口请求地址：${url}");
      //   MLog.d("DioHttpClient", "接口参数file-：${path}");
      //   MLog.d("DioHttpClient", "接口参数data-：${formdata.toString()}");
      //   MLog.d("DioHttpClient", "接口参数data-map ：${queryParameters}");
      // }
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.post<String>(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(
                      contentType: "multipart/form-data",
                      persistentConnection: true)
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.post(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(contentType: "multipart/form-data")
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
      MLog.d("DioHttpClient",
          "--------------upLoadFile handleResponse----------------");
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      MLog.d("DioHttpClient", "--------------upLoadFile Exception：${e}");
      return handleException(e, url);
    }
  }

  /**
   * 多图片上传
   * 可根据服务器接口的不同修改参数名：files
   */
  Future<MyHttpResponse> upLoadMulFile(String url, List<String> paths,
      {Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer,
      String? fileKeyName}) async {
    List<MultipartFile> filePaths = [];
    for (String path in paths) {
      var upFile = path.substring(path.lastIndexOf("/") + 1, path.length);
      filePaths.add(await MultipartFile.fromFile(path, filename: upFile));
    }
    FormData formdata = FormData.fromMap({fileKeyName ?? "files": filePaths});
    try {
      // if (kDebugMode) {
      //   MLog.d("DioHttpClient", "接口请求地址：${url}");
      //   for (int i = 0; i < paths.length; i++) {
      //     MLog.d("DioHttpClient", "接口参数file-：${paths[i]}---$i");
      //   }
      //   MLog.d("DioHttpClient", "接口参数data-：${formdata.toString()}");
      //   MLog.d("DioHttpClient", "接口参数data-map ：${queryParameters}");
      // }
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.post<String>(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(contentType: Headers.formUrlEncodedContentType)
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.post(
              url,
              data: formdata,
              queryParameters: queryParameters,
              options: options == null
                  ? Options(contentType: Headers.formUrlEncodedContentType)
                  : options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, url);
    }
  }

  Future<MyHttpResponse> patch(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      ProgressCallback? onSendProgress,
      ProgressCallback? onReceiveProgress,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.patch<String>(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            )
          : await _appDio.patch(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
              onSendProgress: onSendProgress,
              onReceiveProgress: onReceiveProgress,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  Future<MyHttpResponse> delete(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.delete<String>(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            )
          : await _appDio.delete(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  Future<MyHttpResponse> put(String uri,
      {data,
      Map<String, dynamic>? queryParameters,
      Options? options,
      CancelToken? cancelToken,
      HttpTransformer? httpTransformer}) async {
    try {
      var response = HttpSetting.forceResponseToStringContentType
          ? await _appDio.put<String>(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            )
          : await _appDio.put(
              uri,
              data: data,
              queryParameters: queryParameters,
              options: options,
              cancelToken: cancelToken,
            );
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, uri);
    }
  }

  // Future<Response> download(String urlPath, savePath,
  //     {ProgressCallback? onReceiveProgress,
  //     Map<String, dynamic>? queryParameters,
  //     CancelToken? cancelToken,
  //     bool deleteOnError = true,
  //     String lengthHeader = Headers.contentLengthHeader,
  //     data,
  //     Options? options,
  //     HttpTransformer? httpTransformer}) async {
  //   try {
  //     var response = await _appDio.download(
  //       urlPath,
  //       savePath,
  //       onReceiveProgress: onReceiveProgress,
  //       queryParameters: queryParameters,
  //       cancelToken: cancelToken,
  //       deleteOnError: deleteOnError,
  //       lengthHeader: lengthHeader,
  //       data: data,
  //       options: data,
  //     );
  //     return response;
  //   } catch (e) {
  //     throw e;
  //   }
  // }

  Future<MyHttpResponse> download(String urlPath, savePath,
      {ProgressCallback? onReceiveProgress,
      Map<String, dynamic>? queryParameters,
      CancelToken? cancelToken,
      bool deleteOnError = true,
      String lengthHeader = Headers.contentLengthHeader,
      data,
      Options? options,
      HttpTransformer? httpTransformer}) async {
    try {
      // var response = await _appDio.download(
      //   urlPath,
      //   savePath,
      //   onReceiveProgress: onReceiveProgress,
      //   // queryParameters: queryParameters,
      //   cancelToken: cancelToken,
      //   deleteOnError: deleteOnError,
      //   lengthHeader: lengthHeader,
      //   data: data,
      //   // options: options==null?Options(contentType: Headers.formUrlEncodedContentType):options,
      // );

      var response = await new Dio().download(
        urlPath,
        savePath,
        onReceiveProgress: onReceiveProgress,
        // queryParameters: queryParameters,
        cancelToken: cancelToken,
        deleteOnError: deleteOnError,
        lengthHeader: lengthHeader,
        data: data,
        // options: options==null?Options(contentType: Headers.formUrlEncodedContentType):options,
      );
      // mlogD("zcxzczxcaaaa", "下载结果=${response.statusCode}");
      return handleResponse(response, httpTransformer: httpTransformer);
    } on Exception catch (e) {
      return handleException(e, urlPath);
    }
  }
}
