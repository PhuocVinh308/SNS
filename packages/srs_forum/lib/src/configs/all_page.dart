import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';
import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: ForumConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const ForumPage(),
      binding: AllBindings(),
    ),
    GetPage(
      name: AllRoute.contentRoute,
      page: () => const ForumContentPage(),
      binding: AllBindings(),
    ),
    GetPage(
      name: AllRoute.addRoute,
      page: () => const ForumAddPage(),
      binding: AllBindings(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
