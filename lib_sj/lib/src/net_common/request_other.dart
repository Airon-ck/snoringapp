

enum Method { get, post, put, patch, delete, head }


typedef NetSuccessCallback = Function(dynamic code, dynamic data, String? msg);
typedef NetSuccessHttpResponseCallback = Function(dynamic code, dynamic data, String? msg,dynamic result);
typedef NetSuccessListCallback = Function(dynamic code, dynamic data, String msg);
typedef NetErrorCallback = Function(dynamic code, String msg);
typedef NetErrorExCallback = Function(dynamic code, String msg,dynamic exResponse);