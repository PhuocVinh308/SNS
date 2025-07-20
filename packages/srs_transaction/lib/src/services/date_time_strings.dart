import 'dart:math' as math;

import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class DateTimeStrings {
  final String postItemFormat; // POST_FORUM_yyyymmdd_hhmmss_sss_xxx
  final String postItemNegotiateFormat; // POST_NEGOTIATE_yyyymmdd_hhmmss_sss_xxx
  final String standardFormat; // yyyy-mm-dd hh:mm:ss

  DateTimeStrings(this.postItemFormat, this.postItemNegotiateFormat, this.standardFormat);
}

DateTimeStrings generateBothDateTimeStrings() {
  final now = DateTime.now();
  final random = math.Random();

  // Các thành phần cơ bản
  final yyyy = now.year.toString();
  final mm = _twoDigits(now.month);
  final dd = _twoDigits(now.day);
  final hh = _twoDigits(now.hour);
  final mi = _twoDigits(now.minute);
  final ss = _twoDigits(now.second);
  final sss = now.millisecond.toString().padLeft(3, '0');
  final randomSuffix = random.nextInt(1000).toString().padLeft(3, '0');

  // Tạo 2 chuỗi theo 2 định dạng
  final postItem = 'POST_ITEM_$yyyy$mm${dd}_$hh$mi${ss}_${sss}_$randomSuffix';
  final postItemNegotiate = 'POST_NEGOTIATE_$yyyy$mm${dd}_$hh$mi${ss}_${sss}_$randomSuffix';
  final standard = '$yyyy-$mm-$dd $hh:$mi:$ss:$sss';

  return DateTimeStrings(postItem, postItemNegotiate, standard);
}

// Hàm helper thêm số 0 nếu cần
String _twoDigits(int n) => n >= 10 ? '$n' : '0$n';

DateTime parseStandardDateTime(String dateString) {
  try {
    // Tách các thành phần ngày tháng
    final parts = dateString.split(' ');
    if (parts.length != 2) throw FormatException('định dạng ngày không hợp lệ'.tr.toCapitalized());

    final dateParts = parts[0].split('-');
    final timeParts = parts[1].split(':');

    if (dateParts.length != 3 || timeParts.length != 3) {
      throw FormatException('định dạng ngày tháng hoặc thời gian không hợp lệ'.tr.toCapitalized());
    }

    // Chuyển đổi thành số
    final year = int.parse(dateParts[0]);
    final month = int.parse(dateParts[1]);
    final day = int.parse(dateParts[2]);
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final second = int.parse(timeParts[2]);

    // Tạo và trả về đối tượng DateTime
    return DateTime(year, month, day, hour, minute, second);
  } catch (e) {
    throw FormatException('${'không phân tích được ngày'.tr.toCapitalized()}: $dateString', e.toString());
  }
}
