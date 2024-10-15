import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:lib_sj/getx/util/MyRoutingObservers.dart';
import 'package:lib_sj/util/lang/translation_service.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyGetMaterialApp extends StatelessWidget {
  final Widget? home;
  final String? initialRoute;
  final String title;

  /**
   * 默认语言
   */
  final Locale? locale;

  /**
   * 语言类型失败时默认使用的类型
   */
  final Locale? fallbackLocale;
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /**
   * 使用的语言库
   */
  final Translations? translations;

  /**
   * 当前app支持的语言库
   */
  final Iterable<Locale>? supportedLocales;
  final ThemeData? theme;
  final ThemeData? darkTheme;
  final ThemeMode themeMode;
  final TransitionBuilder? builder;

  /**
   * 是否开启使用多语言的功能
   */
  final bool openLocale;
  final LocaleListResolutionCallback? localeListResolutionCallback;
  final GlobalKey<NavigatorState>? navigatorKey;
  final List<NavigatorObserver>? navigatorObservers;

  final List<GetPage>? getPages;

  MyGetMaterialApp({
    required this.title,
    required this.home,
    this.initialRoute,
    this.locale,
    this.fallbackLocale,
    this.translations,
    this.supportedLocales = const <Locale>[Locale('zh', 'CN')],
    this.localizationsDelegates,
    this.theme,
    this.darkTheme,
    this.themeMode = ThemeMode.system,
    this.builder,
    this.openLocale = false,
    this.localeListResolutionCallback,
    this.navigatorKey,
    this.navigatorObservers,
    this.getPages,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: title,
      // debugShowCheckedModeBanner: false,
      localizationsDelegates: localizationsDelegates ??
          [
            GlobalMaterialLocalizations.delegate,
            RefreshLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
      locale: openLocale ? (locale ?? TranslationService.locale) : null,
      fallbackLocale: openLocale
          ? (fallbackLocale ?? TranslationService.fallbackLocale)
          : null,
      translations: openLocale ? (translations ?? TranslationService()) : null,
      supportedLocales: supportedLocales ??
          const [
            Locale('zh', 'CN'),
          ],
      localeListResolutionCallback: localeListResolutionCallback,
      theme: theme ??
          ThemeData(
            backgroundColor: Color.fromARGB(255, 85, 132, 250),
            brightness: Brightness.light,
            primaryColor: Color.fromARGB(255, 85, 132, 250),
            accentColor: Color.fromARGB(255, 85, 132, 250),
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Color.fromARGB(255, 245, 246, 250),
          ),
      home: home,
      builder: builder ??
          EasyLoading.init(builder: (context, widget) {
            return MediaQuery(
              ///设置文字大小不随系统设置改变
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          }),
      // navigatorKey: navigatorKey,
      navigatorObservers: navigatorObservers ?? [new MyRoutingObservers()],
      getPages: getPages,
      defaultTransition: Transition.rightToLeftWithFade,
    );
  }
}
