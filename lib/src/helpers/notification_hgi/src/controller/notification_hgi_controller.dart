import 'dart:async';
import 'dart:developer' as dev;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_asxh/module/common/common.dart';
import 'package:flutter_asxh/module/dashboard_hgi/src/util/dashboard_hgi_util.dart';
import 'package:flutter_asxh/module/landing_hgi/landing_hgi.dart';
import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class NotificationHgiController extends GetxController with NotificationHgiManager, BaseController {
  NotificationHgiRepository _repository = NotificationHgiRepository();
  var documentSnapshotListData = <DocumentSnapshot>[].obs;
  StreamSubscription<QuerySnapshot>? thongBaoSubscription;
  StreamSubscription<RemoteMessage>? steamNotificationOnMessage;
  StreamSubscription<RemoteMessage>? steamNotificationOnMessageOpenedApp;

  /// core
  Rx<bool> isEnableNotificationDevRole = false.obs;
  Rx<bool> isLoadingPage = false.obs;
  Rx<bool> isLoadedFailed = false.obs;

  @override
  void onInit() {
    fetchThongBaoListData();
    getIsEnableNotificationDevRole();
    super.onInit();
  }

  @override
  void onReady() async {
    isPermissionGranted();
    requestPermissions();
    configureDidReceiveLocalNotificationSubject();
    configureSelectNotificationSubject();
    super.onReady();
  }

  @override
  void onClose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    thongBaoSubscription?.cancel();
    steamNotificationOnMessage?.cancel();
    steamNotificationOnMessageOpenedApp?.cancel();
    super.onClose();
  }

  Future<void> initFirebaseMessage() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;
      if (DashboardHgiUtil.getHgiUserInfo.isCongDan == 1) {
        var topic = NotificationHgiAppConfig.fcmHgiSubscribeTopics.last;
        messaging.subscribeToTopic(topic);
        dev.log('Subscribe To Topic: $topic', name: NotificationHgiAppConfig.packageName);

        /// Xử lý thông báo đẩy khi ứng dụng đang chạy
        if (steamNotificationOnMessage == null) {
          steamNotificationOnMessage = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        } else {
          steamNotificationOnMessage?.onData((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        }

        /// Xử lý thông báo đẩy khi ứng dụng được mở từ trạng thái nền
        if (steamNotificationOnMessageOpenedApp == null) {
          steamNotificationOnMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        } else {
          steamNotificationOnMessageOpenedApp?.onData((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        }
      } else {
        var topic = NotificationHgiAppConfig.fcmHgiSubscribeTopics.first;
        messaging.subscribeToTopic(topic);
        dev.log('Subscribe To Topic: $topic', name: NotificationHgiAppConfig.packageName);

        /// Xử lý thông báo đẩy khi ứng dụng đang chạy
        if (steamNotificationOnMessage == null) {
          steamNotificationOnMessage = FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        } else {
          steamNotificationOnMessage?.onData((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        }

        /// Xử lý thông báo đẩy khi ứng dụng được mở từ trạng thái nền
        if (steamNotificationOnMessageOpenedApp == null) {
          steamNotificationOnMessageOpenedApp = FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        } else {
          steamNotificationOnMessageOpenedApp?.onData((RemoteMessage message) {
            NotificationHgiManager().pushNotification(message);
          });
        }
      }
    } catch (e) {
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }

  Future<void> unSubscribeTopic() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    for (var i in NotificationHgiAppConfig.fcmHgiSubscribeTopicsOld) {
      messaging.unsubscribeFromTopic(i);
      dev.log("Unsubscribed topic: " + i);
    }
    for (var i in NotificationHgiAppConfig.fcmHgiSubscribeTopics) {
      messaging.unsubscribeFromTopic(i);
      dev.log("Unsubscribed topic: " + i);
    }
  }

  void configureSelectNotificationSubject() async {
    selectNotificationStream.stream.listen((String? payload) async {
      if (payload != null && payload != '') {
        if (payload == LandingHgiRouteConfig.landingHgiRoute) {
          final landingController = Get.find<LandingHgiController>();
          landingController.currentIndex.value = 0;
          documentSnapshotListData.clear();
          fetchThongBaoListData();
          Get.toNamed(LandingHgiRouteConfig.landingHgiRoute);
        } else {
          documentSnapshotListData.clear();
          fetchThongBaoListData();
          Get.toNamed(payload);
        }
      }
      NotificationHgiUtil.setHgiMessageLines([]);
    });
  }

  void configureDidReceiveLocalNotificationSubject() async {
    didReceiveLocalNotificationStream.stream.listen((ReceivedNotificationHgi receivedNotification) async {
      NotificationHgiUtil.setHgiMessageLines([]);
      await showDialog(
        context: Get.context!,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null ? Text(receivedNotification.title!) : null,
          content: receivedNotification.body != null ? Text(receivedNotification.body!) : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => NotificationHgiPage(),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  Future<void> onRefresh() async {
    documentSnapshotListData.clear();
    await fetchThongBaoListData();
    await getIsEnableNotificationDevRole();
  }

  Future<void> fetchThongBaoListData() async {
    try {
      isLoadingPage.value = true;
      final CollectionReference _collection = FirebaseFirestore.instance.collection('tb_thong_bao');
      if (DashboardHgiUtil.getHgiUserInfo.isCongDan == 1) {
        var querySort = _collection.where("uuidNguoiTao", isEqualTo: DashboardHgiUtil.getHgiUserInfo.uuidNguoiDan);
        thongBaoSubscription = querySort.snapshots().listen((querySnapshot) {
          documentSnapshotListData.assignAll(querySnapshot.docs.reversed);
          isLoadingPage.value = false;
          isLoadedFailed.value = false;
        }, onError: (error) {
          isLoadingPage.value = false;
          isLoadedFailed.value = true;
          documentSnapshotListData.clear();
          dev.log(error, name: NotificationHgiAppConfig.packageName);
        });
      } else {
        List<DocumentSnapshot<Object?>> documentListTemp = [];
        thongBaoSubscription = _collection.snapshots().listen((querySnapshot) {
          documentListTemp.assignAll(querySnapshot.docs.reversed);
          switch (DashboardHgiUtil.getHgiHtbQuyenXuLy['maChucDanh']) {
            case 100:
              documentSnapshotListData.value = documentListTemp.where((e) {
                return ((e['xaTao'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh) ||
                    (e['xaThuongTru'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh));
              }).toList();
              break;
            case 101:
              documentSnapshotListData.value = documentListTemp.where((e) {
                return ((e['xaTao'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh) ||
                    (e['xaThuongTru'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh));
              }).toList();
              break;
            case 102:
              documentSnapshotListData.value = documentListTemp.where((e) {
                return ((e['apTao'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh) ||
                    (e['apThuongTru'] == DashboardHgiUtil.getHgiUserInfo.maXaPhuongBhxh));
              }).toList();
              break;
          }
          isLoadingPage.value = false;
          isLoadedFailed.value = false;
        }, onError: (error) {
          isLoadingPage.value = false;
          isLoadedFailed.value = true;
          documentSnapshotListData.clear();
          dev.log(error, name: NotificationHgiAppConfig.packageName);
        });
      }
    } catch (e) {
      isLoadingPage.value = false;
      isLoadedFailed.value = true;
      documentSnapshotListData.clear();
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }

  Future<void> getIsEnableNotificationDevRole() async {
    try {
      final response = await _repository.getIsEnableNotificationDevRole();
      isEnableNotificationDevRole.value = response;
    } catch (e) {
      isEnableNotificationDevRole.value = false;
    }
  }

  /// Notification core

  Future<void> saveNotification({
    String? tieuDe,
    String? noiDung,
    String? maChucDanh,
    String? huyenTao,
    String? xaTao,
    String? apTao,
    String? huyenThuongTru,
    String? xaThuongTru,
    String? apThuongTru,
    String? listUuidNguoiDan,
  }) async {
    try {
      if (NotificationHgiUtil.isHgiNotificationEnabled && isEnableNotificationDevRole.value) {
        var requestModel = FirestoreFcmHgiPostModel(
          tieuDe: tieuDe,
          noiDung: noiDung,
          maChucDanh: maChucDanh,
          tinhTao: '93',
          huyenTao: huyenTao,
          xaTao: xaTao,
          apTao: apTao,
          huyenThuongTru: huyenThuongTru,
          xaThuongTru: xaThuongTru,
          apThuongTru: apThuongTru,
          listUuidNguoiDan: listUuidNguoiDan,
          ngayTao: DateTime.now().toString(),
          nguoiTao: DashboardHgiUtil.getHgiUserInfo.tenDangNhap,
          uuidNguoiTao: DashboardHgiUtil.getHgiUserInfo.uuidNguoiDung,
          uuid: Uuid().v4(),
        );
        await _repository.save(requestModel);
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> _sendNotification({
    String? tieuDe,
    String? noiDung,
    String? maChucDanh,
    String? huyenTao,
    String? xaTao,
    String? apTao,
    String? huyenThuongTru,
    String? xaThuongTru,
    String? apThuongTru,
    String? listUuidNguoiDan,
    bool sendToCongDan = false,
  }) async {
    try {
      if (NotificationHgiUtil.isHgiNotificationEnabled && isEnableNotificationDevRole.value) {
        var titleModel = FcmHgiRequestTitle(
          tieuDe: tieuDe,
          noiDung: noiDung,
        );
        var bodyModel = FcmHgiRequestBody(
          maChucDanh: maChucDanh,
          huyenTao: huyenTao,
          xaTao: xaTao,
          apTao: apTao,
          huyenThuongTru: huyenThuongTru,
          xaThuongTru: xaThuongTru,
          apThuongTru: apThuongTru,
          listUuidNguoiDan: listUuidNguoiDan,
          uuid: Uuid().v4(),
          ngayTao: DateTime.now().toString(),
          nguoiTao: DashboardHgiUtil.getHgiUserInfo.tenDangNhap,
          tinhTao: "93",
          tinhThuongTru: "93",
        );
        var contentModel = FcmHgiRequestContent(
          title: titleModel,
          body: bodyModel,
        );
        var requestModel = FcmHgiRequestModel();
        if (sendToCongDan) {
          contentModel.topic = NotificationHgiAppConfig.fcmHgiSubscribeTopics.last;
          requestModel.content = contentModel;
          await _repository.send(requestModel);
        } else {
          contentModel.topic = NotificationHgiAppConfig.fcmHgiSubscribeTopics.first;
          requestModel.content = contentModel;
          await _repository.send(requestModel);
        }
      }
    } catch (e) {
      throw (e);
    }
  }

  /// Notification extend

  Future<void> nguoiDanSendToSelf({
    String? tieuDe,
    String? noiDung,
    String? listUuidNguoiDan,
    String? huyenTao,
    String? xaTao,
    String? apTao,
    String? huyenThuongTru,
    String? xaThuongTru,
    String? apThuongTru,
  }) async {
    try {
      _sendNotification(
        tieuDe: tieuDe,
        noiDung: noiDung,
        listUuidNguoiDan: listUuidNguoiDan,
        huyenTao: huyenTao,
        xaTao: xaTao,
        apTao: apTao,
        huyenThuongTru: huyenThuongTru,
        xaThuongTru: xaThuongTru,
        apThuongTru: apThuongTru,
        sendToCongDan: true,
        maChucDanh: null,
      );
    } catch (e) {
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }

  Future<void> nguoiDanSendToManager({
    String? tieuDe,
    String? noiDung,
    String? listUuidNguoiDan,
    String? huyenTao,
    String? xaTao,
    String? apTao,
    String? huyenThuongTru,
    String? xaThuongTru,
    String? apThuongTru,
    String? maChucDanh,
  }) async {
    try {
      _sendNotification(
        tieuDe: tieuDe,
        noiDung: noiDung,
        listUuidNguoiDan: listUuidNguoiDan,
        huyenTao: huyenTao,
        xaTao: xaTao,
        apTao: apTao,
        huyenThuongTru: huyenThuongTru,
        xaThuongTru: xaThuongTru,
        apThuongTru: apThuongTru,
        sendToCongDan: false,
        maChucDanh: maChucDanh,
      );
    } catch (e) {
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }

  Future<void> canBoSendToNguoiDan({
    String? tieuDe,
    String? noiDung,
    String? listUuidNguoiDan,
    String? huyenTao,
    String? xaTao,
    String? apTao,
    String? huyenThuongTru,
    String? xaThuongTru,
    String? apThuongTru,
  }) async {
    try {
      _sendNotification(
        tieuDe: tieuDe,
        noiDung: noiDung,
        listUuidNguoiDan: listUuidNguoiDan,
        huyenTao: huyenTao,
        xaTao: xaTao,
        apTao: apTao,
        huyenThuongTru: huyenThuongTru,
        xaThuongTru: xaThuongTru,
        apThuongTru: apThuongTru,
        sendToCongDan: true,
        maChucDanh: null,
      );
    } catch (e) {
      dev.log(e.toString(), name: NotificationHgiAppConfig.packageName);
    }
  }
}
