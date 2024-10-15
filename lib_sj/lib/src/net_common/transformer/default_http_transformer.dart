import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import '../http_response.dart';
import 'http_transformer.dart';

/**
 * 具体用来解析dio的返回结果Response，并转化成自定义的HttpResponse
 */
class DefaultHttpTransformer extends HttpTransformer {
  @override
  MyHttpResponse parse(Response response) {
    /**
     * 这里可以做一些其他的事件处理，默认不做任何中间处理
     */
    // String data = response.data.toString();
    // final bool isCompute = !AppSetting.isDriverTest && data.length > 10 * 1024;
    // if(kDebugMode){
    //   var jsonValue = json.encode(response.data);
    //   MLog.d(DIO_NET_TAG, 'jsonValue:$jsonValue');
    //   // MLog.d(DIO_NET_TAG, 'isCompute:$isCompute');
    // }

    // final Map<String, dynamic> _map = isCompute ? await compute(parseData, data) : parseData(data);
    // Map<String,dynamic> _map=await compute(parseData, data);

    mlogD("DefaultHttpTransformer", "-----------------type=${response.data.runtimeType}");
    return (response.data is ResponseBody)
        ? MyHttpResponse.successResponseBody(response.data,response.realUri.path)
        : MyHttpResponse.successMap(response.data,response.realUri.path);
  }

  // Map<String,dynamic> getParseResult(String data) async{
  //   return await compute(parseData, data);
  // }

  /// 单例对象
  static DefaultHttpTransformer _instance = DefaultHttpTransformer._internal();

  /// 内部构造方法，可避免外部暴露构造函数，进行实例化
  DefaultHttpTransformer._internal();

  /// 工厂构造方法，这里使用命名构造函数方式进行声明
  factory DefaultHttpTransformer.getInstance() => _instance;

  Map<String, dynamic> parseData(String data) {
    return json.decode(data) as Map<String, dynamic>;
  }
}
