import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lib_sj/function/value_change_listener_func.dart';
import 'package:lib_sj/util/common_util/log_utils.dart';
import 'package:lib_sj/widget/my_text.dart';
import 'package:lib_sj/widget/popwindows/base/base_pop.dart';
import 'package:lib_sj/widget/sj_image_view.dart';

/// 轮视图
class PopWheelView<T extends BaseWheelData> extends StatefulWidget {
  String title;
  List<T> dataList;

  dynamic tag;
  dynamic tag1;
  int defaultIndex = 0;

  Value4ChangeListener<T, int, dynamic, dynamic> valueChanged;

  PopWheelView(
    this.title,
    this.dataList,
    this.valueChanged, {
    super.key,
    this.tag,
    this.tag1,
    this.defaultIndex = 0,
  });

  @override
  State<StatefulWidget> createState() {
    return _PopWheelViewState();
  }
}

class _PopWheelViewState extends State<PopWheelView> {
  int selectIndex = 0;

  late FixedExtentScrollController scrollController;

  @override
  void initState() {
    super.initState();
    selectIndex = widget.defaultIndex;
    scrollController = FixedExtentScrollController(initialItem: selectIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          const Expanded(child: SizedBox()),
          Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                topLeft: Radius.circular(8),
              ),
            ),
            padding:
                EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SjText(widget.title,
                              fontSize: 18,
                              color: const Color(0xff35324B),
                              fontWeight: FontWeight.w600),
                        )),
                    Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SjCommonImageView('ic_dialog_close_black',
                                width: 16, height: 16),
                          ),
                          onTap: () {
                            widget.valueChanged.call(
                                widget.dataList[selectIndex],
                                selectIndex,
                                widget.tag,
                                widget.tag1);
                            BasePop.dismiss(context);
                          },
                        )),
                  ],
                ),
                SizedBox(
                  height: 200,
                  child: CupertinoPicker.builder(
                    backgroundColor: Colors.transparent,
                    itemExtent: 44,
                    scrollController: scrollController,
                    onSelectedItemChanged: (int index) {
                      selectIndex = index;
                      mlogD("PopWheelView", "index=${index}");
                    },
                    useMagnifier: true,
                    childCount: widget.dataList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        height: 44,
                        alignment: Alignment.center,
                        child: SjText(
                          widget.dataList[index].getTitle(),
                          fontSize: 16,
                          color: const Color(0xff35324B),
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

abstract class BaseWheelData {
  getTitle();
}
