import 'dart:developer';

import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';

import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: AuthenConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const LoginPage(),
      binding: AllBindings(),
    ),
    GetPage(
      name: AllRoute.registerRoute,
      page: () => const RegisterPage(),
      binding: AllBindings(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
