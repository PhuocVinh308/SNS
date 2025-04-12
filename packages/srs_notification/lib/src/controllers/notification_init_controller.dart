import 'package:srs_common/srs_common.dart';

class NotificationInitController {
  init() async {
    try {} catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }
}
