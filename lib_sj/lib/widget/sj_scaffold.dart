import 'package:flutter/material.dart';

class SjScaffold extends StatelessWidget {
  /**
   * 是否开启系统返回操作的监听
   */
  bool enableBackClickListener;

  /**
   * 当enableBackClickListener=true的时候才能使用
   */
  final WillPopCallback? onBackClickListener;

  Widget body;
  final PreferredSizeWidget? appBar;
  final Color? backgroundColor;

  SjScaffold(
      {required this.body,
      this.appBar,
      this.backgroundColor,
      this.enableBackClickListener = false,
      this.onBackClickListener});

  @override
  Widget build(BuildContext context) {
    return !enableBackClickListener
        ? Scaffold(
            appBar: appBar,
            body: body,
            backgroundColor: backgroundColor,
          )
        : WillPopScope(
            onWillPop: onBackClickListener ?? _defaultBackClick,
            child: Scaffold(
              appBar: appBar,
              body: body,
              backgroundColor: backgroundColor,
            ),
          );
  }

  Future<bool> _defaultBackClick() {
    return Future.value(false);
  }
}
