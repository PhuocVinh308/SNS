import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';

class NotificationHgiAppConfig {
  /// your package name
  static const String packageName = "asxh_notification_hgi";

  /// storage box name
  static const String storageBox = packageName;

  //----------------------------------------------------------------
  /// FCM V2
  /// load token model from json file
  Future<ServiceAccountHgiResponseModel> genServiceAccountFromJson() async {
    var response = await rootBundle.loadString('assets/jsons/vnpt-asxh-hau-giang-cee365475b72.json');
    var jsonValue = jsonDecode(response);
    return ServiceAccountHgiResponseModel.fromJson(jsonValue);
  }

  static const List<String> hgiFcmScopes = [
    "https://www.googleapis.com/auth/userinfo.email",
    "https://www.googleapis.com/auth/firebase.database",
    "https://www.googleapis.com/auth/firebase.messaging",
    "https://www.googleapis.com/auth/datastore",
  ];

  static const List<String> fcmHgiSubscribeTopics = ['HGI_CAN_BO', 'HGI_NGUOI_DAN'];
  static const List<String> fcmHgiSubscribeTopicsOld = ['CAN_BO_AP', 'CAN_BO_XA', 'CHU_TICH_XA', 'NGUOI_DAN'];

  static const String apiFcm = "https://fcm.googleapis.com/v1/projects/vnpt-asxh-hau-giang/messages:send";
  static const String apiCloudFirestore =
      "https://firestore.googleapis.com/v1/projects/vnpt-asxh-hau-giang/databases/(default)/documents/tb_thong_bao";
}
