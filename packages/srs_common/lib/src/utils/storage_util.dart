import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common.dart';

class StorageUtil {
  final box = GetStorage();

  // language true: vn, false: us
  void setLanguage(bool value, {bool isRemovedOld = true}) {
    if (isRemovedOld) removeLanguage();
    box.write(CustomConsts.isLanguage, value);
  }

  bool get language => box.read(CustomConsts.isLanguage) ?? true;

  void removeLanguage() {
    box.remove(CustomConsts.isLanguage);
  }
}
