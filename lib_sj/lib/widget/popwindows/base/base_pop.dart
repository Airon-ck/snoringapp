import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/widget/my_text.dart';

class BasePop extends PopupRoute {
  late Widget child;
  bool hasSafeArea;

  BasePop(this.child, {this.hasSafeArea = true});

  static void show(BuildContext context, Widget widget,
      {bool hasSafeArea = false}) {
    Navigator.of(context).push(
      BasePop(widget, hasSafeArea: hasSafeArea),
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Color? get barrierColor => Colors.black.withAlpha(127);

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return hasSafeArea ? SafeArea(child: child) : child;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  String? get barrierLabel => null;
}

class CustomBasePop extends PopupRoute {
  late Widget child;
  bool hasSafeArea;

  CustomBasePop(this.child, {this.hasSafeArea = true});

  static void show(BuildContext context, Widget widget,
      {bool hasSafeArea = false}) {
    Navigator.of(context).push(
      CustomBasePop(widget, hasSafeArea: hasSafeArea),
    );
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Color? get barrierColor => Colors.black.withAlpha(127);

  @override
  bool get barrierDismissible => false;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return hasSafeArea ? SafeArea(child: child) : child;
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  String? get barrierLabel => null;
}

class PositionPop extends PopupRoute {
  Widget child;
  bool hasSafeArea;
  Color? bgColor;
  double? topMargin;

  PositionPop(
      {required this.child,
      this.hasSafeArea = false,
      this.bgColor,
      this.topMargin});

  @override
  Color? get barrierColor => bgColor ?? Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return child;
  }

  static void show(BuildContext context, Widget widget,
      {bool hasSafeArea = true,
      double? topMargin,
      Color? bgColor,
      RelativeRect? position}) {
    Navigator.of(context).push(PositionPop(
        child: widget,
        hasSafeArea: hasSafeArea,
        topMargin: topMargin,
        bgColor: bgColor));
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}

class BasePositionPop extends PopupRoute {
  late Widget child;
  bool hasSafeArea;
  Color? bgColor;
  double? topMargin;
  RelativeRect? position;

  BasePositionPop(this.child,
      {this.hasSafeArea = true, this.topMargin, this.bgColor, this.position});

  static void show(BuildContext context, Widget widget,
      {bool hasSafeArea = true,
      double? topMargin,
      Color? bgColor,
      RelativeRect? position}) {
    Navigator.of(context).push(BasePositionPop(widget,
        hasSafeArea: hasSafeArea,
        topMargin: topMargin,
        bgColor: bgColor,
        position: position));
  }

  static void dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Color? get barrierColor => bgColor ?? Colors.transparent;

  @override
  bool get barrierDismissible => true;

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // return
    //   hasSafeArea ? SafeArea(child: child) : child;

    return Container(
      child: CustomSingleChildLayout(
        delegate: _MyLayoutDelegate(position),
        child: IntrinsicHeight(
          child: Container(
            height: 100,
            width: 300,
            color: Colors.green.withOpacity(0.5),
            child: child,
          ),
        ),
      ),
      // color: Colors.blue.withOpacity(0.3),
    );
  }

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  String? get barrierLabel => null;
}

class _MyLayoutDelegate extends SingleChildLayoutDelegate {
  RelativeRect? position;

  _MyLayoutDelegate(this.position);

  @override
  Size getSize(BoxConstraints constraints) {
    //获取父容器约束条件确定CustomSingleChildLayout大小
    mlogD("BasePositionPop", 'getSize constraints = $constraints');
    return super.getSize(constraints);
    // return getSize(BoxConstraints(maxWidth: 200, maxHeight: 200));
  }

  @override
  bool shouldRelayout(covariant SingleChildLayoutDelegate oldDelegate) {
    //是否需要relayout
    return false;
  }

  @override
  BoxConstraints getConstraintsForChild(BoxConstraints constraints) {
    //确定child的约束，用于确定child的大小
    mlogD("BasePositionPop",
        'getConstraintsForChild constraints =minW ${constraints.minWidth}--maxW=${constraints.maxWidth} maxHeight=${constraints.maxHeight}--minHeight=${constraints.minHeight}');
    // var childWidth = min(constraints.maxWidth, constraints.maxHeight);
    // var childBoxConstraints = BoxConstraints.tight(
    //   Size(childWidth / 2, childWidth / 2),
    // );
    // print('getConstraintsForChild childBoxConstraints = $childBoxConstraints ');
    // return childBoxConstraints;
    // return constraints;
    return BoxConstraints(
        minWidth: constraints.minWidth, minHeight: 200, maxHeight: 320);
  }

  @override
  Offset getPositionForChild(Size size, Size childSize) {
    // 确定child的位置，返回一个相对于parent的偏移值
    // size是layout的大小，由getSize确定
    // childSize由getConstraintsForChild得出的Constraints对child进行约束，得到child自身的size
    mlogD("BasePositionPop", 'size = $size childSize = $childSize');
    // var dx = (size.width - childSize.width) / 2;
    // var dy = (size.height - childSize.height) / 2;
    // print('dx = $dx dy = $dy');
    // return Offset(dx, dy);
    if (position != null) {
      return Offset(0, position!.top);
    }
    return Offset.zero;
  }
}
