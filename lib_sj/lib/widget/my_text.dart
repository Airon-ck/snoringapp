import 'package:flutter/material.dart';

class SjText extends StatelessWidget {
  final Key? key;

  final String content;

  //是否最后用省略号展示
  final bool endOverflow;

  final double? fontSize;

  final int? maxLines;

  final Color? color;

  final FontWeight? fontWeight;

  final TextAlign? textAlign;

  final bool hasExpand;

  final AlignmentGeometry? alignment;

  final TextWidthBasis? textWidthBasis;

  SjText(this.content,
      {this.fontSize = 16,
      this.key,
      this.color = Colors.black87,
      this.fontWeight = FontWeight.normal,
      this.endOverflow = false,
      this.hasExpand = false,
      this.textAlign = TextAlign.start,
      this.alignment = Alignment.center,
      this.maxLines,
      this.textWidthBasis})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return hasExpand
        ? Expanded(
            child: Container(
              alignment: alignment,
              child: getTextView(),
            ),
          )
        : getTextView();
  }

  Widget getTextView() {
    return Text(
      !endOverflow ? content : breakWord(content),
      textAlign: textAlign,
      overflow: endOverflow ? TextOverflow.ellipsis : null,
      maxLines: maxLines,
      textWidthBasis: textWidthBasis,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontSize: fontSize,
        color: color,
        fontWeight: fontWeight,
      ),
    );
  }
}

class SjTextViewContainer extends StatelessWidget {
  final Key? key;

  final String content;

  //是否最后用省略号展示
  final bool endOverflow;

  final double? fontSize;

  final int? maxLines;

  final Color? color;

  final FontWeight? fontWeight;

  final TextAlign? textAlign;

  final bool hasExpand;

  EdgeInsetsGeometry? padding;

  EdgeInsetsGeometry? margin;

  final Color? bgColor;

  final Decoration? decoration;

  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;

  final double? topMargin;
  final double? bottomMargin;
  final double? leftMargin;
  final double? rightMargin;

  final AlignmentGeometry? alignment;

  final TextWidthBasis? textWidthBasis;

  SjTextViewContainer(
    this.content, {
    this.fontSize = 12,
    this.key,
    this.color = Colors.black87,
    this.fontWeight = FontWeight.normal,
    this.endOverflow = false,
    this.hasExpand = false,
    this.textAlign = TextAlign.start,
    this.padding,
    this.margin,
    this.bgColor,
    this.decoration,
    this.maxLines,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.topMargin,
    this.bottomMargin,
    this.leftMargin,
    this.rightMargin,
    this.alignment,
    this.textWidthBasis,
  }) : super(key: key) {
    if (padding == null &&
        (topPadding != null ||
            bottomPadding != null ||
            leftPadding != null ||
            rightPadding != null)) {
      padding = EdgeInsets.only(
          left: leftPadding ?? 0,
          right: rightPadding ?? 0,
          top: topPadding ?? 0,
          bottom: bottomPadding ?? 0);
    }
    if (margin == null &&
        (topMargin != null ||
            bottomMargin != null ||
            leftMargin != null ||
            rightMargin != null)) {
      margin = EdgeInsets.only(
          left: leftMargin ?? 0,
          right: rightMargin ?? 0,
          top: topMargin ?? 0,
          bottom: bottomMargin ?? 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      color: bgColor,
      decoration: decoration,
      alignment: alignment,
      child: SjText(
        content,
        fontSize: fontSize,
        key: key,
        color: color,
        fontWeight: fontWeight,
        endOverflow: endOverflow,
        hasExpand: hasExpand,
        textAlign: textAlign,
        maxLines: maxLines,
        textWidthBasis: textWidthBasis,
      ),
    );
  }
}

String breakWord(String word) {
  if (word == null || word.isEmpty) {
    return word;
  }
  String breakWord = '';
  word.runes.forEach((element) {
    breakWord += String.fromCharCode(element);
    breakWord += '\u200B';
  });
  return breakWord;
}
