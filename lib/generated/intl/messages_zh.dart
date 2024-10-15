// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'zh';

  static String m0(second) => "重新发送(${second}s)";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("安睡有氧"),
        "canLoadingText": MessageLookupByLibrary.simpleMessage("松手开始加载数据"),
        "canRefreshText": MessageLookupByLibrary.simpleMessage("松开开始刷新数据"),
        "canTwoLevelText": MessageLookupByLibrary.simpleMessage("释放手势,进入二楼"),
        "copied": MessageLookupByLibrary.simpleMessage("已复制！"),
        "denied_permission_desc":
            MessageLookupByLibrary.simpleMessage("您拒绝了相关权限，造成了该功能无法使用！"),
        "download_completed": MessageLookupByLibrary.simpleMessage("下载完成"),
        "downloading": MessageLookupByLibrary.simpleMessage("正在下载"),
        "exit_app": MessageLookupByLibrary.simpleMessage("再次点击退出APP"),
        "go_update": MessageLookupByLibrary.simpleMessage("去更新"),
        "idleLoadingText": MessageLookupByLibrary.simpleMessage("上拉加载"),
        "idleRefreshText": MessageLookupByLibrary.simpleMessage("下拉刷新"),
        "input_content_cannot_be_empty":
            MessageLookupByLibrary.simpleMessage("输入内容不能为空！"),
        "loadFailedText": MessageLookupByLibrary.simpleMessage("加载失败"),
        "loadingText": MessageLookupByLibrary.simpleMessage("加载中…"),
        "network_unavailable": MessageLookupByLibrary.simpleMessage("当前网络不稳定！"),
        "noMoreText": MessageLookupByLibrary.simpleMessage("没有更多数据了"),
        "no_data": MessageLookupByLibrary.simpleMessage("暂无数据"),
        "not_updated_temporarily": MessageLookupByLibrary.simpleMessage("暂不更新"),
        "refreshCompleteText": MessageLookupByLibrary.simpleMessage("刷新成功"),
        "refreshFailedText": MessageLookupByLibrary.simpleMessage("刷新失败"),
        "refreshingText": MessageLookupByLibrary.simpleMessage("刷新中…"),
        "resend_code": m0,
        "save_failure": MessageLookupByLibrary.simpleMessage("保存失败!"),
        "save_successfully": MessageLookupByLibrary.simpleMessage("保存成功"),
        "saved_to_album": MessageLookupByLibrary.simpleMessage("已保存到相册!"),
        "send_code": MessageLookupByLibrary.simpleMessage("获取验证码"),
        "server_error": MessageLookupByLibrary.simpleMessage("服务器繁忙，请稍后再试"),
        "server_processing": MessageLookupByLibrary.simpleMessage("服务器处理中"),
        "skip": MessageLookupByLibrary.simpleMessage("跳过"),
        "start_downloading": MessageLookupByLibrary.simpleMessage("开始下载"),
        "try_again": MessageLookupByLibrary.simpleMessage("请重试")
      };
}
