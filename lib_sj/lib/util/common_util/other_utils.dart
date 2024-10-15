import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';
import 'package:keyboard_actions/keyboard_actions_item.dart';
import 'package:lib_sj/generated/lib_sj_text.dart';
import 'package:lib_sj/util/common_util/money_util.dart';
import 'package:lib_sj/util/common_util/num_util.dart';
import 'package:lib_sj/util/toast.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  /// 打开链接
  static Future<void> launchWebURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ToastUtil.showLong(getSjTextByKey("failed_to_open_url")!);
    }
  }

  /// 调起拨号页
  static Future<void> launchTelURL(String phone) async {
    final String url = 'tel:$phone';
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ToastUtil.showLong(getSjTextByKey('dial_failed')!);
    }
  }

  static String formatPrice(String price,
      {MoneyFormat format = MoneyFormat.END_INTEGER}) {
    return MoneyUtil.changeYWithUnit(
        NumUtil.getDoubleByValueStr(price) ?? 0, MoneyUnit.YUAN,
        format: format);
  }

  static KeyboardActionsConfig getKeyboardActionsConfig(
      BuildContext context, List<FocusNode> list) {
    return KeyboardActionsConfig(
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: List.generate(
          list.length,
          (i) => KeyboardActionsItem(
                focusNode: list[i],
                toolbarButtons: [
                  (node) {
                    return GestureDetector(
                      onTap: () => node.unfocus(),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Text(getSjTextByKey('close')!),
                      ),
                    );
                  },
                ],
              )),
    );
  }
}

Future<T?> showElasticDialog<T>({
  required BuildContext context,
  bool barrierDismissible = true,
  required WidgetBuilder builder,
}) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (BuildContext buildContext, Animation<double> animation,
        Animation<double> secondaryAnimation) {
      final Widget pageChild = Builder(builder: builder);
      return SafeArea(
        child: pageChild,
      );
    },
    barrierDismissible: barrierDismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black54,
    transitionDuration: const Duration(milliseconds: 550),
    transitionBuilder: _buildDialogTransitions,
  );
}

Widget _buildDialogTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child) {
  return FadeTransition(
    opacity: CurvedAnimation(
      parent: animation,
      curve: Curves.easeOut,
    ),
    child: SlideTransition(
      position: Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero)
          .animate(CurvedAnimation(
        parent: animation,
        curve: const ElasticOutCurve(0.85),
        reverseCurve: Curves.easeOutBack,
      )),
      child: child,
    ),
  );
}

/// String 空安全处理
extension StringExtension on String? {
  String get nullSafe => this ?? '';
}
