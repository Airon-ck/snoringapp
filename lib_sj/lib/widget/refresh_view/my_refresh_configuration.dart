import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lib_sj/common/app_base.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyRefreshConfiguration extends StatelessWidget {
  final Widget child;

  /// global default header builder
  final IndicatorBuilder? headerBuilder;

  final TextStyle? defaultFooterTextStyle;

  /// global default footer builder
  final IndicatorBuilder? footerBuilder;

  final TextStyle? defaultHeaderTextStyle;

  /// whether footer can trigger load by reaching footerDistance when inNoMore state
  final bool enableLoadingWhenNoData;

  final ShouldFollowContent? shouldFooterFollowWhenNotFull;

  /// when listView data small(not enough one page) , it should be hide
  final bool hideFooterWhenNotFull;

  /// toggle of  refresh vibrate
  final bool enableRefreshVibrate;

  /// toggle of  loadmore vibrate
  final bool enableLoadMoreVibrate;

  final bool enableScrollWhenTwoLevel;

  MyRefreshConfiguration({
    required this.child,
    this.headerBuilder,
    this.footerBuilder,
    this.defaultFooterTextStyle,
    this.defaultHeaderTextStyle,
    this.enableScrollWhenTwoLevel = true,
    this.enableLoadingWhenNoData = false,
    this.shouldFooterFollowWhenNotFull,
    this.hideFooterWhenNotFull = false,
    this.enableRefreshVibrate = false,
    this.enableLoadMoreVibrate = false,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshConfiguration(
      child: child,
      enableScrollWhenTwoLevel: false,
      footerBuilder: footerBuilder ?? getDefaultFootView(),
      headerBuilder: headerBuilder ?? getDefaultHeaderView(),
      enableLoadingWhenNoData: enableLoadingWhenNoData,
      shouldFooterFollowWhenNotFull: shouldFooterFollowWhenNotFull,
      hideFooterWhenNotFull: hideFooterWhenNotFull,
      enableLoadMoreVibrate: enableLoadMoreVibrate,
      enableRefreshVibrate: enableRefreshVibrate,
    );
  }

  IndicatorBuilder getDefaultFootView() {
    return () => ClassicFooter(
          textStyle: defaultFooterTextStyle ?? TextStyle(color: Colors.black),
          loadStyle: LoadStyle.ShowWhenLoading,
        );
  }

  IndicatorBuilder getDefaultHeaderView() {
    return () => AppInfo.isIOSAndMac()
        ? ClassicHeader(
            textStyle:
                defaultHeaderTextStyle ?? const TextStyle(color: Colors.black),
          )
        : MaterialClassicHeader();
  }
}
