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

  // fcm
  static FcmServiceModel _fcmServiceModel = FcmServiceModel();

  FcmServiceModel get fcmServiceModel => _fcmServiceModel;

  void setFcmServiceModel(FcmServiceModel model) => _fcmServiceModel = model;

  // notification
  static bool _notificationEnable = false;

  bool get notificationEnable => _notificationEnable;

  void setNotificationEnable(bool value) => _notificationEnable = value;

  static String _notificationToken = '';

  String get notificationToken => _notificationToken;

  void setNotificationToken(String value) => _notificationToken = value;
}
