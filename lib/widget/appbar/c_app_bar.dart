import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snoring_app/common/space.dart';
import 'package:lib_sj/util/device_utils.dart';
import 'package:lib_sj/widget/sj_image_view.dart';

/// 顶部TopBar
class CAppBar extends StatefulWidget implements PreferredSizeWidget {
  final Color bgColor;
  final String title;
  final String secondTitle;
  final int titleMaxLine;
  final TextOverflow titleOverFlow;
  final Color titleColor;
  final Color secondTitleColor;
  final TitlePosition titlePosition;
  final String backImgUrl;
  final void Function()? onBack;
  final List<Widget> actions;
  final void Function(int)? onPressed;
  final bool showBackImg;
  final List<Widget> leftActions;
  final SystemUiOverlayStyle? overlayStyle;
  final FontWeight? titleFontWeight;
  final bool isSafeAreaPaddingTop;
  final double? titleTextSize;
  final double? secondTitleTextSize;

  const CAppBar({
    Key? key,
    this.bgColor = Colors.transparent,
    this.title = '',
    this.secondTitle = '',
    this.titleColor = Colors.black,
    this.secondTitleColor = const Color(0xff666666),
    this.titlePosition = TitlePosition.center,
    this.titleFontWeight = FontWeight.normal,
    this.titleTextSize = 18,
    this.secondTitleTextSize = 12,
    this.titleMaxLine = 1,
    this.titleOverFlow = TextOverflow.ellipsis,
    this.backImgUrl = '',
    this.onBack,
    this.actions = const [],
    this.leftActions = const [],
    this.onPressed,
    this.showBackImg = true,
    this.isSafeAreaPaddingTop = true,
    this.overlayStyle = SystemUiOverlayStyle.dark,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _CAppBarState();
  }

  @override
  Size get preferredSize => const Size.fromHeight(48);
}

class _CAppBarState extends State<CAppBar> {
  late String _backImgUrl;
  late SystemUiOverlayStyle? _overlayStyle;

  @override
  Widget build(BuildContext context) {
    _backImgUrl = widget.backImgUrl;
    _overlayStyle = widget.overlayStyle;

    _overlayStyle ??=
        ThemeData.estimateBrightnessForColor(widget.bgColor) == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark;
    if (_backImgUrl.isEmpty) {
      if (_overlayStyle == SystemUiOverlayStyle.light) {
        _backImgUrl = 'ic_return_white';
      } else {
        _backImgUrl = 'ic_return_black';
      }
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: _overlayStyle!,
        child: Material(
            color: widget.bgColor,
            child: SafeArea(
              top: widget.isSafeAreaPaddingTop,
              left: false,
              right: false,
              bottom: false,
              child: SizedBox(
                height: 48,
                child:
                    Stack(alignment: Alignment.centerLeft, children: <Widget>[
                  buildBackImg(),
                  buildLeftActions(),
                  buildTitle(),
                  buildActions(),
                ]),
              ),
            )));
  }

  Widget buildBackImg() {
    return widget.showBackImg
        ? IconButton(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onPressed: () async {
              if (widget.onBack != null) {
                widget.onBack!();
              } else {
                FocusManager.instance.primaryFocus?.unfocus();
                final isBack = await Navigator.maybePop(context);
                if (!isBack) {
                  await SystemNavigator.pop();
                }
              }
            },
            // tooltip: 'Back',
            padding: const EdgeInsets.all(12.0),
            icon: SjLoadImage(
              _backImgUrl,
              fit: BoxFit.cover,
              // color: backImgColor ?? ThemeUtils.getIconColor(context),
            ),
          )
        : W(0);
  }

  Widget buildTitle() {
    AlignmentGeometry align = Alignment.center;
    if (widget.titlePosition == TitlePosition.left) {
      align = Alignment.centerLeft;
    } else if (widget.titlePosition == TitlePosition.androidLeftIosCenter) {
      if (DeviceUtils.isAndroid) {
        align = Alignment.centerLeft;
      }
    }
    return Container(
      alignment: align,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 48.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
              child: Text(
            widget.title,
            maxLines: widget.titleMaxLine,
            overflow: widget.titleOverFlow,
            style: TextStyle(
                fontSize: widget.titleTextSize,
                color: widget.titleColor,
                fontWeight: widget.titleFontWeight!),
          )),
          if (widget.secondTitle != '')
            Flexible(
                child: Text(
              widget.secondTitle,
              maxLines: widget.titleMaxLine,
              overflow: widget.titleOverFlow,
              style: TextStyle(
                  fontSize: widget.secondTitleTextSize,
                  color: widget.secondTitleColor,
                  fontWeight: FontWeight.normal),
            )),
        ],
      ),
    );
  }

  Widget buildActions() {
    List<Widget> actions = [];
    widget.actions.forEach((element) {
      actions.add(element);
    });
    return Positioned(
      right: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [...actions],
      ),
    );
  }

  Widget buildLeftActions() {
    List<Widget> actions = [];
    widget.leftActions.forEach((element) {
      actions.add(element);
    });
    return Positioned(
      left: 0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [...actions],
      ),
    );
  }
}

enum TitlePosition { left, center, androidLeftIosCenter }
