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

  /// check if the string contains only numbers
  static bool isNumeric(String str) {
    RegExp numeric = RegExp(r'^-?[0-9]+$');
    return numeric.hasMatch(str);
  }

  static final usernameRegExp = RegExp(r'^[a-zA-Z0-9_]+$');
  static final passwordRegExp = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&#])[A-Za-z\d@$!%*?&#]{8,}$');

  static final citizenIdNumberRegExp = RegExp(r'^[0-9]{9}$|^[0-9]{12}$');
  static final identifierRegExp = RegExp(r'^[0-9]{12}$');
  static final phoneRegExp =
      RegExp(r'^(0|84)(\s|\.)?((2[0-9][0-9])|(3[2-9])|(5[689])|(7[06-9])|(8[01-689])|(9[0-46-9]))(\d)(\s|\.)?(\d{3})(\s|\.)?(\d{3})$');
  static final emailRegExp = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  static final intNumber = RegExp(r'^[0-9]*$');
  static final doubleNumber = RegExp(r'^[0-9]*(\.[0-9]+)*$');

  static final specialText = RegExp(r'[!@#\$%^&*()?":{}|<>|\-\[\]\\]');
  static final specialTextAndNumber = RegExp(r'[!@#\$%^&*()?":{}|<>|\-\[\]\\0-9]');
  static final specialTextAndVietnamese = RegExp(
      r'[!@#\$%^&*()?":{}|<>|\-\[\]\\ÀÁÂÃÈÉÊÌÍÒÓÔÕÙÚĂĐĨŨƠàáâãèéêìíòóôõùúăđĩũơƯĂẠẢẤẦẨẪẬẮẰẲẴẶẸẺẼỀỀỂẾưăạảấầẩẫậắằẳẵặẹẻẽềềểếỄỆỈỊỌỎỐỒỔỖỘỚỜỞỠỢỤỦỨỪễệỉịọỏốồổỗộớờởỡợụủứừỬỮỰỲỴÝỶỸửữựỳỵýỷỹ]');
}

extension StringCasingExtension on String {
  String toCapitalized() => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String toTitleCase() => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.toCapitalized()).join(' ');
}
