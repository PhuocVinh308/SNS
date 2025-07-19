import 'package:srs_authen/srs_authen.dart' as srs_authen;
import 'package:srs_common/srs_common_lib.dart';

import 'date_time_strings.dart';

class SettingService {
  final firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference userCollection = FirebaseFirestore.instance.collection('tb_user');

  Future<void> updateUser(srs_authen.UserInfoModel data, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể cập nhật sau 3 lần thử.');
    }
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      await userCollection.doc(data.email).update({
        'fullName': data.fullName,
        'phone': data.phone,
        'address': data.address,
        'updatedDate': result.standardFormat,
      });
    } catch (e) {
      await updateUser(
        data,
        retryCount: retryCount + 1,
      );
    }
  }

  Future<void> signOut({int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể đăng xuất sau 3 lần thử.');
    }
    try {
      await firebaseAuth.signOut();
    } catch (e) {
      await signOut(
        retryCount: retryCount + 1,
      );
    }
  }

  Future<srs_authen.UserInfoModel> getUser(String email, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể lấy dữ liệu sau 3 lần thử.');
    }
    try {
      final doc = await userCollection.doc(email).get();

      if (doc.exists) {
        return srs_authen.UserInfoModel.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        return await getUser(
          email,
          retryCount: retryCount + 1,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
