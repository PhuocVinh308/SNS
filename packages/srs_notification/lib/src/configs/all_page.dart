import 'dart:developer';

import 'package:srs_common/srs_common_core.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_notification/srs_notification.dart';

import '../bindings/all_binding.dart';

allPage() async {
  log('initialize All Page Route', name: NotificationConfig.packageName);

  List<GetPage<dynamic>> listPages = [
    GetPage(
      name: AllRoute.mainRoute,
      page: () => const NotificationPage(),
      binding: AllBindings(),
    ),
  ];
  GetPageCenter.addAll(listPages);
}
