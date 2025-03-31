import 'package:srs_authen/srs_authen.dart' as srs_authen;

class CustomGlobals {
  static srs_authen.UserInfoModel _userInfo = srs_authen.UserInfoModel();
  srs_authen.UserInfoModel get userInfo => _userInfo;
  void setUserInfo(srs_authen.UserInfoModel? value) => _userInfo = value ?? srs_authen.UserInfoModel();
}
