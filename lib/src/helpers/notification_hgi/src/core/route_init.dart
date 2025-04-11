import 'dart:developer' as dev;

import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:flutter_asxh/module/notification_hgi/src/binding/notification_hgi_binding.dart';
import 'package:flutter_asxh/src/core/app_page_center.dart';
import 'package:get/get.dart';

/// init application routes
initAppRoute() async {
  dev.log('initialize route', name: NotificationHgiAppConfig.packageName);

  GetPageCenter.add(GetPage(
      name: NotificationHgiRouteConfig.notificationHgiRoute,
      page: () => NotificationHgiPage(),
      binding: NotificationHgiBinding()));
}
