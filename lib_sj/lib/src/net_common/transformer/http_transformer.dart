import 'package:dio/dio.dart';

import '../http_response.dart';

// Response 解析
abstract class HttpTransformer {
  MyHttpResponse parse(Response response);
}
