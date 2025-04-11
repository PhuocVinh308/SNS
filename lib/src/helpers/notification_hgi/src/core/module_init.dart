import 'dart:developer' as dev;

import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';

import 'hive_init.dart';
import 'route_init.dart';

/// init data, translation, routes and more
initModule() async {
  dev.log('initialize module', name: NotificationHgiAppConfig.packageName);
  await initHive();
  await initAppRoute();
}
