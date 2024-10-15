import 'package:flutter/material.dart';

class RoundedCornerWidget extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final double borderWidth;
  final double radius;
  final int cornerPosition;
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  double? width;
  double? height;
  List<BoxShadow>? boxShadowList;
  final Gradient? gradient;
  final ImageProvider? image;

  RoundedCornerWidget(
      {Key? key,
      this.borderColor = Colors.transparent,
      this.backgroundColor = Colors.transparent,
      this.borderWidth = 0,
      this.radius = 0,
      this.cornerPosition = CornerPosition.ALL,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      required this.child,
      this.width,
      this.height,
      this.boxShadowList,
      this.gradient,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      margin: margin,
      decoration: BoxDecoration(
        gradient: gradient,
        color: gradient == null ? backgroundColor : null,
        //如果gradient不为null，且color不为null,gradient会被忽略
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              cornerPosition & CornerPosition.LT == CornerPosition.LT
                  ? radius
                  : 0),
          topRight: Radius.circular(
              cornerPosition & CornerPosition.RT == CornerPosition.RT
                  ? radius
                  : 0),
          bottomRight: Radius.circular(
              cornerPosition & CornerPosition.RB == CornerPosition.RB
                  ? radius
                  : 0),
          bottomLeft: Radius.circular(
              cornerPosition & CornerPosition.LB == CornerPosition.LB
                  ? radius
                  : 0),
        ),
        boxShadow: boxShadowList,
        image: image == null
            ? null
            : DecorationImage(
                image: image!,
                fit: BoxFit.cover,
              ),
      ),
      child: child,
    );
  }
}

class CornerPosition {
  static const int LT = 1;
  static const int RT = 2;
  static const int RB = 4;
  static const int LB = 8;
  static const int TOP = LT | RT;
  static const int BOTTOM = RB | LB;
  static const int LEFT = LT | LB;
  static const int RIGHT = RT | RB;
  static const int ALL = LT | RT | RB | LB;
}
