import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_asxh/module/dashboard_hgi/src/util/dashboard_hgi_util.dart';
import 'package:flutter_asxh/module/landing_hgi/landing_hgi.dart';
import 'package:flutter_asxh/module/login_hgi/login_hgi.dart';
import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:googleapis_auth/auth_io.dart' as auth;
import 'package:http/http.dart' as http;

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotificationHgi> didReceiveLocalNotificationStream = StreamController<ReceivedNotificationHgi>.broadcast();
final StreamController<String?> selectNotificationStream = StreamController<String?>.broadcast();

class NotificationHgiManager {
  /// NotificationPlugin
  static final _notificationPlugin = new FlutterLocalNotificationsPlugin();

  /// InitNotification
  Future<void> initNotification() async {
    await generalFcmToken();
    AndroidInitializationSettings _androidInitializationSettings = const AndroidInitializationSettings('@mipmap/launcher_icon');
    DarwinInitializationSettings _darwinInitializationSettings = DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {
        didReceiveLocalNotificationStream.add(ReceivedNotificationHgi(id: id, title: title, body: body, payload: payload));
      },
      notificationCategories: [],
    );
    // InitializationSettings
    InitializationSettings _initializationSettings =
        InitializationSettings(android: _androidInitializationSettings, iOS: _darwinInitializationSettings);
    // NotificationAppLaunchDetails
    final NotificationAppLaunchDetails? _notificationAppLaunchDetails = await _notificationPlugin.getNotificationAppLaunchDetails();
    final didNotificationLaunchApp = _notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
    // DidNotificationLaunchApp
    if (didNotificationLaunchApp) {
      var payload = _notificationAppLaunchDetails!.notificationResponse;
      onSelectNotification(payload!);
    } else {
      await _notificationPlugin.initialize(
        _initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) {
          selectNotificationStream.add(notificationResponse.payload);
        },
        onDidReceiveBackgroundNotificationResponse: onSelectNotification,
      );
    }
  }

  /// OnSelectNotification
  static onSelectNotification(NotificationResponse? notificationResponse) async {
    NotificationHgiUtil.setHgiMessageLines([]);
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
      final bool? granted = await androidImplementation?.requestPermission();
      NotificationHgiUtil.setIsHgiNotificationEnabled(granted ?? false);
    }
  }

  /// PermissionGranted
  Future<void> isPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted =
          await _notificationPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.areNotificationsEnabled() ??
              false;
      NotificationHgiUtil.setIsHgiNotificationEnabled(granted);
    } else if (Platform.isIOS) {
      var notificationAppLaunchDetails = await _notificationPlugin.getNotificationAppLaunchDetails();
      var granted = notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
      NotificationHgiUtil.setIsHgiNotificationEnabled(granted);
    }
  }

  /// Gen fcm token
  Future<void> generalFcmToken() async {
    try {
      // Service account model
      final serviceAccountModel = await NotificationHgiAppConfig().genServiceAccountFromJson();
      // Client via service account
      http.Client client = await auth.clientViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountModel.toJson()),
        NotificationHgiAppConfig.hgiFcmScopes,
      );
      // Obtain the access token
      auth.AccessCredentials credentials = await auth.obtainAccessCredentialsViaServiceAccount(
        auth.ServiceAccountCredentials.fromJson(serviceAccountModel.toJson()),
        NotificationHgiAppConfig.hgiFcmScopes,
        client,
      );
      // Close the HTTP client
      client.close();
      // Save fcm token to hive
      NotificationHgiUtil.removeIsHgiFcmToken();
      NotificationHgiUtil.setIsHgiFcmToken(credentials.accessToken.data);
      dev.log(NotificationHgiUtil.isHgiFcmToken);
      // Return the access token
      // return credentials.accessToken.data;
    } catch (e) {
      throw e;
    }
  }

  ///------------------------------------------------------------------------------------------------
  /// Android Notification Details
  AndroidNotificationDetails _androidDetails({
    required StyleInformation styleInformation,
    required bool isGroup,
  }) =>
      AndroidNotificationDetails(
        'FCM_CHANNEL_ID_HGI',
        'FCM_CHANNEL_NAME_HGI',
        channelDescription: 'FIREBASE NOTIFICATION HGI',
        groupKey: 'VNPT_AXSH_HCMSTB_HGI',
        styleInformation: styleInformation,
        setAsGroupSummary: isGroup,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('notification'),
        priority: Priority.high,
        importance: Importance.max,
        channelShowBadge: true,
        icon: '@mipmap/launcher_icon',
        largeIcon: DrawableResourceAndroidBitmap('@mipmap/launcher_icon'),
      );

  /// Darwin Notification Details
  DarwinNotificationDetails _iosDetails() => DarwinNotificationDetails(
        threadIdentifier: 'VNPT_AXSH_HCMSTB_HGI',
      );

  /// Function config

  /// PushNotification
  Future<void> pushNotification(RemoteMessage message) async {
    try {
      NotificationHgiController _nfController = Get.find<NotificationHgiController>();
      if (NotificationHgiUtil.isHgiNotificationEnabled && _nfController.isEnableNotificationDevRole.value) {
        if (LoginHgiUtil.hgiIsToken != null) {
          final fcmModel = FcmHgiResponseModel(
            uuid: message.data['uuid'],
            maChucDanh: message.data['maChucDanh'],
            ngayTao: message.data['ngayTao'],
            nguoiTao: message.data['nguoiTao'],
            tinhTao: message.data['tinhTao'],
            huyenTao: message.data['huyenTao'],
            xaTao: message.data['xaTao'],
            apTao: message.data['apTao'],
            tinhThuongTru: message.data['tinhThuongTru'],
            huyenThuongTru: message.data['huyenThuongTru'],
            xaThuongTru: message.data['xaThuongTru'],
            apThuongTru: message.data['apThuongTru'],
            tieuDe: message.notification?.title,
            noiDung: message.notification?.body,
            listUuidNguoiDan: message.data['listUuidNguoiDan'],
          );
          await _phanQuyenVaShowThongBao(fcmModel);
        } else {
          dev.log('Chưa đăng nhập', name: NotificationHgiAppConfig.packageName);
        }
      } else {
        dev.log('Thông báo vô hiệu hoá', name: NotificationHgiAppConfig.packageName);
      }
    } catch (e) {
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }

  /// ShowNotification
  Future<void> _showNotification(FcmHgiResponseModel model) async {
    // configLocal;
    var _listMessageLines = NotificationHgiUtil.getHgiMessageLines.toList();
    _listMessageLines.add('${model.nguoiTao} - ${model.noiDung}');
    NotificationHgiUtil.setHgiMessageLines(_listMessageLines);
    // config
    final _bigTextStyle = BigTextStyleInformation("${model.noiDung}", contentTitle: model.tieuDe);
    final _inboxStyle = InboxStyleInformation(
      NotificationHgiUtil.getHgiMessageLines,
      contentTitle: '${NotificationHgiUtil.getHgiMessageLines.length} Thông báo',
      summaryText: 'Multi Notification',
    );
    final _platformChannelSpecifics = NotificationDetails(
      android: _androidDetails(styleInformation: _bigTextStyle, isGroup: false),
      iOS: _iosDetails(),
    );
    final _notiSpecificDetails = NotificationDetails(
      android: _androidDetails(styleInformation: _inboxStyle, isGroup: true),
      iOS: _iosDetails(),
    );
    await _notificationPlugin.show(
      0,
      'VNPT An Sinh Xã Hội',
      '${NotificationHgiUtil.getHgiMessageLines.length} Thông báo',
      _notiSpecificDetails,
      payload: LandingHgiRouteConfig.landingHgiRoute,
    );

    await _notificationPlugin.show(
      Random().nextInt(100) + 1,
      model.tieuDe,
      model.noiDung,
      _platformChannelSpecifics,
      payload: LandingHgiRouteConfig.landingHgiRoute,
    );
  }

  /// Phân quyền và show thông báo
  Future<void> _phanQuyenVaShowThongBao(FcmHgiResponseModel model) async {
    NotificationHgiController _nfController = Get.find<NotificationHgiController>();
    if (NotificationHgiUtil.isHgiNotificationEnabled && _nfController.isEnableNotificationDevRole.value) {
      if (DashboardHgiUtil.getHgiUserInfo.isCongDan == 1) {
        var _uuids = model.listUuidNguoiDan;
        var _listUuid = [];
        if (_uuids != null && _uuids.trim().isNotEmpty) {
          _listUuid = _uuids.split(',').map((e) => e.trim()).toList();
          for (var u in _listUuid) {
            if (DashboardHgiUtil.getHgiUserInfo.uuidNguoiDan == u) {
              _showNotification(model);
              break;
            }
          }
        }
      } else {
        if (model.maChucDanh != null && _roleCheck(model.maChucDanh)) {
          switch (DashboardHgiUtil.getHgiHtbQuyenXuLy['maChucDanh']) {
            case 100:
              if ((model.xaTao != null && model.xaTao != "") || (model.xaThuongTru != null && model.xaThuongTru != "")) {
                if ((model.xaTao == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh) ||
                    (model.xaThuongTru == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh)) {
                  await _showNotification(model);
                }
              }
              break;
            case 101:
              if ((model.xaTao != null && model.xaTao != "") || (model.xaThuongTru != null && model.xaThuongTru != "")) {
                if ((model.xaTao == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh) ||
                    (model.xaThuongTru == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh)) {
                  await _showNotification(model);
                }
              }
              break;
            case 102:
              if ((model.apTao != null && model.apTao != "") || (model.apThuongTru != null && model.apThuongTru != "")) {
                if ((model.apTao == DashboardHgiUtil.getHgiUserInfo.maThonXomBHXH) ||
                    (model.apThuongTru == DashboardHgiUtil.getHgiUserInfo.maThonXomBHXH)) {
                  await _showNotification(model);
                }
              }
              break;
            default:
              break;
          }
        }
      }
    }
  }

  bool _roleCheck(key) {
    if (DashboardHgiUtil.getHgiHtbQuyenXuLy.containsKey('maChucDanh') && DashboardHgiUtil.getHgiHtbQuyenXuLy['maChucDanh'].toString() == key) {
      return true;
    } else {
      return false;
    }
  }
}
