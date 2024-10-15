import 'package:flutter/material.dart';
import 'package:snoring_app/common/space.dart';
import 'round_corner_widget.dart';

class SmartButton extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color textColor;
  final int textMaxLine;
  final TextOverflow textOverflow;
  final Color backgroundColor;
  final double height;
  final double? width;
  final VoidCallback? onPressed;
  final double radius;
  final BorderSide side;
  final int cornerPosition;
  final EdgeInsetsGeometry padding;
  final double borderWidth;
  final Color borderColor;
  final List<BoxShadow>? boxShadowList;
  final Widget? drawableLeft;
  final Widget? drawableTop;
  final Widget? drawableRight;
  final Widget? drawableBottom;
  final double drawablePadding;
  final bool? inWrap;
  final FontWeight? fontWeight;

  const SmartButton(
      {Key? key,
      this.text = '',
      this.fontSize = 14,
      this.fontWeight = FontWeight.w400,
      this.textColor = Colors.black,
      this.textMaxLine = 1,
      this.textOverflow = TextOverflow.ellipsis,
      this.backgroundColor = Colors.transparent,
      this.height = 20,
      this.width,
      this.onPressed,
      this.radius = 0,
      this.cornerPosition = CornerPosition.ALL,
      this.side = BorderSide.none,
      this.padding = EdgeInsets.zero,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.boxShadowList,
      this.drawableLeft,
      this.drawableTop,
      this.drawableRight,
      this.drawableBottom,
      this.drawablePadding = 0,
      this.inWrap = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: Container(
            padding: padding,
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: backgroundColor,
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
            ),
            child: buildChild()));
  }

  Widget buildChild() {
    Widget widget = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (drawableLeft != null) drawableLeft!,
          if (drawableLeft != null) W(drawablePadding),
          Column(mainAxisSize: MainAxisSize.min, children: [
            if (drawableTop != null) drawableTop!,
            if (drawableTop != null) H(drawablePadding),
            Text(text,
                maxLines: textMaxLine,
                overflow: textOverflow,
                style: TextStyle(
                    fontSize: fontSize,
                    color: textColor,
                    fontWeight: fontWeight)),
            if (drawableBottom != null) H(drawablePadding),
            if (drawableBottom != null) drawableBottom!,
          ]),
          if (drawableRight != null) W(drawablePadding),
          if (drawableRight != null) drawableRight!,
        ]);
    if (inWrap != true) {
      widget =
          Center(child: ColoredBox(color: Colors.transparent, child: widget));
    }
    return widget;
  }
}
