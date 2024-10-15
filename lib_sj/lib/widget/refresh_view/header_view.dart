import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

import 'package:flutter/widgets.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;

class SjClassicHeader extends RefreshIndicator {
  final OuterBuilder? outerBuilder;
  final String? releaseText,
      idleText,
      refreshingText,
      completeText,
      failedText,
      canTwoLevelText;
  final Widget? releaseIcon,
      idleIcon,
      refreshingIcon,
      completeIcon,
      failedIcon,
      canTwoLevelIcon,
      twoLevelView;

  /// icon and text middle margin
  final double spacing;
  final IconPosition iconPos;

  final TextStyle textStyle;

  final bool openHeaderSafeTop;

  final Color defaultMyColor;

  const SjClassicHeader({
    Key? key,
    RefreshStyle refreshStyle: RefreshStyle.Follow,
    double height: 60.0,
    Duration completeDuration: const Duration(milliseconds: 600),
    this.outerBuilder,
    this.textStyle: const TextStyle(color: Colors.grey),
    this.releaseText,
    this.refreshingText,
    this.canTwoLevelIcon,
    this.twoLevelView,
    this.canTwoLevelText,
    this.completeText,
    this.failedText,
    this.idleText,
    this.iconPos: IconPosition.left,
    this.spacing: 15.0,
    this.refreshingIcon,
    this.defaultMyColor = Colors.white,
    this.failedIcon: const Icon(Icons.error, color: Colors.grey),
    this.completeIcon: const Icon(Icons.done, color: Colors.grey),
    this.idleIcon = const Icon(Icons.arrow_downward, color: Colors.grey),
    this.releaseIcon = const Icon(Icons.refresh, color: Colors.grey),
    this.openHeaderSafeTop = false,
  }) : super(
          key: key,
          refreshStyle: refreshStyle,
          completeDuration: completeDuration,
          height: height,
        );

  @override
  State createState() {
    return _SjClassicHeaderState();
  }
}

class _SjClassicHeaderState extends RefreshIndicatorState<SjClassicHeader> {
  Widget _buildText(mode) {
    RefreshString strings =
        RefreshLocalizations.of(context)?.currentLocalization ??
            EnRefreshString();
    return Text(
        mode == RefreshStatus.canRefresh
            ? getSjTextByKey('canRefreshText') ?? strings.canRefreshText!
            : mode == RefreshStatus.completed
                ? getSjTextByKey('refreshCompleteText') ??
                    strings.refreshCompleteText!
                : mode == RefreshStatus.failed
                    ? getSjTextByKey('refreshFailedText') ??
                        strings.refreshFailedText!
                    : mode == RefreshStatus.refreshing
                        ? getSjTextByKey('refreshingText') ??
                            strings.refreshingText!
                        : mode == RefreshStatus.idle
                            ? getSjTextByKey('idleRefreshText') ??
                                strings.idleRefreshText!
                            : mode == RefreshStatus.canTwoLevel
                                ? getSjTextByKey('canTwoLevelText') ??
                                    strings.canTwoLevelText!
                                : "",
        style: widget.textStyle);
    return Text(
        mode == RefreshStatus.canRefresh
            ? widget.releaseText ?? strings.canRefreshText!
            : mode == RefreshStatus.completed
                ? widget.completeText ?? strings.refreshCompleteText!
                : mode == RefreshStatus.failed
                    ? widget.failedText ?? strings.refreshFailedText!
                    : mode == RefreshStatus.refreshing
                        ? widget.refreshingText ?? strings.refreshingText!
                        : mode == RefreshStatus.idle
                            ? widget.idleText ?? strings.idleRefreshText!
                            : mode == RefreshStatus.canTwoLevel
                                ? widget.canTwoLevelText ??
                                    strings.canTwoLevelText!
                                : "",
        style: widget.textStyle);
  }

  Widget _buildIcon(mode) {
    Widget? icon = mode == RefreshStatus.canRefresh
        ? widget.releaseIcon
        : mode == RefreshStatus.idle
            ? widget.idleIcon
            : mode == RefreshStatus.completed
                ? widget.completeIcon
                : mode == RefreshStatus.failed
                    ? widget.failedIcon
                    : mode == RefreshStatus.canTwoLevel
                        ? widget.canTwoLevelIcon
                        : mode == RefreshStatus.canTwoLevel
                            ? widget.canTwoLevelIcon
                            : mode == RefreshStatus.refreshing
                                ? widget.refreshingIcon ??
                                    SizedBox(
                                      width: 25.0,
                                      height: 25.0,
                                      child: defaultTargetPlatform ==
                                              TargetPlatform.iOS
                                          ? CupertinoActivityIndicator(
                                              color: widget.defaultMyColor,
                                            )
                                          : CircularProgressIndicator(
                                              strokeWidth: 2.0,
                                              color: widget.defaultMyColor),
                                    )
                                : widget.twoLevelView;
    return icon ?? Container();
  }

  @override
  bool needReverseAll() {
    return false;
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    Widget textWidget = _buildText(mode);
    Widget iconWidget = _buildIcon(mode);
    List<Widget> children = <Widget>[iconWidget, textWidget];
    final Widget container1 = Wrap(
      spacing: widget.spacing,
      textDirection: widget.iconPos == IconPosition.left
          ? TextDirection.ltr
          : TextDirection.rtl,
      direction: widget.iconPos == IconPosition.bottom ||
              widget.iconPos == IconPosition.top
          ? Axis.vertical
          : Axis.horizontal,
      crossAxisAlignment: WrapCrossAlignment.center,
      verticalDirection: widget.iconPos == IconPosition.bottom
          ? VerticalDirection.up
          : VerticalDirection.down,
      alignment: WrapAlignment.center,
      children: children,
    );
    final Widget container = widget.openHeaderSafeTop
        ? SafeArea(
            top: true,
            bottom: false,
            child: container1,
          )
        : container1;

    return widget.outerBuilder != null
        ? widget.outerBuilder!(container)
        : Container(
            height: widget.height,
            child: Center(child: container),
          );
  }
}

class SjMaterialClassicHeader extends RefreshIndicator {
  /// see flutter RefreshIndicator documents,the meaning same with that
  final String? semanticsLabel;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final String? semanticsValue;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final Color? color;

  /// Distance from the top when refreshing
  final double distance;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final Color? backgroundColor;

  final bool openHeaderSafeTop;

  const SjMaterialClassicHeader({
    Key? key,
    double height: 80.0,
    this.semanticsLabel,
    this.semanticsValue,
    this.color,
    double offset: 0,
    this.distance: 50.0,
    this.backgroundColor,
    this.openHeaderSafeTop = false,
  }) : super(
          key: key,
          refreshStyle: RefreshStyle.Front,
          offset: offset,
          height: height,
        );

  @override
  State<StatefulWidget> createState() {
    return _SjMaterialClassicHeaderState();
  }
}

const double _kDragSizeFactorLimit = 1.5;

class _SjMaterialClassicHeaderState
    extends RefreshIndicatorState<SjMaterialClassicHeader>
    with TickerProviderStateMixin {
  ScrollPosition? _position;
  Animation<Offset>? _positionFactor;
  Animation<Color?>? _valueColor;
  late AnimationController _scaleFactor;
  late AnimationController _positionController;
  late AnimationController _valueAni;

  @override
  void initState() {
    // TODO: implement initState
    _valueAni = AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 500));
    _valueAni.addListener(() {
      // frequently setState will decline the performance
      if (mounted && _position!.pixels <= 0) setState(() {});
    });
    _positionController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _scaleFactor = AnimationController(
        vsync: this,
        value: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: Duration(milliseconds: 300));
    _positionFactor = _positionController.drive(Tween<Offset>(
        begin: Offset(0.0, -1.0), end: Offset(0.0, widget.height / 44.0)));
    super.initState();
  }

  @override
  void didUpdateWidget(covariant SjMaterialClassicHeader oldWidget) {
    _position = Scrollable.of(context)!.position;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    return _buildIndicator(widget.backgroundColor ?? Colors.white);
  }

  Widget _buildIndicator(Color outerColor) {
    return SlideTransition(
      child: ScaleTransition(
          scale: _scaleFactor,
          child: widget.openHeaderSafeTop
              ? SafeArea(
                  child: _getMyView(outerColor),
                  top: true,
                  bottom: false,
                )
              : _getMyView(outerColor)),
      position: _positionFactor!,
    );
  }

  _getMyView(Color? outerColor) {
    return Align(
      alignment: Alignment.topCenter,
      child: RefreshProgressIndicator(
        semanticsLabel: widget.semanticsLabel ??
            MaterialLocalizations?.of(context).refreshIndicatorSemanticLabel,
        semanticsValue: widget.semanticsValue,
        value: floating ? null : _valueAni.value,
        valueColor: _valueColor,
        backgroundColor: outerColor,
      ),
    );
  }

  @override
  void onOffsetChange(double offset) {
    // TODO: implement onOffsetChange
    if (!floating) {
      _valueAni.value = offset / configuration!.headerTriggerDistance;
      _positionController.value = offset / configuration!.headerTriggerDistance;
    }
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    // TODO: implement onModeChange
    if (mode == RefreshStatus.refreshing) {
      _positionController.value = widget.distance / widget.height;
      _scaleFactor.value = 1;
    }
    super.onModeChange(mode);
  }

  @override
  void resetValue() {
    // TODO: implement resetValue
    _scaleFactor.value = 1.0;
    _positionController.value = 0.0;
    _valueAni.value = 0.0;
    super.resetValue();
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _position = Scrollable.of(context)!.position;
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.primaryColor).withOpacity(0.0),
        end: (widget.color ?? theme.primaryColor).withOpacity(1.0),
      ).chain(
          CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
    );
    super.didChangeDependencies();
  }

  @override
  Future<void> readyToRefresh() {
    // TODO: implement readyToRefresh
    return _positionController.animateTo(widget.distance / widget.height);
  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    return _scaleFactor.animateTo(0.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _valueAni.dispose();
    _scaleFactor.dispose();
    _positionController.dispose();
    super.dispose();
  }
}
