import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

import 'date_time_strings.dart';

class TransactionService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference serviceCollection = FirebaseFirestore.instance.collection('tb_service');
  final int _limit = 10;
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  Future<DateTimeStrings> postItem(TransactionModel data, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể tạo document mới sau 3 lần thử.');
    }
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      String documentId = result.postItemFormat;
      String createdDate = result.standardFormat;
      DocumentReference serviceRef = serviceCollection.doc(documentId);

      final docSnapshot = await serviceRef.get();

      if (!docSnapshot.exists) {
        // Sử dụng data được truyền vào hoặc empty map nếu null
        data.documentId = documentId;
        data.createdDate = createdDate;
        final dataToSave = {
          // 'documentId': documentId,
          // 'createdDate': createdDate,
          ...data.toJson(), // Spread operator với null check
        };
        await serviceRef.set(dataToSave);
        return result;
      } else {
        // Nếu document đã tồn tại, gọi lại hàm để tạo ID mới
        return await postItem(
          data,
          retryCount: retryCount + 1,
        );
      }
    } catch (e) {
      rethrow;
    }
  }
}
