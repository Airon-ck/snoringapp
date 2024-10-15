// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(second) => "resend (${second}s)";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
        "appName": MessageLookupByLibrary.simpleMessage("安睡有氧"),
        "canLoadingText":
            MessageLookupByLibrary.simpleMessage("Release to load more"),
        "canRefreshText":
            MessageLookupByLibrary.simpleMessage("Release to refresh"),
        "canTwoLevelText": MessageLookupByLibrary.simpleMessage(
            "Release to enter secondfloor"),
        "copied": MessageLookupByLibrary.simpleMessage("Copied！"),
        "denied_permission_desc": MessageLookupByLibrary.simpleMessage(
            "You denied the permission, causing the function to be unavailable！"),
        "download_completed":
            MessageLookupByLibrary.simpleMessage("Download completed"),
        "downloading": MessageLookupByLibrary.simpleMessage("Downloading"),
        "exit_app":
            MessageLookupByLibrary.simpleMessage("Click again to exit APP"),
        "go_update": MessageLookupByLibrary.simpleMessage("Deupdate"),
        "idleLoadingText":
            MessageLookupByLibrary.simpleMessage("Pull up Load more"),
        "idleRefreshText":
            MessageLookupByLibrary.simpleMessage("Pull down Refresh"),
        "input_content_cannot_be_empty": MessageLookupByLibrary.simpleMessage(
            "The input content cannot be empty！"),
        "loadFailedText": MessageLookupByLibrary.simpleMessage("Load Failed"),
        "loadingText": MessageLookupByLibrary.simpleMessage("Loading…"),
        "network_unavailable":
            MessageLookupByLibrary.simpleMessage("Network unavailable!"),
        "noMoreText": MessageLookupByLibrary.simpleMessage("No more data"),
        "no_data": MessageLookupByLibrary.simpleMessage("NO DATA"),
        "not_updated_temporarily":
            MessageLookupByLibrary.simpleMessage("Not updated temporarily"),
        "refreshCompleteText":
            MessageLookupByLibrary.simpleMessage("Refresh completed"),
        "refreshFailedText":
            MessageLookupByLibrary.simpleMessage("Refresh failed"),
        "refreshingText": MessageLookupByLibrary.simpleMessage("Refreshing…"),
        "resend_code": m0,
        "save_failure": MessageLookupByLibrary.simpleMessage("Save failure!"),
        "save_successfully":
            MessageLookupByLibrary.simpleMessage("Save successfully"),
        "saved_to_album":
            MessageLookupByLibrary.simpleMessage("Saved to album!"),
        "send_code":
            MessageLookupByLibrary.simpleMessage("get verification code"),
        "server_error": MessageLookupByLibrary.simpleMessage(
            "The server is busy, please try again later"),
        "server_processing":
            MessageLookupByLibrary.simpleMessage("Server processing"),
        "skip": MessageLookupByLibrary.simpleMessage("skip"),
        "start_downloading":
            MessageLookupByLibrary.simpleMessage("Start downloading"),
        "try_again": MessageLookupByLibrary.simpleMessage("Please try again")
      };
}
