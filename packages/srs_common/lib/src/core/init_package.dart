import 'dart:developer';

import 'package:srs_common/srs_common.dart';

import '../translations/app_translations.dart';
import 'init_network_check.dart';

initPackage() async {
  log('initialize Package', name: CommonConfig.packageName);
  await initAppTranslations();
  await checkNetworkConnection();
}
