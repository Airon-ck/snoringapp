import 'package:flutter/material.dart';

class H extends SizedBox {
  H(double gap) : super(height: gap);
}

class W extends SizedBox {
  W(double gap) : super(width: gap);
}

class D extends SizedBox {
  D(
      {double width = double.infinity,
      double height = 1,
      Color color = const Color(0x0f000000)})
      : super(
            width: width,
            height: height,
            child: Divider(
              thickness: height,
              color: color,
            ));
}

// padding divider
class PD extends StatelessWidget {
  final double? height;
  final double? paddingLeft;
  final double? paddingRight;
  final Color? color;

  const PD(
    this.height,
    this.paddingLeft,
    this.paddingRight, {
    Key? key,
    this.color = const Color(0x0f000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: paddingLeft!, right: paddingRight!),
        child: SizedBox(
            width: double.infinity,
            height: height,
            child: Divider(color: color)));
  }
}

class VD extends StatelessWidget {
  final double? height;
  final double? width;
  final Color? color;
  final double? thickness;

  const VD(
    this.height, {
    Key? key,
    this.width = 1.0,
    this.color = const Color(0x0f000000),
    this.thickness = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: width,
        height: height,
        child: VerticalDivider(color: color, thickness: thickness));
  }
}

class Circle extends StatelessWidget {
  final double? width;
  final Color? color;

  const Circle(
    this.width, {
    Key? key,
    this.color = const Color(0x0f000000),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: width,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color!,
      ),
    );
  }
}

//dash divider
class DD extends StatelessWidget {
  final double height;
  final Color color;
  final double dashWidth;
  final double paddingLeft;
  final double paddingRight;

  const DD(
      {Key? key,
      this.height = 1,
      this.color = const Color(0x0f000000),
      this.dashWidth = 5,
      this.paddingLeft = 0,
      this.paddingRight = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth =
            constraints.constrainWidth() - paddingLeft - paddingRight;
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        return Padding(
            padding: EdgeInsets.only(left: paddingLeft, right: paddingRight),
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: List.generate(dashCount, (_) {
                return SizedBox(
                  width: dashWidth,
                  height: dashHeight,
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: color),
                  ),
                );
              }),
            ));
      },
    );
  }
}

// 自定义虚线 垂直方向
class DL extends StatelessWidget {
  final double dashedWidth; // 根据虚线的方向确定自己虚线的宽度
  final double dashedHeight; // 根据虚线的方向确定自己虚线的高度
  final int count; // 内部会根据设置的个数和宽度确定密度(虚线的空白间隔)
  final Color color; // 虚线的颜色

  const DL({
    super.key,
    this.dashedWidth = 1,
    this.dashedHeight = 5,
    this.count = 25,
    this.color = const Color(0x0f000000),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      // 根据宽度计算个数
      return Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(count, (_) {
          return SizedBox(
            width: dashedWidth,
            height: dashedHeight,
            child: DecoratedBox(
              decoration: BoxDecoration(color: color),
            ),
          );
        }),
      );
    });
  }
}
