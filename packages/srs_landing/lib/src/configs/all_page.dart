import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart';
import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: LandingConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const LandingPage(),
      binding: AllBindings(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
