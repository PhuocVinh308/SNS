import 'package:srs_authen/src/controllers/authen_init_controller.dart';
import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';

class AuthenService {
  final firebaseAuth = FirebaseAuth.instance;

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
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // begin interactive sign in process
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      // user cancels google sign in pop up screen
      if (gUser == null) throw Exception('${'đã xảy ra lỗi dự kiến. vui lòng thử lại sau'.tr.toCapitalized()}!');
      // obtain auth details from request
      final GoogleSignInAuthentication gAuth = await gUser!.authentication;
      // create a new user credential with Google's access token' for user
      final userCredential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );
      // sign in with the credential
      return await firebaseAuth.signInWithCredential(userCredential);
    } catch (e) {
      rethrow;
    }
  }
}
