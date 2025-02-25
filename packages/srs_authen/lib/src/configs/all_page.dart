import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_lib.dart';

import '../bindings/all_binding.dart';
import 'all_route.dart';

allPage() async {
  log('initialize All Page Route', name: AuthenConfig.packageName);
  GetPageCenter.add(
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const LoginPage(),
      binding: AllBindings(),
    ),
  );
}
