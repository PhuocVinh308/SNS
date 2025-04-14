import 'dart:convert';

import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:hive/hive.dart';

class NotificationHgiUtil {
  /// serviceAccount model
  static Future<void> setIsHgiServiceAccountModel(ServiceAccountHgiResponseModel model) async {
    var jsonValue = model.toJson();
    var jsonData = json.encode(jsonValue);
    await Hive.box(NotificationHgiAppConfig.storageBox).put("is_hgi_service_account_model", jsonData);
  }

  static ServiceAccountHgiResponseModel get isHgiServiceAccountModel {
    var retrievedJson = Hive.box(NotificationHgiAppConfig.storageBox).get("is_hgi_service_account_model") ??
        json.encode(ServiceAccountHgiResponseModel().toJson());
    var parsed = json.decode(retrievedJson);
    var jsonEncode = json.encode(parsed);
    var jsonDecode = json.decode(jsonEncode);
    return ServiceAccountHgiResponseModel.fromJson(jsonDecode);
  }

  static Future<void> removeIsHgiServiceAccountModel() async =>
      await Hive.box(NotificationHgiAppConfig.storageBox).delete("is_hgi_service_account_model");

  /// fcm token
  static Future<void> setIsHgiFcmToken(String value) async =>
      await Hive.box(NotificationHgiAppConfig.storageBox).put("is_hgi_fcm_token", value);

  static dynamic get isHgiFcmToken => Hive.box(NotificationHgiAppConfig.storageBox).get("is_hgi_fcm_token");

  static Future<void> removeIsHgiFcmToken() async =>
      await Hive.box(NotificationHgiAppConfig.storageBox).delete("is_hgi_fcm_token");

  ///  notification
  static List<String>? _hgiMessageLines;

  static setHgiMessageLines(List<String>? messageLines) => _hgiMessageLines = messageLines;

  static List<String> get getHgiMessageLines => _hgiMessageLines ?? [];

  /// notification enabled
  static Future<void> setIsHgiNotificationEnabled(bool value) async =>
      await Hive.box(NotificationHgiAppConfig.storageBox).put("is_hgi_notification_enabled", value);

  static bool get isHgiNotificationEnabled =>
      Hive.box(NotificationHgiAppConfig.storageBox).get("is_hgi_notification_enabled") ?? false;

  static Future<void> removeIsHgiNotificationEnabled() async =>
      await Hive.box(NotificationHgiAppConfig.storageBox).delete("is_hgi_notification_enabled");
}
