import 'dart:async';

import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_transaction/srs_transaction.dart';

import 'date_time_strings.dart';

class TransactionService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference serviceCollection = FirebaseFirestore.instance.collection('tb_service');
  List<String> trangThaiPosts = ["DANG_BAN", "DA_THUONG_LUONG", "DA_HOAN_THANH"];

  //
  final int _limit = 10;
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;

  bool get hasMore => _hasMore;

  //search
  DocumentSnapshot? _lastDocSearch;
  bool _hasMoreSearch = true;

  bool get hasMoreSearch => _hasMoreSearch;

  //

  StreamSubscription? _negotiateListener;

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

  Future<DateTimeStrings> postItemNegotiate({required NegotiateModel dataChild, int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể tạo document mới sau 3 lần thử.');
    }
    // Lấy reference đến document cha
    DocumentReference documentFather = serviceCollection.doc(dataChild.documentIdParent);
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      String documentIdChild = result.postItemNegotiateFormat;
      String createdDateChild = result.standardFormat;
      CollectionReference childCollection = documentFather.collection('ct_negotiates');
      DocumentReference childRef = childCollection.doc(documentIdChild);

      final docSnapshotChild = await childRef.get();
      if (!docSnapshotChild.exists) {
        // Sử dụng data được truyền vào hoặc empty map nếu null
        dataChild.documentId = documentIdChild;
        dataChild.createdDate = createdDateChild;
        final dataToSave = {
          // 'documentId': documentIdChild,
          // 'createdDate': createdDateChild,
          ...dataChild.toJson(), // Spread operator với null check
        };
        await childRef.set(dataToSave);
        return result;
      } else {
        // Nếu document đã tồn tại, gọi lại hàm để tạo ID mới
        return await postItemNegotiate(
          dataChild: dataChild,
          retryCount: retryCount + 1,
        );
      }
    } catch (e) {
      rethrow;
    }
  }

  void resetPagination() {
    _lastDoc = null;
    _hasMore = true;
  }

  void resetSearchPagination() {
    _lastDocSearch = null;
    _hasMoreSearch = true;
  }

  Future<List<TransactionModel>> fetchItemPosts() async {
    if (!_hasMore) return [];

    Query query = serviceCollection.orderBy("createdDate", descending: true);

    if (_lastDoc != null) {
      query = query.startAfterDocument(_lastDoc!);
    }

    query = query.limit(_limit);

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      _hasMore = false;
      return [];
    }

    _lastDoc = snapshot.docs.last;
    _hasMore = snapshot.docs.length == _limit;

    return Future.wait(snapshot.docs.map(_mapDocToPost));
  }

  Future<List<TransactionModel>> fetchItemSearchPosts({String? keyword}) async {
    if (!_hasMoreSearch) return [];

    Query query = serviceCollection.orderBy("createdDate", descending: true);

    if (keyword?.isNotEmpty == true) {
      final keywordLower = keyword?.toLowerCase();
      query = query.where("title", isGreaterThanOrEqualTo: keywordLower).where('title', isLessThanOrEqualTo: '$keywordLower\uf8ff');
    }

    if (_lastDocSearch != null) {
      query = query.startAfterDocument(_lastDocSearch!);
    }

    query = query.limit(_limit);

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      _hasMoreSearch = false;
      return [];
    }

    _lastDocSearch = snapshot.docs.last;
    _hasMoreSearch = snapshot.docs.length == _limit;

    return Future.wait(snapshot.docs.map(_mapDocToPost));
  }

  Future<TransactionModel> _mapDocToPost(DocumentSnapshot doc) async {
    final post = TransactionModel.fromJson(doc.data() as Map<String, dynamic>);

    // final subCounts = await Future.wait([
    //   doc.reference.collection('ct_cmt').count().get(),
    //   doc.reference.collection('ct_like').count().get(),
    //   doc.reference.collection('ct_seen').count().get(),
    // ]);
    //
    // post.countCmt = subCounts[0].count ?? 0;
    // post.countLike = subCounts[1].count ?? 0;
    // post.countSeen = subCounts[2].count ?? 0;

    return post;
  }

  Future<List<NegotiateModel>> fetchItemNegotiate(String? documentIdParent) async {
    Query query = serviceCollection.doc(documentIdParent).collection('ct_negotiates').orderBy("createdDate", descending: true);

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      return [];
    }

    _lastDoc = snapshot.docs.last;

    return Future.wait(snapshot.docs.map(_mapDocToPostNegotiate));
  }

  Future<NegotiateModel> _mapDocToPostNegotiate(DocumentSnapshot doc) async {
    final post = NegotiateModel.fromJson(doc.data() as Map<String, dynamic>);
    return post;
  }

  Stream<Map<String, int>> countItems(List<String> trangThaiList) {
    Map<String, int> counts = {};
    StreamController<Map<String, int>> controller = StreamController.broadcast();
    List<StreamSubscription> subscriptions = [];
    for (var type in trangThaiList) {
      final sub = serviceCollection.where('trangThai', isEqualTo: type).snapshots().listen((snapshot) {
        counts[type] = snapshot.docs.length;
        controller.add({...counts});
      });
      subscriptions.add(sub);
    }
    controller.onCancel = () {
      for (var sub in subscriptions) {
        sub.cancel();
      }
    };

    return controller.stream;
  }

  void listenToNegotiatesAndUpdate(String? documentId, {String? done}) {
    String trangThai = trangThaiPosts[1];
    if (done != null) trangThai = done;
    final serviceRef = serviceCollection.doc(documentId);
    final negotiateRef = serviceRef.collection('ct_negotiates');

    _negotiateListener = negotiateRef.snapshots().listen((snapshot) async {
      if (snapshot.docs.isNotEmpty) {
        await serviceRef.update({'trangThai': trangThai});
      } else {
        await serviceRef.update({'trangThai': trangThaiPosts.first});
      }
    });
  }

  void cancelNegotiateListener() {
    _negotiateListener?.cancel();
  }

  Future<void> postNegotiateDone(String? documentIdParent, String? documentId, {int retryCount = 1}) async {
    if (retryCount >= 3) {
      throw Exception('Không thể cập nhật sau 3 lần thử.');
    }

    try {
      // Lấy reference đến document cha
      DocumentReference documentFather = serviceCollection.doc(documentIdParent);
      CollectionReference childCollection = documentFather.collection('ct_negotiates');
      DocumentReference childRef = childCollection.doc(documentId);

      childCollection.snapshots().listen((snapshot) async {
        if (snapshot.docs.isNotEmpty) {
          await childRef.update({'isChot': true});
        } else {
          await childRef.update({'isChot': false});
        }
      });
    } catch (e) {
      rethrow;
    }
  }
}
