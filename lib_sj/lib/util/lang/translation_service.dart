import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lib_sj/util/lang/en_us.dart';
import 'package:lib_sj/util/lang/zh_Hant_CN.dart';
import 'package:lib_sj/util/lang/zh_cn.dart';
import 'package:lib_sj/util/lang/zh_hk.dart';

/**
 * 多语言转换器
 * getx当前不支持部分国产手机的语言编码，scriptCode对于hant和hans的区分，所以无法进行简繁体的切换
 */
class TranslationService extends Translations {
  static Locale? get locale => Get.deviceLocale;
  static const fallbackLocale = Locale('zh', 'HK');
  // static const fallbackLocale = Locale('en','US');

  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': en_US,
        // 'zh_HK': zh_hk,
        // 'zh_TW': zh_hk,
        // 'zh_CN': zh_CN,
        // 'zh-Hans-CN': zh_CN,
        // 'zh_Hans_CN': zh_CN,
        // 'zh-Hant-CN': zh_hk,
        // 'zh_Hant_CN': zh_hk,
        // 'zh-Hant-TW': zh_hk,
        // 'zh_Hant_TW': zh_hk,
        // 'zh-Hant-HK': zh_hk,
        // 'zh_Hant_HK': zh_hk,
        'zh-Hant': zh_hk,
        'zh-Hans': zh_CN,
        'zh_Hant': zh_hk,
        'zh_Hans': zh_CN,
        // 'zh_Hant_HK': zh_hk,
      };
}
