/**
 * @Author: Sky24n
 * @GitHub: https://github.com/Sky24n
 * @Description: Date Util.
 * @Date: 2018/9/8
 */

import 'package:date_format/date_format.dart';

/// 一些常用格式参照。可以自定义格式，例如：'yyyy/MM/dd HH:mm:ss'，'yyyy/M/d HH:mm:ss'。
/// 格式要求
/// year -> yyyy/yy   month -> MM/M    day -> dd/d
/// hour -> HH/H      minute -> mm/m   second -> ss/s
class DateFormats {
  static String full = 'yyyy-MM-dd HH:mm:ss';
  static String y_mo_d_h_m = 'yyyy-MM-dd HH:mm';
  static String y_mo_d = 'yyyy-MM-dd';
  static String y_mo = 'yyyy-MM';
  static String mo_d = 'MM-dd';
  static String mo_d_h_m = 'MM-dd HH:mm';
  static String h_m_s = 'HH:mm:ss';
  static String h_m = 'HH:mm';

  static String zh_full = 'yyyy年MM月dd日 HH时mm分ss秒';
  static String zh_y_mo_d_h_m = 'yyyy年MM月dd日 HH时mm分';
  static String zh_y_mo_d = 'yyyy年MM月dd日';
  static String zh_y_mo = 'yyyy年MM月';
  static String zh_mo_d = 'MM月dd日';
  static String zh_mo_d_h_m = 'MM月dd日 HH时mm分';
  static String zh_h_m_s = 'HH时mm分ss秒';
  static String zh_h_m = 'HH时mm分';
}

/// month->days.
Map<int, int> MONTH_DAY = {
  1: 31,
  2: 28,
  3: 31,
  4: 30,
  5: 31,
  6: 30,
  7: 31,
  8: 31,
  9: 30,
  10: 31,
  11: 30,
  12: 31,
};

/// Date Util.
class DateUtil {
  /// get DateTime By DateStr.
  static DateTime? getDateTime(String dateStr, {bool isUtc = false}) {
    DateTime? dateTime = DateTime.tryParse(dateStr);
    if (isUtc != null) {
      if (isUtc) {
        dateTime = dateTime?.toUtc();
      } else {
        dateTime = dateTime?.toLocal();
      }
    }
    return dateTime;
  }

  /// get DateTime By Milliseconds.
  static DateTime getDateTimeByMs(int ms, {bool isUtc = false}) {
    return DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
  }

  /// get DateMilliseconds By DateStr.
  static int? getDateMsByTimeStr(String dateStr, {bool isUtc = false}) {
    DateTime? dateTime = getDateTime(dateStr, isUtc: isUtc);
    return dateTime?.millisecondsSinceEpoch;
  }

  /// get Now Date Milliseconds.
  static int getNowDateMs() {
    return DateTime.now().millisecondsSinceEpoch;
  }

  /// get Now Date Str.(yyyy-MM-dd HH:mm:ss)
  static String getNowDateStr() {
    return formatDate(DateTime.now());
  }

  /// format date by milliseconds.
  /// milliseconds 日期毫秒
  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return formatDate(getDateTimeByMs(ms, isUtc: isUtc), format: format);
  }

  /// format date by date str.
  /// dateStr 日期字符串
  static String formatDateStr(String dateStr,
      {bool isUtc = false, String? format}) {
    return formatDate(getDateTime(dateStr, isUtc: isUtc), format: format);
  }

  /// format date by DateTime.
  /// format 转换格式(已提供常用格式 DateFormats，可以自定义格式：'yyyy/MM/dd HH:mm:ss')
  /// 格式要求
  /// year -> yyyy/yy   month -> MM/M    day -> dd/d
  /// hour -> HH/H      minute -> mm/m   second -> ss/s
  static String formatDate(DateTime? dateTime, {String? format}) {
    if (dateTime == null) return '';
    format = format ?? DateFormats.full;
    if (format.contains('yy')) {
      String year = dateTime.year.toString();
      if (format.contains('yyyy')) {
        format = format.replaceAll('yyyy', year);
      } else {
        format = format.replaceAll(
            'yy', year.substring(year.length - 2, year.length));
      }
    }

    format = _comFormat(dateTime.month, format, 'M', 'MM');
    format = _comFormat(dateTime.day, format, 'd', 'dd');
    format = _comFormat(dateTime.hour, format, 'H', 'HH');
    format = _comFormat(dateTime.minute, format, 'm', 'mm');
    format = _comFormat(dateTime.second, format, 's', 'ss');
    format = _comFormat(dateTime.millisecond, format, 'S', 'SSS');

    return format;
  }

  /// com format.
  static String _comFormat(
      int value, String format, String single, String full) {
    if (format.contains(single)) {
      if (format.contains(full)) {
        format =
            format.replaceAll(full, value < 10 ? '0$value' : value.toString());
      } else {
        format = format.replaceAll(single, value.toString());
      }
    }
    return format;
  }

  static List<String> monthZHLunar = const <String>[
    '正月',
    '二月',
    '三月',
    '四月',
    '五月',
    '六月',
    '七月',
    '八月',
    '九月',
    '十月',
    '冬月',
    '腊月'
  ];

  static List<String> monthZH = const <String>[
    '1月',
    '2月',
    '3月',
    '4月',
    '5月',
    '6月',
    '7月',
    '8月',
    '9月',
    '10月',
    '11月',
    '12月'
  ];

  static List<String> monthLong = const <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December'
  ];

  static String getMonth(DateTime? dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return "";
    String month = languageCode == 'zh'
        ? monthZH[dateTime.month - 1]
        : monthLong[dateTime.month - 1];
    return languageCode == 'zh'
        ? month
        : month.substring(0, short ? 3 : month.length);
  }

  /// get WeekDay.
  /// dateTime
  /// isUtc
  /// languageCode zh or en
  /// short
  static String getWeekday(DateTime? dateTime,
      {String languageCode = 'en', bool short = false}) {
    if (dateTime == null) return "";
    String weekday = "";
    switch (dateTime.weekday) {
      case 1:
        weekday = languageCode == 'zh' ? '星期一' : 'Monday';
        break;
      case 2:
        weekday = languageCode == 'zh' ? '星期二' : 'Tuesday';
        break;
      case 3:
        weekday = languageCode == 'zh' ? '星期三' : 'Wednesday';
        break;
      case 4:
        weekday = languageCode == 'zh' ? '星期四' : 'Thursday';
        break;
      case 5:
        weekday = languageCode == 'zh' ? '星期五' : 'Friday';
        break;
      case 6:
        weekday = languageCode == 'zh' ? '星期六' : 'Saturday';
        break;
      case 7:
        weekday = languageCode == 'zh' ? '星期日' : 'Sunday';
        break;
      default:
        break;
    }
    return languageCode == 'zh'
        ? (short ? weekday.replaceAll('星期', '周') : weekday)
        : weekday.substring(0, short ? 3 : weekday.length);
  }

  /// get WeekDay By Milliseconds.
  static String getWeekdayByMs(int milliseconds,
      {bool isUtc = false, String languageCode = 'en', bool short = false}) {
    DateTime dateTime = getDateTimeByMs(milliseconds, isUtc: isUtc);
    return getWeekday(dateTime, languageCode: languageCode, short: short);
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYear(DateTime dateTime) {
    int year = dateTime.year;
    int month = dateTime.month;
    int days = dateTime.day;
    for (int i = 1; i < month; i++) {
      days = days + MONTH_DAY[i]!;
    }
    if (isLeapYearByYear(year) && month > 2) {
      days = days + 1;
    }
    return days;
  }

  /// get day of year.
  /// 在今年的第几天.
  static int getDayOfYearByMs(int ms, {bool isUtc = false}) {
    return getDayOfYear(DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc));
  }

  /// is today.
  /// 是否是当天.
  static bool isToday(int? milliseconds, {bool isUtc = false, int? locMs}) {
    if (milliseconds == null || milliseconds == 0) return false;
    DateTime old =
        DateTime.fromMillisecondsSinceEpoch(milliseconds, isUtc: isUtc);
    DateTime now;
    if (locMs != null) {
      now = DateUtil.getDateTimeByMs(locMs);
    } else {
      now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }
    return old.year == now.year && old.month == now.month && old.day == now.day;
  }

  /// is yesterday by dateTime.
  /// 是否是昨天.
  static bool isYesterday(DateTime dateTime, DateTime locDateTime) {
    if (yearIsEqual(dateTime, locDateTime)) {
      int spDay = getDayOfYear(locDateTime) - getDayOfYear(dateTime);
      return spDay == 1;
    } else {
      return ((locDateTime.year - dateTime.year == 1) &&
          dateTime.month == 12 &&
          locDateTime.month == 1 &&
          dateTime.day == 31 &&
          locDateTime.day == 1);
    }
  }

  /// is yesterday by millis.
  /// 是否是昨天.
  static bool isYesterdayByMs(int ms, int locMs) {
    return isYesterday(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// is Week.
  /// 是否是本周.
  static bool isWeek(int? ms, {bool isUtc = false, int? locMs}) {
    if (ms == null || ms <= 0) {
      return false;
    }
    DateTime _old = DateTime.fromMillisecondsSinceEpoch(ms, isUtc: isUtc);
    DateTime _now;
    if (locMs != null) {
      _now = DateUtil.getDateTimeByMs(locMs, isUtc: isUtc);
    } else {
      _now = isUtc ? DateTime.now().toUtc() : DateTime.now().toLocal();
    }

    DateTime old =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _old : _now;
    DateTime now =
        _now.millisecondsSinceEpoch > _old.millisecondsSinceEpoch ? _now : _old;
    return (now.weekday >= old.weekday) &&
        (now.millisecondsSinceEpoch - old.millisecondsSinceEpoch <=
            7 * 24 * 60 * 60 * 1000);
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqual(DateTime dateTime, DateTime locDateTime) {
    return dateTime.year == locDateTime.year;
  }

  /// year is equal.
  /// 是否同年.
  static bool yearIsEqualByMs(int ms, int locMs) {
    return yearIsEqual(DateTime.fromMillisecondsSinceEpoch(ms),
        DateTime.fromMillisecondsSinceEpoch(locMs));
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYear(DateTime dateTime) {
    return isLeapYearByYear(dateTime.year);
  }

  /// Return whether it is leap year.
  /// 是否是闰年
  static bool isLeapYearByYear(int year) {
    return year % 4 == 0 && year % 100 != 0 || year % 400 == 0;
  }

  /**
   * 是否是毫秒时间
   */
  static String getTimeByDayStr(int timeNum, {bool isMillisecondTime = true}) {
    assert(timeNum > 0, "时间必须大于0");
    if (timeNum <= 0) {
      return "00:00";
    }

    double sDouble = isMillisecondTime ? timeNum / 1000 : timeNum.toDouble();
    // mlogD("getSecondsVIew", "s=${s}");
    if (sDouble <= 0) {
      return "00:00";
    }

    if (sDouble < 60) {
      return "00:${sDouble.toInt().toString().padLeft(2, "0")}";
    }

//        86400
    double minuteDouble = sDouble / 60; //1440
    // mlogD("getSecondsVIew", "m=${minuteDouble}");

    if (minuteDouble < 60) {
      //一个小时内
      int mm = sDouble ~/ 60;
      num ss = (isMillisecondTime ? timeNum ~/ 1000 : timeNum) - mm * 60;
      return '${mm.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
    } else {
      //超过了一个小时

      double hDouble = minuteDouble / 60;
      if (hDouble < 24) {
        //在一天内
        num hh = minuteDouble ~/ 60;
        num minute = minuteDouble.toInt() - hh * 60;
        num ss = (isMillisecondTime ? timeNum ~/ 1000 : timeNum) -
            minute * 60 -
            hh * 60 * 60;
        return '${hh.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
      }
      //超过一天
      num dayNum = hDouble ~/ 24;
      num hh = minuteDouble ~/ 60 - dayNum * 24;
      num minute = minuteDouble.toInt() - dayNum * 24 * 60 - hh * 60;
      num ss = (isMillisecondTime ? timeNum ~/ 1000 : timeNum) -
          dayNum * 24 * 60 * 60 -
          minute * 60 -
          hh * 60 * 60;
      return '$dayNum天${hh.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
    }
  }
}

enum SjDateType {
  All,
  AllAndSSS,
  YearMonthDay,
  YearMonthDayHourMinute,
  YearMonth,
  MonthDay,
  HourMinuteSecond,
  HourMinute,
  Hour,
}

extension DateParse on DateTime {
  String formatSdkDate(List<String> formats,
      {DateLocale locale = const EnglishDateLocale()}) {
    return formatDate(this, formats, locale: locale);
  }

  String formatDate2CommonStr(
      {String? ymdSplit = "-",
      String? dayHourSplit = " ",
      String? monthDaySplit = "",
      String? hmSplit = ":",
      String? yearSplit,
      String? yueSplit,
      String? riSplit,
      SjDateType dateType = SjDateType.All}) {
    switch (dateType) {
      case SjDateType.YearMonthDay:
        return formatDate(this, [
          yyyy,
          yearSplit ?? ymdSplit ?? "",
          mm,
          yueSplit ?? ymdSplit ?? "",
          dd,
          riSplit ?? ""
        ]);
      case SjDateType.YearMonthDayHourMinute:
        return formatDate(this, [
          yyyy,
          yearSplit ?? ymdSplit ?? "",
          mm,
          yueSplit ?? ymdSplit ?? "",
          dd,
          riSplit ?? dayHourSplit ?? "",
          HH,
          hmSplit ?? "",
          nn,
        ]);
      case SjDateType.YearMonth:
        return formatDate(this, [
          yyyy,
          ymdSplit ?? "",
          mm,
        ]);
      case SjDateType.MonthDay:
        return formatDate(this, [mm, ymdSplit ?? "", dd, monthDaySplit ?? '']);
      case SjDateType.HourMinuteSecond:
        return formatDate(this, [HH, hmSplit ?? "", nn, hmSplit ?? "", ss]);
      case SjDateType.HourMinute:
        // return formatDate(this, [nn, hmSplit ?? "", ss]);
        return formatDate(this, [HH, hmSplit ?? "", nn]);
      case SjDateType.Hour:
        return formatDate(this, [HH, hmSplit ?? "", ss]);
      case SjDateType.YearMonthDayHourMinute:
        return formatDate(this, [
          yyyy,
          ymdSplit ?? "",
          mm,
          ymdSplit ?? "",
          dd,
          dayHourSplit ?? "",
          HH,
          hmSplit ?? "",
          nn,
        ]);
        return formatDate(this, [H, hmSplit ?? "", ss]);
      case SjDateType.AllAndSSS:
        return formatDate(this, [
          yyyy,
          ymdSplit ?? "",
          mm,
          ymdSplit ?? "",
          dd,
          dayHourSplit ?? "",
          HH,
          hmSplit ?? "",
          nn,
          hmSplit ?? "",
          ss,
          ".",
          SSS
        ]);
      default:
        return formatDate(this, [
          yyyy,
          ymdSplit ?? "",
          mm,
          ymdSplit ?? "",
          dd,
          dayHourSplit ?? "",
          HH,
          hmSplit ?? "",
          nn,
          hmSplit ?? "",
          ss
        ]);
    }
  }
}

extension IntDateParse on num {
  /**
   * 是否是毫秒时间
   */
  String getTimeByDayStr({bool isMillisecondTime = true}) {
    assert(this > 0, "时间必须大于0");
    if (this <= 0) {
      return "00:00";
    }

    double sDouble = isMillisecondTime ? this / 1000 : this.toDouble();
    // mlogD("getSecondsVIew", "s=${s}");
    if (sDouble <= 0) {
      return "00:00";
    }

    if (sDouble < 60) {
      return "00:${sDouble.toInt().toString().padLeft(2, "0")}";
    }

//        86400
    double minuteDouble = sDouble / 60; //1440
    // mlogD("getSecondsVIew", "m=${minuteDouble}");

    if (minuteDouble < 60) {
      //一个小时内
      int mm = sDouble ~/ 60;
      num ss = (isMillisecondTime ? this ~/ 1000 : this) - mm * 60;
      return '${mm.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
    } else {
      //超过了一个小时

      double hDouble = minuteDouble / 60;
      if (hDouble < 24) {
        //在一天内
        num hh = minuteDouble ~/ 60;
        num minute = minuteDouble.toInt() - hh * 60;
        num ss = (isMillisecondTime ? this ~/ 1000 : this) -
            minute * 60 -
            hh * 60 * 60;
        return '${hh.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
      }
      //超过一天
      num dayNum = hDouble ~/ 24;
      num hh = minuteDouble ~/ 60 - dayNum * 24;
      num minute = minuteDouble.toInt() - dayNum * 24 * 60 - hh * 60;
      num ss = (isMillisecondTime ? this ~/ 1000 : this) -
          dayNum * 24 * 60 * 60 -
          minute * 60 -
          hh * 60 * 60;
      return '$dayNum天${hh.toString().padLeft(2, "0")}:${minute.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
//       double h = m / 60; //24
//       String dayStr = "";
//       int dayNum = 0;
//       int hhLong = m ~/ 60;
//       if (h >= 24) {
//         //超过了24小时
//         dayNum = h ~/ 24;
//         dayStr = dayNum.toString();
//         hhLong = hhLong - dayNum * 24;
// //                119-24*4=23h
//       }
//       double mm = s ~/ 60 - dayNum * 24 * 60 - h * 60;
//       double ss = s - dayNum * 24 * 60 * 60 - h * 60 * 60 - mm * 60;
//       mlogD("getSecondsVIew",
//           "dayNum=${dayNum}  hhLong=${hhLong}  mm=${mm}  ss=${ss}  h=${h}  dayNum=${dayNum}  s=${s}  it=${this}");
//       if (dayStr.isEmpty) {
//         return '$hh:${mm.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
//       } else {
//         if (hhLong == 0 && mm == 0 && ss == 0) {
//           return "$dayStr天";
//         }
//         return '$dayStr天$hh:${mm.toString().padLeft(2, "0")}:${ss.toString().padLeft(2, "0")}';
//       }
    }
  }

  String formatDate2CommonStr(
      {bool isMillisecondTime = true,
      String? ymdSplit = "-",
      String? dayHourSplit = " ",
      String? hmSplit = ":",
      SjDateType dateType = SjDateType.All}) {
    assert(this > 0, "时间戳必须大于0");
    if (this <= 0) {
      return "";
    }

    var date = DateTime.fromMillisecondsSinceEpoch(
        isMillisecondTime ? this.toInt() : (this * 1000).toInt());
    return date.formatDate2CommonStr(
        ymdSplit: ymdSplit,
        dayHourSplit: dayHourSplit,
        hmSplit: hmSplit,
        dateType: dateType);
  }
}
