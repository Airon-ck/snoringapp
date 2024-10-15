import 'package:flutter/material.dart';

///等比例控件
class RatioWidget extends StatelessWidget {
  final double? ratio;
  final Widget? child;
  final double? width;

  const RatioWidget({
    this.ratio,
    this.child,
    this.width = double.infinity,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: ratio!,
      child: SizedBox(
        width: width,
        child: child,
      ),
    );
  }
}
