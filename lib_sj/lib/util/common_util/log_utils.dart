import 'dart:convert' as convert;
import 'package:lib_sj/common/app_setting.dart';

enum LogMode {
  /// Use `dart:developer`'s function.
  log,

  /// Use [print] function.
  print
}

const String _tag = 'APP_LOG';

class BaseLog {
  static const String _defTag = 'Base_Log';
  static const String _defStartTag = '▶    ';
  static const String _defStartWainTag = '⚠️ ';
  static const String _defStartDTag = '→️ ';
  static const String _defStartInfoTag = '☆ ';
  static const String _defStartFTag = '💚 ';
  static const String _defStartKTag = '♬ ';
  static bool _debugMode = false; //是否是debug模式,true: log v 不输出.
  static int _maxLen = 500;

  static d(String? tag, Object? object) {
    _printLog(_defStartInfoTag, tag, object);
  }

  static i(String? tag, Object? object) {
    _printLog(_defStartDTag, tag, object);
  }

  static e(String? tag, Object? object) {
    _printLog(_defStartWainTag, tag, object);
  }

  static f(String? tag, Object? object) {
    _printLog(_defStartFTag, tag, object);
  }

  static k(String? tag, Object? object) {
    _printLog(_defStartKTag, tag, object);
  }

  static void _printLog(String? stag, String? tag, Object? object) {
    String content = object?.toString() ?? '--->null';
    stag = stag ?? _defStartTag;
    tag = tag ?? _defTag;
    // print('$stag$tag ：$content');
    if (content.length <= _maxLen) {
      print('$stag$tag ：$content');
      return;
    }
    _printLongLog(stag, tag, object);
    // if (content.length <= _maxLen) {
    //   print('$stag$tag ：$content');
    //   return;
    // }
    // print(
    //     '$stag$tag — — — — — — — — — — — — — — — — start — — — — — — — — — — — — — — — —');
    // while (content.isNotEmpty) {
    //   if (content.length > _maxLen) {
    //     print('$stag$tag| ${content.substring(0, _maxLen)}');
    //     content = content.substring(_maxLen, content.length);
    //   } else {
    //     print('$stag$tag| $content');
    //     content = '';
    //   }
    // }
    // print(
    //     '$stag$tag — — — — — — — — — — — — — — — — end — — — — — — — — — — — — — — — —');
  }

  static void _printLongLog(String? stag, String? tag, Object? object) {
    String content = object?.toString() ?? '--->null';
    stag = stag ?? _defStartTag;
    tag = tag ?? _defTag;
    if (content.length <= _maxLen) {
      print('$stag$tag ：$content');
      return;
    }
    print(
        '$stag$tag — — — — — — — — — — — — — — — — start — — — — — — — — — — — — — — — —');
    while (content.isNotEmpty) {
      if (content.length > _maxLen) {
        print('${content.substring(0, _maxLen)}');
        // print('$stag$tag| ${content.substring(0, _maxLen)}');
        content = content.substring(_maxLen, content.length);
      } else {
        print('$content');
        // print('$stag$tag| $content');
        content = '';
      }
    }
    print(
        '$stag$tag — — — — — — — — — — — — — — — — end — — — — — — — — — — — — — — — —');
  }
}

/// 输出Log工具类
class MLog {
  static const String tag = 'APP_LOG';

  static void init() {}

  static void d(String tag, String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.d(tag, msg);
    }
  }

  static void dl(String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.d(tag, msg);
    }
  }

  static void f(String tag, String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.f(tag, msg);
    }
  }

  static void fl(String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.f(tag, msg);
    }
  }

  static void k(String tag, String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.k(tag, msg);
    }
  }

  static void kl(String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.k(tag, msg);
    }
  }

  static void e(String tag, String? msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.e(tag, msg);
    }
  }

  static void el(String msg) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.e(tag, msg);
    }
  }

  static void json(String tag, String msg) {
    if (!AppSetting.isReleaseMode) {
      try {
        final dynamic data = convert.json.decode(msg);
        if (data is Map) {
          _printMap(data, tag: tag);
        } else if (data is List) {
          _printList(data, tag: tag);
        } else
          BaseLog.d(tag, msg);
      } catch (e) {
        BaseLog.e(tag, msg);
      }
    }
  }

  static void jsonL(String msg, {String tag = tag}) {
    if (!AppSetting.isReleaseMode) {
      try {
        final dynamic data = convert.json.decode(msg);
        if (data is Map) {
          _printMap(data, tag: tag);
        } else if (data is List) {
          _printList(data, tag: tag);
        } else
          // BaseLog.d(tag, msg);
          BaseLog._printLongLog(tag, msg, null);
      } catch (e) {
        BaseLog.e(tag, msg);
      }
    }
  }

  static void printLongContent(String msg, {String tag = tag}) {
    if (!AppSetting.isReleaseMode) {
      try {
        BaseLog._printLog(tag, "_maxLen=---${msg.length}", null);
        BaseLog._printLongLog(tag, null, msg);
      } catch (e) {
        BaseLog.e(tag, msg);
      }
    }
  }

  // https://github.com/Milad-Akarie/pretty_dio_logger
  static void _printMap(Map data,
      {String tag = tag,
      int tabs = 1,
      bool isListItem = false,
      bool isLast = false}) {
    final bool isRoot = tabs == 1;
    final String initialIndent = _indent(tabs);
    tabs++;

    if (isRoot || isListItem) {
      BaseLog.d(tag, '$initialIndent{');
    }

    data.keys.toList().asMap().forEach((index, dynamic key) {
      final bool isLast = index == data.length - 1;
      dynamic value = data[key];
      if (value is String) {
        value = '"$value"';
      }
      if (value is Map) {
        if (value.isEmpty)
          BaseLog.d(tag, '${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
        else {
          BaseLog.d(tag, '${_indent(tabs)} $key: {');
          _printMap(value, tabs: tabs, tag: tag);
        }
      } else if (value is List) {
        if (value.isEmpty) {
          BaseLog.d(tag, '${_indent(tabs)} $key: ${value.toString()}');
        } else {
          BaseLog.d(tag, '${_indent(tabs)} $key: [');
          _printList(value, tabs: tabs, tag: tag);
          BaseLog.d(tag, '${_indent(tabs)} ]${isLast ? '' : ','}');
        }
      } else {
        final msg = value.toString().replaceAll('\n', '');
        BaseLog.d(tag, '${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
      }
    });

    BaseLog.d(tag, '$initialIndent}${isListItem && !isLast ? ',' : ''}');
  }

  static void _printList(List list, {String tag = tag, int tabs = 1}) {
    list.asMap().forEach((i, dynamic e) {
      final bool isLast = i == list.length - 1;
      if (e is Map) {
        if (e.isEmpty) {
          BaseLog.d(tag, '${_indent(tabs)}  $e${!isLast ? ',' : ''}');
        } else {
          _printMap(e,
              tabs: tabs + 1, isListItem: true, isLast: isLast, tag: tag);
        }
      } else {
        BaseLog.d(tag, '${_indent(tabs + 2)} $e${isLast ? '' : ','}');
      }
    });
  }

  static String _indent([int tabCount = 1]) => '  ' * tabCount;
}

mlogD(String tag, String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.d(tag, msg);
  }
}

mlogDl(String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.d(_tag, msg);
  }
}

mlogF(String tag, String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.f(tag, msg);
  }
}

mlogFl(String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.f(_tag, msg);
  }
}

mlogK(String tag, String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.k(tag, msg);
  }
}

mlogKl(String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.k(_tag, msg);
  }
}

mlogE(String tag, String? msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.e(tag, msg);
  }
}

mlogEl(String msg) {
  if (!AppSetting.isReleaseMode) {
    BaseLog.e(_tag, msg);
  }
}

mlogJson(String tag, String msg) {
  if (!AppSetting.isReleaseMode) {
    try {
      final dynamic data = convert.json.decode(msg);
      if (data is Map) {
        _printMap(data, tag: tag);
      } else if (data is List) {
        _printList(data, tag: tag);
      } else
        BaseLog.d(tag, msg);
    } catch (e) {
      BaseLog.e(tag, msg);
    }
  }
}

mlogJsonL(String msg, {String tag = _tag}) {
  if (!AppSetting.isReleaseMode) {
    try {
      final dynamic data = convert.json.decode(msg);
      if (data is Map) {
        _printMap(data, tag: tag);
      } else if (data is List) {
        _printList(data, tag: tag);
      } else
// BaseLog.d(tag, msg);
        BaseLog._printLongLog(tag, msg, null);
    } catch (e) {
      BaseLog.e(tag, msg);
    }
  }
}

printLongContent(String msg, {String tag = _tag}) {
  if (!AppSetting.isReleaseMode) {
    try {
      BaseLog._printLog(tag, "_maxLen=---${msg.length}", null);
      BaseLog._printLongLog(tag, null, msg);
    } catch (e) {
      BaseLog.e(tag, msg);
    }
  }
}

// https://github.com/Milad-Akarie/pretty_dio_logger
_printMap(Map data,
    {String tag = _tag,
    int tabs = 1,
    bool isListItem = false,
    bool isLast = false}) {
  final bool isRoot = tabs == 1;
  final String initialIndent = _indent(tabs);
  tabs++;

  if (isRoot || isListItem) {
    BaseLog.d(tag, '$initialIndent{');
  }

  data.keys.toList().asMap().forEach((index, dynamic key) {
    final bool isLast = index == data.length - 1;
    dynamic value = data[key];
    if (value is String) {
      value = '"$value"';
    }
    if (value is Map) {
      if (value.isEmpty)
        BaseLog.d(tag, '${_indent(tabs)} $key: $value${!isLast ? ',' : ''}');
      else {
        BaseLog.d(tag, '${_indent(tabs)} $key: {');
        _printMap(value, tabs: tabs, tag: tag);
      }
    } else if (value is List) {
      if (value.isEmpty) {
        BaseLog.d(tag, '${_indent(tabs)} $key: ${value.toString()}');
      } else {
        BaseLog.d(tag, '${_indent(tabs)} $key: [');
        _printList(value, tabs: tabs, tag: tag);
        BaseLog.d(tag, '${_indent(tabs)} ]${isLast ? '' : ','}');
      }
    } else {
      final msg = value.toString().replaceAll('\n', '');
      BaseLog.d(tag, '${_indent(tabs)} $key: $msg${!isLast ? ',' : ''}');
    }
  });

  BaseLog.d(tag, '$initialIndent}${isListItem && !isLast ? ',' : ''}');
}

_printList(List list, {String tag = _tag, int tabs = 1}) {
  list.asMap().forEach((i, dynamic e) {
    final bool isLast = i == list.length - 1;
    if (e is Map) {
      if (e.isEmpty) {
        BaseLog.d(tag, '${_indent(tabs)}  $e${!isLast ? ',' : ''}');
      } else {
        _printMap(e,
            tabs: tabs + 1, isListItem: true, isLast: isLast, tag: tag);
      }
    } else {
      BaseLog.d(tag, '${_indent(tabs + 2)} $e${isLast ? '' : ','}');
    }
  });
}

String _indent([int tabCount = 1]) => '  ' * tabCount;

extension StringLog on String {
  mlogD(String tag) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.d(tag, this);
    }
  }

  mlogD1() {
    if (!AppSetting.isReleaseMode) {
      BaseLog.d(_tag, this);
    }
  }

  mlogF(String tag) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.f(tag, this);
    }
  }

  mlogF1() {
    if (!AppSetting.isReleaseMode) {
      BaseLog.f(_tag, this);
    }
  }

  mlogK(String tag) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.k(tag, this);
    }
  }

  mlogKl() {
    if (!AppSetting.isReleaseMode) {
      BaseLog.k(_tag, this);
    }
  }

  mlogE(String tag) {
    if (!AppSetting.isReleaseMode) {
      BaseLog.e(tag, this);
    }
  }

  mlogEl() {
    if (!AppSetting.isReleaseMode) {
      BaseLog.e(_tag, this);
    }
  }
}
