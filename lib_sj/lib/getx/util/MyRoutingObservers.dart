import 'package:flutter/material.dart';
import 'package:lib_sj/common/app_setting.dart';

/**
 * 在MaterialApp的navigatorObservers注册该观察者才能使用
 * 页面切换时的aop路由
 */
class MyRoutingObservers extends NavigatorObserver {
  @override
  void didPop(Route route, Route? previousRoute) {
    super.didPop(route, previousRoute);
    String? previousName = '';
    // if (previousRoute == null) {
    //   previousName = 'null';
    // } else {
    //   previousName = previousRoute.settings.name;
    // }
    // print('zcxczxczxc YM----->NavObserverDidPop--Current:${route.settings.name}  Previous:${previousName}');
    AppSetting.listenerPageResult?.call(previousRoute?.settings.name, "didPop");
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    // String? previousName = '';
    // if (previousRoute == null) {
    //   previousName = 'null';
    // } else {
    //   previousName = previousRoute.settings.name;
    // }
    // print('zcxczxczxc YM-------NavObserverDidPush-Current:${route.settings.name}  Previous:${previousName}');
    AppSetting.listenerPageResult?.call(route.settings.name, "didPush");
  }

  @override
  void didStopUserGesture() {
    super.didStopUserGesture();
  }

  @override
  void didStartUserGesture(
      Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didStartUserGesture(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    AppSetting.listenerPageResult?.call(
        "newRoute:${newRoute?.settings.name}--oldRoute:${oldRoute?.settings.name}",
        "didReplace");
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didRemove(route, previousRoute);
    AppSetting.listenerPageResult?.call(route.settings.name, "didRemove");
  }
}
