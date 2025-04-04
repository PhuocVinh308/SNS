import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common.dart';

class CustomGlobals {
  static srs_authen.UserInfoModel _userInfo = srs_authen.UserInfoModel();
  srs_authen.UserInfoModel get userInfo => _userInfo;
  void setUserInfo(srs_authen.UserInfoModel? value) => _userInfo = value ?? srs_authen.UserInfoModel();

  // token
  static String? _token;
  String get token => _token ?? "";
  void setToken(String? token) => _token = token;

  // env
  static DriveServiceModel _driveServiceModel = DriveServiceModel();
  DriveServiceModel get driveServiceModel => _driveServiceModel;
  void setDriveServiceModel(DriveServiceModel model) => _driveServiceModel = model;
}
