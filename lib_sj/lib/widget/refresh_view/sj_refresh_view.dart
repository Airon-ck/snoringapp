import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/util/device_utils.dart';
import 'package:lib_sj/widget/request_status_view.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'header_view.dart';

typedef OnRefreshListener = Function(
    bool isRefresh, RefreshController refreshController);

/**
 * 如果需要使用空布局文案提示，需要在logic里面将openStatus=true
 * 然后关联viewState
 * 并且外层需要MyGetBuilder用于提供当前状态viewState
 */
class SjRefreshView extends StatelessWidget {
  Widget child;

  final RefreshController refreshController;

  final OnRefreshListener? onRefreshListener;

  final ViewState viewState;

  final bool enablePullUp;

  final ScrollController? scrollController;

  final Widget? loadingView;
  final Widget? emptyView;
  final Widget? errorView;

  final bool iosHeaderOpenSafeTop;
  final bool androidHeaderOpenSafeTop;

  final Color defaultHeaderColor;
  final Color defaultHeaderTvColor;

  SjRefreshView({
    required this.child,
    required this.refreshController,
    required this.onRefreshListener,
    this.enablePullUp = true,
    this.viewState = ViewState.idle,
    this.scrollController,
    this.emptyView,
    this.errorView,
    this.loadingView,
    this.defaultHeaderTvColor = Colors.black54,
    this.defaultHeaderColor = Colors.black54,
    this.iosHeaderOpenSafeTop = false,
    this.androidHeaderOpenSafeTop = false,
  });

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: refreshController,
      enablePullDown: true,
      scrollController: scrollController,
      onRefresh: () {
        mlogD("minnknk", "SmartRefresher=onRefresh");
        onRefreshListener?.call(true, refreshController);
      },
      onLoading: () {
        mlogD("minnknk", "SmartRefresher=onLoading");
        onRefreshListener?.call(false, refreshController);
      },
      enablePullUp: enablePullUp,
      footer: ClassicFooter(
        textStyle: const TextStyle(
          color: Color(0xff999999),
          fontSize: 14,
        ),
        loadingText: getSjTextByKey("loadingText"),
        noDataText: getSjTextByKey("noMoreText"),
        idleText: getSjTextByKey("idleLoadingText"),
        failedText: getSjTextByKey("loadFailedText"),
        canLoadingText: getSjTextByKey("canLoadingText"),
        loadStyle: LoadStyle.ShowWhenLoading,
      ),
      header: DeviceUtils.isAndroid
          ? SjMaterialClassicHeader(openHeaderSafeTop: androidHeaderOpenSafeTop)
          : SjClassicHeader(
              textStyle: TextStyle(color: defaultHeaderTvColor),
              defaultMyColor: defaultHeaderColor,
              openHeaderSafeTop: iosHeaderOpenSafeTop,
              failedIcon: Icon(Icons.error, color: defaultHeaderColor),
              completeIcon: Icon(Icons.done, color: defaultHeaderColor),
              idleIcon: Icon(Icons.arrow_downward, color: defaultHeaderColor),
              releaseIcon: Icon(Icons.refresh, color: defaultHeaderColor),
            ),
      child: viewState == ViewState.idle ? child : getChildView(),
    );
  }

  Widget getChildView() {
    mlogD("minnknk", "getChildView=$viewState");
    return Align(
      alignment: Alignment.center,
      child: RequestStatusView(
        viewState: viewState,
        onTap: () {
          refreshController.requestRefresh();
        },
        loadingView: loadingView,
        errorView: errorView,
        emptyView: emptyView,
        child: child,
      ),
    );
  }
}
