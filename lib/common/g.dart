import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snoring_app/generated/generated_utils.dart';
import 'package:lib_sj/common/app_setting.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/device_utils.dart';
import 'package:lib_sj/util/easy_loading/easy_load_util.dart';

class Global {
  ///环境: 1为dev，2sit 3prod
  static const int environment =
      int.fromEnvironment('environment', defaultValue: 1);

  static getEnvironmentBaseApiUrl() {
    return "";
  }

  static getUniversalLink() {
    return "";
  }

  static getRsaPath() {
    return "";
  }

  static String UNIVERSAL_LINK = getUniversalLink();

  ///当前路由名称
  static String currentRoute = '/';

  static const String privacyValue =
      '在您使用本应用服务的过程中，我们访问您的各项权限是为了向您提供服务、优化我们的服务以及保障您的帐号安全，具体使用规则如下：\n1、手机信息权限：需要收集您的设备Mac地址、唯一设备识别码（IMEI/android ID/IDFA/OPENUDID/GUID、SIM 卡 IMSI 信息），用于APP安全运行、设备单点登录与风控验证，以及其他第三方SDK的使用。\n2、相机权限： 在进行用户头像的选择场景的时候需要使用摄像头权限。\n3、应用安装权限： 为了提供APP的版本更新服务，让用户安装最新版的应用。\n4、内存卡权限：实现客户端日志的存储，以及为用户提供访问相册及其他本地文件、缓存或下载数据到本地等服务。\n5、应用通知权限：您开通该权限后，我们即可向您推送安睡有氧资讯、活动通知等。\n6、自启动和关联启动：为提升消息的送达率，及时地为您进行消息提醒，我们会默认为您开启关联启动功能，以保持应用的活跃度。如您不想开通此功能，我们建议您手动进行关闭，一般关闭路径：设置 - 应用 - 应用启动管理 - 选择应用“安睡有氧”- 关闭关联启动功能。\n7、接入第三方服务的情形：我们可能会接入第三方SDK服务，并将我们依照本政策收集的您的某些信息共享给该等第三方服务商，以便提高更好的客户服务和用户体验。\n';

  static String API_URL = getEnvironmentBaseApiUrl();
  static String BASE_URL = API_URL;

  static String UmengChannel = "TestVersion";

  static const String AppLogo = "ic_app_logo";
  static String AppName = "安睡有氧";

  static initRequestUrl(String reqCommonNode) {
    BASE_URL = API_URL + reqCommonNode;
  }

  static String CommonUserTokenKey = "x-token";

  static init() {
    ///初始化loading的样式
    configLoading();

    if (DeviceUtils.isAndroid) {
      /// Android状态栏透明 splash为白色,所以调整状态栏文字为黑色
      SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: Brightness.light));
    }

    /**
     * 初始化网络请求的基础网络url
     * reqFuncInjectionType:请求过程中的各种key注入的方式，false:直接字段注入，true:使用方法注入，可随时在app层根据业务逻辑即时进行调整
     */
    AppSetting.initHttpBaseUrl(BASE_URL, reqFuncInjectionType: true);
    /**
     * 监听页面切换时的路由名称
     */
    AppSetting.initPageChangeListener((String? pageName, String? changeType) {
      mlogD("initPageChangeListener",
          "-----------------------------------------------------------pageName=$pageName---$changeType");
    });

    /**
     * 网络请求时携带的固定不变的header数据
     */
    AppSetting.initRequestCommonHeaderMap({
      // 'deviceType': 'android',
      // "time": DateTime.now().toString(),
    });

    /**
     * 网络请求时携带的有业务逻辑的header数据
     */
    AppSetting.initRequestDynamicHeaderMap(getMyDynamicHeaderMap);

    /**
     *  initHttpBaseUrl中，reqFuncInjectionType=false时使用才有效果
     * 设置网络请求结果中，服务器自定义的字段key名称
     */
    AppSetting.setResponseKey(
        dataKey: 'data',
        codeKey: 'code',
        msgKey: 'message',
        javaReqSuccessCode: 'A00000');

    /**
     *  initHttpBaseUrl中，reqFuncInjectionType=true时使用才有效果
     * 设置网络请求结果中，服务器自定义的字段key名称
     */
    AppSetting.initRequestResultParamer(
      getReqSuccessCode,
      javaRequestTimeOutCodeFun: getReqTimeOutCode,
      javaRequestMessageKeyFun: getReqMsgKey,
      javaRequestCodeKeyFun: getResponseCodeKey,
    );
    /**
     * 配置SjLoadImage加载时的默认图片
     */
    AppSetting.initDefaultPicHolder('ic_app_logo');
    /**
     * 全局监听网络请求时http的statusCode(非服务器自定义的code)
     * 比如401超时的时候，可以进行全局配置
     */
    AppSetting.initResponseStatusCodeListener((value) {
      handleResponseListener(value);
    });
    /**
     * 全局监听网络请求成功时，服务器自定义的code
     */
    AppSetting.initResponseJavaCodeListener((value) {
      handleResponseListener(value);
    });

    AppSetting.initHandMyResponseExcetionDescListener(
        _getHandMyResponseExceptionDesc);
  }
}

handleResponseListener(value) {
  mlogD("aaaaa", "--------------------------handleResponseListener=${value}");
}

/**
 * 动态添加的header
 */
Map<String, dynamic> getMyDynamicHeaderMap(dynamic path) {
  Map<String, dynamic> data = Map();
  return data;
}

getReqSuccessCode(String? urlPath) {
  return 'A00000';
}

getReqTimeOutCode(String? urlPath) {
  return 'A10000';
}

String getResponseCodeKey(String? urlPath) {
  return 'code';
}

getReqMsgKey(String? urlPath) {
  return 'message';
}

_getHandMyResponseExceptionDesc(
    Exception exception, bool isSocketException, dynamic statusCode) {
  mlogD("aaaaa",
      "--------------------------_getHandMyResponseExceptionDesc.exception=${exception},isSocketException=${isSocketException},statusCode=${statusCode}");
  handleResponseListener(statusCode);
  if (statusCode == 401) {
    return '登录失效，请重新登录';
  }
  if (isSocketException) {
    return LangCurrent.network_unavailable;
  }
  return LangCurrent.server_error;
}
