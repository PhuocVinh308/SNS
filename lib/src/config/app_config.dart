import 'package:flutter/material.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common_core.dart';

import 'package:srs_authen/srs_authen.dart' as srs_authen;

class AppConfig {
  /// default locale
  static Locale get locale => const Locale('vi');

  /// fallback locale
  static const fallbackLocale = Locale('en');

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
