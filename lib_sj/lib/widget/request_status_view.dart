import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/lib_sj.dart';
import 'package:lib_sj/src/net_common/error_type.dart';
import 'package:lib_sj/widget/my_text.dart';

/**
 * 正常状态下的布局更新
 */
class RequestStatusView extends StatelessWidget {
  final Widget child;
  final ViewState viewState;

  final Widget? loadingView;
  final Widget? emptyView;
  final Widget? errorView;

  final GestureTapCallback? onTap;

  RequestStatusView(
      {Key? key,
      required this.child,
      required this.viewState,
      this.onTap,
      this.loadingView,
      this.emptyView,
      this.errorView})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (viewState) {
      case ViewState.loading:
        return loadingView ?? getStatusView(getSjTextByKey('Loading')!, false);
      case ViewState.idle:
        return child;
      case ViewState.empty:
        return emptyView ?? getStatusView(getSjTextByKey('no_data')!, false);
      case ViewState.error:
        return errorView ??
            getStatusView(getSjTextByKey('data_loading_failed')!, false);
      case ViewState.errorEmpty:
        return errorView ??
            getStatusView(getSjTextByKey('data_loading_failed')!, true);
    }
  }

  Widget getStatusView(String content, bool retryBtnVisible) {
    return GestureDetector(
      onTap: onTap,
      child: StatusView(content, retryBtnVisible),
    );
  }
}

class StatusView extends StatelessWidget {
  final String content;
  final String? btnContent;
  final bool retryBtnVisible;

  StatusView(this.content, this.retryBtnVisible, {this.btnContent});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        width: !constraints.hasBoundedWidth
            ? MediaQuery.of(context).size.width
            : constraints.maxWidth,
        height: !constraints.hasBoundedHeight
            ? MediaQuery.of(context).size.height
            : constraints.maxHeight,
        margin: EdgeInsets.only(bottom: !constraints.hasBoundedHeight ? 50 : 0),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SjText(content, fontSize: 18),
            Visibility(
              visible: retryBtnVisible,
              child: Container(
                margin: const EdgeInsets.only(top: 8),
                padding:
                    const EdgeInsets.only(left: 5, right: 5, bottom: 2, top: 2),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black45),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: SjText(btnContent ?? getSjTextByKey('retry')!,
                    fontSize: 18),
              ),
            ),
          ],
        ),
      );
    });
  }
}

class StatusCoutomView extends StatelessWidget {
  final ViewState viewState;

  final Widget child;

  StatusCoutomView(this.child, {this.viewState = ViewState.idle});

  @override
  Widget build(BuildContext context) {
    switch (viewState) {
      case ViewState.loading:
        return StatusView(getSjTextByKey('Loading')!, false);
      case ViewState.idle:
        return child;
      case ViewState.empty:
        return StatusView(getSjTextByKey('no_data')!, false);
      case ViewState.error:
        return StatusView(getSjTextByKey('data_loading_failed')!, false);
      case ViewState.errorEmpty:
        return StatusView(getSjTextByKey('data_loading_failed')!, false);
    }
  }
}

/**
 * 当SmartRefreshView需要使用CustomScrollView时，并且需要使用布局的状态更新展示，才使用该控件
 */
class StatusCustomScrollView extends CustomScrollView {
  final ViewState viewState;

  const StatusCustomScrollView(
      {Key? key,
      Axis scrollDirection = Axis.vertical,
      bool reverse = false,
      ScrollController? controller,
      bool? primary,
      ScrollPhysics? physics,
      ScrollBehavior? scrollBehavior,
      bool shrinkWrap = false,
      Key? center,
      double anchor = 0.0,
      double? cacheExtent,
      List<Widget> widgetList = const <Widget>[],
      int? semanticChildCount,
      DragStartBehavior dragStartBehavior = DragStartBehavior.start,
      ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
          ScrollViewKeyboardDismissBehavior.manual,
      String? restorationId,
      Clip clipBehavior = Clip.hardEdge,
      required this.viewState})
      : super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          scrollBehavior: scrollBehavior,
          shrinkWrap: shrinkWrap,
          center: center,
          anchor: anchor,
          cacheExtent: cacheExtent,
          semanticChildCount: semanticChildCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
          slivers: widgetList,
        );

  @override
  List<Widget> buildSlivers(BuildContext context) {
    switch (viewState) {
      case ViewState.loading:
        return <Widget>[
          SliverToBoxAdapter(
            child: StatusView(getSjTextByKey('Loading')!, false),
          )
        ];
      case ViewState.idle:
        return super.buildSlivers(context);
      case ViewState.empty:
        return <Widget>[
          SliverToBoxAdapter(
            child: StatusView(getSjTextByKey('no_data')!, false),
          )
        ];
      case ViewState.error:
      case ViewState.errorEmpty:
        return <Widget>[
          SliverToBoxAdapter(
            child: StatusView(getSjTextByKey('data_loading_failed')!, false),
          )
        ];
    }
  }
}
