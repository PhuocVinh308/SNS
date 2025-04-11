import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter_asxh/module/common/common.dart';
import 'package:flutter_asxh/module/notification_hgi/notification_hgi.dart';
import 'package:uuid/uuid.dart';

class NotificationHgiRepository {
  /// Api base helper
  ApiBaseHelper _apiBaseHelper = ApiBaseHelper();

  // firebase fire store
  final CollectionReference _collection = FirebaseFirestore.instance.collection('tb_thong_bao');
  final CollectionReference _collectionConfig = FirebaseFirestore.instance.collection('tb_config');

  Future<void> send(FcmHgiRequestModel fcmModel) async {
    try {
      int retryCount = 0;
      int retryCountLimit = 3;
      while (retryCount < retryCountLimit) {
        try {
          await _apiBaseHelper.postHttp(
            NotificationHgiAppConfig.apiFcm,
            options: dio.Options(
              headers: {
                'authorization': 'Bearer ' + NotificationHgiUtil.isHgiFcmToken,
              },
            ),
            data: fcmModel.toJson(),
          );
          retryCount = retryCountLimit;
        } catch (e) {
          await NotificationHgiManager().generalFcmToken();
          retryCount++;
          if (retryCount >= retryCountLimit) throw e;
        }
      }
    } catch (e) {
      throw (e);
    }
  }

  Future<void> save(FirestoreFcmHgiPostModel model) async {
    try {
      final ref = _collection.doc("${model.ngayTao}_create=${model.uuid}}");
      await ref.set(model.toJson());
      // await ref.update({'id': ref.id});
    } catch (e) {
      throw e;
    }
  }

  Future<bool> getIsEnableNotificationDevRole() async {
    try {
      var documentSnapshot = await _collectionConfig.doc('isEnableNotificationDevRole').get();
      var data = documentSnapshot.data() as Map<String, dynamic>;
      return data["isEnableNotificationDevRole"] ?? false;
    } catch (e) {
      throw e;
    }
  }
}
