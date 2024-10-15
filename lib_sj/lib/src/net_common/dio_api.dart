
import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

// import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';

import 'http_config.dart';
import 'http_setting.dart';

/**
 * Dio基础类的封装
 */
class AppDio with DioMixin implements Dio {
  AppDio({BaseOptions? options, HttpConfig? dioConfig}) {
    options ??= BaseOptions(
      baseUrl: dioConfig?.baseUrl ?? "",
      contentType: !HttpSetting.isJavaServer ? null : Headers.jsonContentType,
      connectTimeout: dioConfig?.connectTimeout,
      sendTimeout: dioConfig?.sendTimeout,
      receiveTimeout: dioConfig?.receiveTimeout,
    );
    this.options = options;
    if(dioConfig!=null && dioConfig.interceptors!=null){
      interceptors.addAll(dioConfig.interceptors!);
    }

    // 缓存使用,如果需要可打开注释
    // final cacheOptions = CacheOptions(
    //   store: MemCacheStore(),
    //   // 除了401和403之外都进行缓存
    //   hitCacheOnErrorExcept: [401, 403],
    //   // 缓存的时间。默认为7天
    //   maxStale: const Duration(days: 7),
    // );
    // interceptors.add(DioCacheInterceptor(options: cacheOptions));

    // Cookie管理
    // if (dioConfig?.cookiesPath?.isNotEmpty ?? false) {
    //   interceptors
    //       .add(CookieManager(PersistCookieJar(storage: FileStorage(dioConfig!.cookiesPath))));
    // }

    if (kDebugMode) {
      // interceptors.add(LogInterceptor(
      //     responseBody: true,
      //     error: true,
      //     requestHeader: false,
      //     responseHeader: false,
      //     request: false,
      //     requestBody: true));
    }
    MLog.e("dadada", "----------${dioConfig?.interceptors?.isNotEmpty}");
    // if (dioConfig?.interceptors?.isNotEmpty ?? false) {
    //   interceptors.addAll(interceptors);
    // }

    // proxy使用配置
    httpClientAdapter = DefaultHttpClientAdapter();
    // if (dioConfig?.proxy?.isNotEmpty ?? false) {
    //   setProxy(dioConfig!.proxy!);
    // }
  }

  setProxy(String proxy) {
    (httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      // config the http client
      client.findProxy = (uri) {
        // proxy all request to localhost:8888
        return "PROXY $proxy";
      };
      // you can also create a HttpClient to dio
      // return HttpClient();
    };
  }

  @override
  Future<Response> download(
      String urlPath,
      dynamic savePath, {
        ProgressCallback? onReceiveProgress,
        Map<String, dynamic>? queryParameters,
        CancelToken? cancelToken,
        bool deleteOnError = true,
        String lengthHeader = Headers.contentLengthHeader,
        Object? data,
        Options? options,
      }) async {
    // We set the `responseType` to [ResponseType.STREAM] to retrieve the
    // response stream.
    options ??= DioMixin.checkOptions('GET', options);
    mlogD("zcxzczxcaaaa", "options=${options.headers}");
    // Receive data with stream.
    options.responseType = ResponseType.stream;
    Response<ResponseBody> response;
    try {
      response = await request<ResponseBody>(
        urlPath,
        data: data,
        options: options,
        queryParameters: queryParameters,
        cancelToken: cancelToken ?? CancelToken(),
      );
    } on DioError catch (e) {
      if (e.type == DioErrorType.badResponse) {
        if (e.response!.requestOptions.receiveDataWhenStatusError == true) {
          final res = await transformer.transformResponse(
            e.response!.requestOptions..responseType = ResponseType.json,
            e.response!.data as ResponseBody,
          );
          e.response!.data = res;
        } else {
          e.response!.data = null;
        }
      }
      rethrow;
    }
    final File file;
    if (savePath is FutureOr<String> Function(Headers)) {
      // Add real Uri and redirect information to headers.
      response.headers
        ..add('redirects', response.redirects.length.toString())
        ..add('uri', response.realUri.toString());
      file = File(await savePath(response.headers));
    } else if (savePath is String) {
      file = File(savePath);
    } else {
      throw ArgumentError.value(
        savePath.runtimeType,
        'savePath',
        'The type must be `String` or `FutureOr<String> Function(Headers)`.',
      );
    }

    // If the directory (or file) doesn't exist yet, the entire method fails.
    file.createSync(recursive: true);

    // Shouldn't call file.writeAsBytesSync(list, flush: flush),
    // because it can write all bytes by once. Consider that the file is
    // a very big size (up to 1 Gigabytes), it will be expensive in memory.
    RandomAccessFile raf = file.openSync(mode: FileMode.write);

    // Create a Completer to notify the success/error state.
    final completer = Completer<Response>();
    Future<Response> future = completer.future;
    int received = 0;

    // Stream<Uint8List>
    final stream = response.data!.stream;
    bool compressed = false;
    int total = 0;
    final contentEncoding = response.headers.value(
      Headers.contentEncodingHeader,
    );
    if (contentEncoding != null) {
      compressed = ['gzip', 'deflate', 'compress'].contains(contentEncoding);
    }
    if (lengthHeader == Headers.contentLengthHeader && compressed) {
      total = -1;
    } else {
      total = int.parse(response.headers.value(lengthHeader) ?? '-1');
    }

    Future<void>? asyncWrite;
    bool closed = false;
    Future<void> closeAndDelete() async {
      if (!closed) {
        closed = true;
        await asyncWrite;
        await raf.close();
        if (deleteOnError && file.existsSync()) {
          await file.delete();
        }
      }
    }

    late StreamSubscription subscription;
    subscription = stream.listen(
          (data) {
        subscription.pause();
        // Write file asynchronously
        asyncWrite = raf.writeFrom(data).then((result) {
          // Notify progress
          received += data.length;
          onReceiveProgress?.call(received, total);
          raf = result;
          if (cancelToken == null || !cancelToken.isCancelled) {
            subscription.resume();
          }
        }).catchError((dynamic e, StackTrace s) async {
          try {
            await subscription.cancel();
          } finally {
            completer.completeError(
              DioMixin.assureDioError(e, response.requestOptions, s),
            );
          }
        });
      },
      onDone: () async {
        try {
          await asyncWrite;
          closed = true;
          await raf.close();
          completer.complete(response);
        } catch (e, s) {
          completer.completeError(
            DioMixin.assureDioError(e, response.requestOptions, s),
          );
        }
      },
      onError: (e, s) async {
        try {
          await closeAndDelete();
        } finally {
          completer.completeError(
            DioMixin.assureDioError(e, response.requestOptions, s),
          );
        }
      },
      cancelOnError: true,
    );
    cancelToken?.whenCancel.then((_) async {
      await subscription.cancel();
      await closeAndDelete();
    });

    final timeout = response.requestOptions.receiveTimeout;
    if (timeout != null) {
      future = future.timeout(timeout).catchError(
            (dynamic e, StackTrace s) async {
          await subscription.cancel();
          await closeAndDelete();
          if (e is TimeoutException) {
            throw DioError.receiveTimeout(
              timeout: timeout,
              requestOptions: response.requestOptions,
              stackTrace: s,
            );
          } else {
            throw e;
          }
        },
      );
    }
    return DioMixin.listenCancelForAsyncTask(cancelToken, future);
  }


}
