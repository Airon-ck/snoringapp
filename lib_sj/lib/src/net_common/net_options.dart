import 'package:dio/dio.dart';

class SjNetOpitions {
  Map<String, dynamic>? headers;

  Duration? sendTimeout;

  Duration? receiveTimeout;

  String? contentType;

  ResponseType? responseType;

  RequestEncoder? requestEncoder;

  ResponseDecoder? responseDecoder;
  bool persistentConnection;

  SjNetOpitions(
      {this.headers,
      this.sendTimeout,
      this.receiveTimeout,
      this.contentType,
      this.responseType,
      this.requestEncoder,
      this.responseDecoder,
      this.persistentConnection = false});

  Options? getOptions() {
    if (sendTimeout == null &&
        receiveTimeout == null &&
        headers == null &&
        responseType == null &&
        contentType == null &&
        requestEncoder == null &&
        responseDecoder == null) {
      return null;
    }
    return Options(
        sendTimeout: sendTimeout,
        receiveTimeout: receiveTimeout,
        headers: headers,
        responseType: responseType,
        contentType: contentType,
        requestEncoder: requestEncoder,
        responseDecoder: responseDecoder,
        persistentConnection: persistentConnection);
  }
}
