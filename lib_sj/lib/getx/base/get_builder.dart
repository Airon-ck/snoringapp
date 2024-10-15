import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

typedef MyBuilder<T> = Widget Function(BuildContext context, T value);

class MyGetBuilder<T extends GetxController> extends StatefulWidget {
  final MyBuilder<T> builder;
  final String? id;
  final T controller;
  final Widget? child;
  final String? tag;
  final Function(T? controller)? onModelReady;
  final bool autoDispose;

  MyGetBuilder({
    Key? key,
    required this.builder,
    required this.controller,
    this.child,
    this.id,
    this.onModelReady,
    this.tag,
    this.autoDispose: true,
  }) : super(key: key);

  @override
  _MyGetBuilderState<T> createState() {
    return _MyGetBuilderState<T>();
  }
}

class _MyGetBuilderState<T extends GetxController>
    extends State<MyGetBuilder<T>> {
  late T controller;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
    widget.onModelReady?.call(controller);
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<T>(
        id: widget.id,
        tag: widget.tag,
        init: controller,
        builder: (controller) {
          return widget.builder(context, controller);
        });
  }
}
