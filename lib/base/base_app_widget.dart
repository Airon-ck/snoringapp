import 'package:flutter/material.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:snoring_app/common/g.dart';
import 'package:snoring_app/generated/generated_utils.dart';
import 'package:snoring_app/generated/l10n.dart';
import 'package:snoring_app/ui/smart_bracelet/guide/guide_view.dart';
import 'package:snoring_app/utils/chinese_cupertino_localizations.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:lib_sj/getx/get_app.dart';
import 'package:lib_sj/util/app_utils.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/widget/refresh_view/my_refresh_configuration.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<StatefulWidget> createState() {
    return _MyAppState();
  }
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    AppInfo.initPackageInfo();
    AppUtil.initDefaultStatusBarStatus(false);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyGetMaterialApp(
      title: Global.AppName,
      home: MyRefreshConfiguration(
        footerBuilder: () => ClassicFooter(
          textStyle: const TextStyle(
            color: Color(0xff999999),
            fontSize: 14,
          ),
          loadingText: LangCurrent.loadingText,
          noDataText: LangCurrent.noMoreText,
          idleText: LangCurrent.idleLoadingText,
          failedText: LangCurrent.loadFailedText,
          canLoadingText: LangCurrent.canLoadingText,
          loadStyle: LoadStyle.ShowWhenLoading,
        ),
        child: GestureDetector(
          child: const GuidePage(key: Key('GuidePage')),
          onTap: () {
            AppUtil.closeKeyboard();
          },
        ),
      ),
      openLocale: false,
      locale: const Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      fallbackLocale:
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'CN'),
      supportedLocales: const [
        Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      ],
      localeListResolutionCallback: (locales, supportedLocales) {
        mlogD("sssss",
            "--------------->deviceLocale:${Get.deviceLocale.toString()}");
        mlogD("sssss", "--------------->当前系统语言环境:${Get.locale.toString()}");
        return;
      },
      localizationsDelegates: const [
        ChineseCupertinoLocalizations.delegate, // 自定义的delegate
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate,
        RefreshLocalizations.delegate,
      ],
      theme: ThemeData(
        textSelectionTheme:
            const TextSelectionThemeData(cursorColor: Color(0xffA92529)),
        // colorScheme: const ColorScheme(
        //   background: Color.fromARGB(255, 85, 132, 250),
        //   brightness: Brightness.light,
        //   primary: Color.fromARGB(255, 85, 132, 250),
        //   onPrimary: Color.fromARGB(255, 85, 132, 250),
        //   // secondary: Color.fromARGB(255, 85, 132, 250),
        //   secondary: Colors.transparent,
        //   onSecondary: Color.fromARGB(255, 85, 132, 250),
        //   error: Colors.red,
        //   onError: Colors.red,
        //   onBackground: Colors.black,
        //   surface: Colors.black87,
        //   onSurface: Colors.red,
        // ),
        // 点击时的高亮效果设置为透明
        splashColor: Colors.transparent,
        // 长按时的扩散效果设置为透明
        highlightColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        brightness: Brightness.light,
        primaryColor: const Color.fromARGB(255, 85, 132, 250),
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xffF5F5F5),
      ),
      getPages: [
        GetPage(
          name: '/',
          page: () => const GuidePage(key: Key('GuidePage')),
        ),
      ],
    );
  }
}
