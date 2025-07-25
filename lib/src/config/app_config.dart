import 'package:flutter/material.dart';
import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';

class AppConfig {
  /// default locale
  static Locale get locale => Locale(StorageUtil().language ? 'vi' : 'en', StorageUtil().language ? 'VN' : 'US');

  /// fallback locale
  static const fallbackLocale = Locale('vi', 'VN');

  /// package name
  static const String appName = "agri_go";

  /// storage box
  static const String storageBox = appName;

  /// default transition
  static const Transition defaultTransition = Transition.fade;

  /// remote route
  static String? get remoteInitialRoute => srs_authen.AllRoute.mainRoute;

  // static String? get remoteInitialRoute => '/';

  /// app pages
  static List<GetPage<dynamic>>? get getPages {
    return GetPageCenter.pages;
  }
}
