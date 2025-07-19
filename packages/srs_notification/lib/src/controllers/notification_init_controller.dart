import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_notification/srs_notification.dart';

class NotificationInitController {
  NotificationService service = NotificationService();
  StreamSubscription<QuerySnapshot>? thongBaoSubscription;
  StreamSubscription<RemoteMessage>? steamNotificationOnMessage;
  StreamSubscription<RemoteMessage>? steamNotificationOnMessageOpenedApp;
  final String topic = 'topic1';

  init() async {
    try {
      await service.isPermissionGranted();
      await service.requestPermissions();
      await configureDidReceiveLocalNotificationSubject();
      await configureSelectNotificationSubject();
    } catch (e) {
      DialogUtil.catchException(obj: e);
    }
  }

  configureDidReceiveLocalNotificationSubject() async {
    didReceiveLocalNotificationStream.stream.listen((ReceivedModel received) async {
      // NotificationHgiUtil.setHgiMessageLines([]);
      await showDialog(
        context: Get.context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: received.title != null ? Text(received.title!) : null,
          content: received.body != null ? Text(received.body!) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).pushNamed(srs_landing.AllRoute.mainRoute);
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  configureSelectNotificationSubject() async {
    selectNotificationStream.stream.listen((String? payload) async {
      if (payload != null && payload != '') {
        if (payload == srs_landing.AllRoute.mainRoute) {
          Get.offAndToNamed(srs_landing.AllRoute.mainRoute);
        } else {
          Get.toNamed(payload);
        }
      }
      // NotificationHgiUtil.setHgiMessageLines([]);
    });
  }

  initFirebaseMessage() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      messaging.subscribeToTopic(topic);
      log('Subscribe To Topic: $topic', name: NotificationConfig.packageName);

      /// Xử lý thông báo đẩy khi ứng dụng đang chạy
      if (steamNotificationOnMessage == null) {
        steamNotificationOnMessage = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
          service.pushNotification(message);
        });
      } else {
        steamNotificationOnMessage?.onData((RemoteMessage message) {
          service.pushNotification(message);
        });
      }

      /// Xử lý thông báo đẩy khi ứng dụng được mở từ trạng thái nền
      if (steamNotificationOnMessageOpenedApp == null) {
        steamNotificationOnMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
          service.pushNotification(message);
        });
      } else {
        steamNotificationOnMessageOpenedApp?.onData((RemoteMessage message) {
          service.pushNotification(message);
        });
      }
    } catch (e) {
      log(e.toString(), name: NotificationConfig.packageName);
    }
  }

  unSubscribeTopic() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    messaging.unsubscribeFromTopic(topic);
    log("Unsubscribed topic: $topic");
  }
}
