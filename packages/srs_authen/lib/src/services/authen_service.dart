import 'package:srs_authen/srs_authen.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

import 'date_time_strings.dart';

class AuthenService {
  final firebaseAuth = FirebaseAuth.instance;

  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference userCollection = FirebaseFirestore.instance.collection('tb_user');

  Future<UserCredential?> registerWithEmailPassword({String? email, String? password}) async {
    try {
      if ((email == null || email.isEmpty) || (password == null || password.isEmpty)) {
        throw Exception('email hoặc mật khẩu không hợp lệ'.tr.toCapitalized());
      }
      UserCredential? userCredential = await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> loginWithEmailPassword({String? email, String? password}) async {
    try {
      if ((email == null || email.isEmpty) || (password == null || password.isEmpty)) {
        throw Exception('email hoặc mật khẩu không hợp lệ'.tr.toCapitalized());
      }
      UserCredential? userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      final user = await getUser(email);
      LoginResponseModel response = LoginResponseModel(
        data: UserResponseModel(
          user: user,
        ),
      );
      CustomGlobals().setUserInfo(response.data?.user);
      CustomGlobals().setToken(response.data?.token);
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
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

  Future<DateTimeStrings> postUser(UserInfoModel data, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể tạo document mới sau 3 lần thử.');
    }
    try {
      DateTimeStrings result = generateBothDateTimeStrings();

      String createdDate = result.standardFormat;
      DocumentReference forumRef = userCollection.doc(data.email);

      final docSnapshot = await forumRef.get();

      if (!docSnapshot.exists) {
        // Sử dụng data được truyền vào hoặc empty map nếu null
        data.username = data.email;
        data.createdDate = createdDate;

        final dataToSave = {
          ...data.toJson(), // Spread operator với null check
        };
        await forumRef.set(dataToSave);
        return result;
      } else {
        // Nếu document đã tồn tại, gọi lại hàm để tạo ID mới
        return await postUser(
          data,
          retryCount: retryCount + 1,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<UserInfoModel> getUser(String email, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể lấy dữ liệu sau 3 lần thử.');
    }
    try {
      final doc = await userCollection.doc(email).get();

      if (doc.exists) {
        return UserInfoModel.fromJson(doc.data() as Map<String, dynamic>);
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
