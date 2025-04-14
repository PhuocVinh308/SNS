import 'dart:developer' as dev;

import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

initHive() async {
  var tmpDir = await getTemporaryDirectory();
  dev.log('initialize Hive in directory ${tmpDir.path}', name: NotificationHgiAppConfig.packageName);
  await Hive.openBox(NotificationHgiAppConfig.storageBox, path: tmpDir.path);
}
