import 'dart:developer';

import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib_4.dart' as time_ago;

import '../translations/app_translations.dart';
import 'init_network_check.dart';

initPackage() async {
  log('initialize Package', name: CommonConfig.packageName);
  await initAppTranslations();
  await checkNetworkConnection();
  await initTimeAgo();
}

initTimeAgo() async {
  log('initialize timeago', name: CommonConfig.packageName);
  time_ago.setLocaleMessages('en', time_ago.EnMessages());
  time_ago.setLocaleMessages('en_short', time_ago.EnShortMessages());
  time_ago.setLocaleMessages('vi', time_ago.ViMessages());
  time_ago.setLocaleMessages('vi_short', time_ago.ViShortMessages());
}
