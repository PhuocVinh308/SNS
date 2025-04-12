import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_setting/srs_setting.dart';

import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: SettingConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const SettingPage(),
      binding: AllBindings(),
    ),
    GetPage(
      name: AllRoute.updateInfoRoute,
      page: () => const SettingUpdateInfoPage(),
      binding: AllBindings(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
