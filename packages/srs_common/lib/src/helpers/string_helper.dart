import 'package:srs_common/srs_common_lib.dart';

class StringHelper {
  static DateTime? parseDateString(dynamic dateTime) {
    if (dateTime == null) return null;
    if (GetUtils.isNumericOnly(dateTime)) {
      return DateTime(int.parse(dateTime), 1, 1);
    } else if (!GetUtils.isNumericOnly(dateTime) && RegExp(r'^\d{4}$').hasMatch(dateTime)) {
      return DateTime(int.parse(dateTime), 1, 1);
    } else if (!GetUtils.isNumericOnly(dateTime) && RegExp(r'^\d{1,2}-\d{4}$').hasMatch(dateTime)) {
      List<String> parts = dateTime.split('-');
      int month = int.parse(parts[0]);
      int year = int.parse(parts[1]);
      return DateTime(year, month, 1);
    } else if (!GetUtils.isNumericOnly(dateTime) && RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateTime)) {
      return DateTime.parse(dateTime);
    }
    return null;
  }
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
