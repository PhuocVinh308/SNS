import 'package:srs_common/srs_common_lib.dart';

class LandingService {
  void fetchFireStoreDataByCollectionSync({
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
}
