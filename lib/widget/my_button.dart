import 'package:flutter/material.dart';

/// 默认字号18，白字蓝底，高度48
class MyButton extends StatelessWidget {
  const MyButton({
    Key? key,
    this.text = '',
    this.fontSize = 18,
    this.textColor,
    this.disabledTextColor,
    this.backgroundColor,
    this.disabledBackgroundColor,
    this.minHeight = 48.0,
    this.minWidth = double.infinity,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.radius = 2.0,
    this.side = BorderSide.none,
    this.fontWeight = FontWeight.normal,
    required this.onPressed,
  }) : super(key: key);

  final String? text;
  final double? fontSize;
  final Color? textColor;
  final Color? disabledTextColor;
  final Color? backgroundColor;
  final Color? disabledBackgroundColor;
  final double? minHeight;
  final double? minWidth;
  final VoidCallback? onPressed;
  final EdgeInsetsGeometry? padding;
  final double? radius;
  final BorderSide? side;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          splashFactory: NoSplash.splashFactory,
          // 文字颜色
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) {
              if (states.contains(MaterialState.disabled)) {
                return disabledTextColor ?? Color(0xFFD4E2FA);
              }
              return textColor ?? (Colors.white);
            },
          ),
          // 背景颜色
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.disabled)) {
              return disabledBackgroundColor ?? Color(0xFF96BBFA);
            }
            return backgroundColor ?? Color(0xFF4688FA);
          }),
          // 水波纹
          overlayColor: MaterialStateProperty.resolveWith((states) {
            return (textColor ?? (Colors.white)).withOpacity(0.12);
          }),
          // 按钮最小大小
          minimumSize: (minWidth == null || minHeight == null)
              ? null
              : MaterialStateProperty.all<Size>(Size(minWidth!, minHeight!)),
          padding: MaterialStateProperty.all<EdgeInsetsGeometry>(padding!),
          shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(radius!),
            ),
          ),
          side: MaterialStateProperty.all<BorderSide>(side!),
        ),
        child: Text(
          text!,
          style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
        ));
  }
}
