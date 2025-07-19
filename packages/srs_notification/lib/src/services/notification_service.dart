import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_common/srs_common_lib_2.dart' as auth;
import 'package:srs_common/srs_common_lib_3.dart' as http;
import 'package:srs_landing/srs_landing.dart' as srs_landing;
import 'package:srs_notification/srs_notification.dart';

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedModel> didReceiveLocalNotificationStream = StreamController<ReceivedModel>.broadcast();
final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

class NotificationService {
  /// NotificationPlugin
  static final _notificationPlugin = FlutterLocalNotificationsPlugin();

  /// InitNotification
  Future<void> initNotification() async {
    await generalFcmToken();
    AndroidInitializationSettings androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    DarwinInitializationSettings darwinInitializationSettings = const DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
      notificationCategories: [],
    );
    // InitializationSettings
    InitializationSettings initializationSettings = InitializationSettings(android: androidInitializationSettings, iOS: darwinInitializationSettings);
    // NotificationAppLaunchDetails
    final NotificationAppLaunchDetails? notificationAppLaunchDetails = await _notificationPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    // DidNotificationLaunchApp
    if (didNotificationLaunchApp) {
      var payload = notificationAppLaunchDetails!.notificationResponse;
      onSelectNotification(payload!);
    } else {
      await _notificationPlugin.initialize(
        initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          selectNotificationStream.add(notificationResponse.payload);
        },
        onDidReceiveBackgroundNotificationResponse: onSelectNotification,
      );
    }
  }

  /// OnSelectNotification
  static onSelectNotification(NotificationResponse? notificationResponse) async {
    // NotificationHgiUtil.setHgiMessageLines([]);
  }

  /// RequestPermissions
  Future<void> requestPermissions() async {
    if (Platform.isIOS) {
      await _notificationPlugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          _notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
      final bool? granted = await androidImplementation?.requestNotificationsPermission();
      CustomGlobals().setNotificationEnable(granted ?? false);
    }
  }

  /// PermissionGranted
  Future<void> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted =
          await _notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ??
              false;
      CustomGlobals().setNotificationEnable(granted);
    } else if (Platform.isIOS) {
      var notificationAppLaunchDetails = await _notificationPlugin.getNotificationAppLaunchDetails();
      var granted = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
      CustomGlobals().setNotificationEnable(granted);
    }
  }

  /// Gen fcm token
  Future<void> generalFcmToken() async {
    try {
      // Client via service account
      http.Client client = await auth.clientViaServiceAccount(
        await _getServiceAccountCredentials(),
        [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/firebase.database",
          "https://www.googleapis.com/auth/firebase.messaging",
          "https://www.googleapis.com/auth/datastore",
        ],
      );
      // Obtain the access token
      auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        await _getServiceAccountCredentials(),
        [
          "https://www.googleapis.com/auth/userinfo.email",
          "https://www.googleapis.com/auth/firebase.database",
          "https://www.googleapis.com/auth/firebase.messaging",
          "https://www.googleapis.com/auth/datastore",
        ],
        client,
      );
      // Close the HTTP client
      client.close();
      // Save fcm token to hive
      CustomGlobals().setNotificationToken(credentials.accessToken.data);
      dev.log(CustomGlobals().notificationToken);
      // Return the access token
      // return credentials.accessToken.data;
    } catch (e) {
      rethrow;
    }
  }

  void _fetchFireStoreDataByCollectionSync({
    required String collectionPath,
    required Function(QuerySnapshot) onListen,
  }) {
    try {
      FirebaseFirestore.instance.collection(collectionPath).snapshots().listen(
        (QuerySnapshot snapshot) {
          onListen(snapshot)?.call;
        },
        onError: (error) {
          throw Exception('Error listening to FireStore: $error');
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  initSyncFcmEnv() async {
    try {
      _fetchFireStoreDataByCollectionSync(
        collectionPath: "tb_env",
        onListen: (snapshot) {
          var map = {
            for (var doc in snapshot.docs) doc.id: doc.data() as Map<String, dynamic>, // Gán doc.id làm key và dữ liệu làm value
          };
          var modelValue = FcmServiceModel.fromJson(map['fcm'] ?? FcmServiceModel().toJson());
          CustomGlobals().setFcmServiceModel(modelValue);
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<auth.ServiceAccountCredentials> _getServiceAccountCredentials() async {
    final model = CustomGlobals().fcmServiceModel;
    final data = model.toJson();
    String formattedKey = _decodeKey(data['key']);
    return auth.ServiceAccountCredentials.fromJson(formattedKey);
  }

  String _encodeKey(String key) {
    return base64Encode(utf8.encode(key));
  }

  String _decodeKey(String key) {
    return utf8.decode(base64Decode(key));
  }

  ///------------------------------------------------------------------------------------------------
  /// Android Notification Details
  AndroidNotificationDetails _androidDetails({required StyleInformation styleInformation, required bool isGroup}) {
    return AndroidNotificationDetails(
      'FCM_CHANNEL_ID',
      'FCM_CHANNEL_NAME',
      channelDescription: 'FIREBASE NOTIFICATION AGRI GO',
      groupKey: 'AGRI_GO',
      styleInformation: styleInformation,
      setAsGroupSummary: isGroup,
      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      priority: Priority.high,
      importance: Importance.max,
      channelShowBadge: true,
      icon: '@mipmap/launcher_icon',
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
    );
  }

  /// Darwin Notification Details
  DarwinNotificationDetails _iosDetails() {
    return const DarwinNotificationDetails(threadIdentifier: 'AGRI_GO');
  }

  /// PushNotification
  Future<void> pushNotification(RemoteMessage message) async {
    try {
      // NotificationController controller = Get.find<NotificationController>();
      final fcmModel = PushResponseModel(
        documentId: message.data['documentId'],
        title: message.notification?.title,
        content: message.notification?.body,
        createdName: message.data['createdName'],
        createdDate: message.data['createdDate'],
      );
      await _pushNotification(fcmModel);
    } catch (e) {
      dev.log(e.toString(), name: NotificationConfig.packageName);
    }
  }

  /// push thông báo
  Future<void> _pushNotification(PushResponseModel model) async {
    //Phân quyền và show thông báo
    _showNotification(model);
  }

  /// ShowNotification
  Future<void> _showNotification(PushResponseModel model) async {
    List<String> list = [];
    // configLocal;
    list.add('${model.createdName} - ${model.content}');
    // NotificationHgiUtil.setHgiMessageLines(_listMessageLines);
    final bigTextStyle = BigTextStyleInformation("${model.content}", contentTitle: model.title);

    final inboxStyle = InboxStyleInformation(
      // NotificationHgiUtil.getHgiMessageLines,
      list,
      contentTitle: '${list.length} Thông báo',
      summaryText: 'Multi Notification',
    );
    final platformChannelSpecifics = NotificationDetails(
      android: _androidDetails(styleInformation: bigTextStyle, isGroup: false),
      iOS: _iosDetails(),
    );
    final notiSpecificDetails = NotificationDetails(
      android: _androidDetails(styleInformation: inboxStyle, isGroup: true),
      iOS: _iosDetails(),
    );
    await _notificationPlugin.show(
      0,
      'Agri Go',
      '${list.length} Thông báo',
      notiSpecificDetails,
      payload: srs_landing.AllRoute.mainRoute,
    );

    await _notificationPlugin.show(
      Random().nextInt(100) + 1,
      model.title,
      model.content,
      platformChannelSpecifics,
      payload: srs_landing.AllRoute.mainRoute,
    );
  }
}
