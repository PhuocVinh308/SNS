import 'package:srs_common/srs_common.dart';
import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumService {
  final FirebaseFirestore fireStore = FirebaseFirestore.instance;
  CollectionReference forumCollection = FirebaseFirestore.instance.collection('tb_forum');
  final int _limit = 10;
  DocumentSnapshot? _lastDoc;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<DateTimeStrings> postForum(ForumPostModel data) async {
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      String documentId = result.postForumFormat;
      String createdDate = result.standardFormat;
      DocumentReference forumRef = forumCollection.doc(documentId);

      final docSnapshot = await forumRef.get();

      if (!docSnapshot.exists) {
        // Sử dụng data được truyền vào hoặc empty map nếu null
        data.documentId = documentId;
        data.createdDate = createdDate;
        final dataToSave = {
          // 'documentId': documentId,
          // 'createdDate': createdDate,
          ...data.toJson(), // Spread operator với null check
        };
        await forumRef.set(dataToSave);
        return result;
      } else {
        // Nếu document đã tồn tại, gọi lại hàm để tạo ID mới
        return await postForum(data);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTimeStrings> postForumChild({
    required ForumCollectionSub type,
    required ForumPostChildModel dataChild,
  }) async {
    // Lấy reference đến document cha
    DocumentReference documentFather = forumCollection.doc(dataChild.postId);
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      late String collectionNameChild;
      late String documentIdChild;
      late String createdDateChild;
      switch (type) {
        case ForumCollectionSub.like:
          collectionNameChild = 'ct_like';
          documentIdChild = result.postLikeFormat;
          createdDateChild = result.standardFormat;
          break;
        case ForumCollectionSub.seen:
          collectionNameChild = 'ct_seen';
          documentIdChild = result.postSeenFormat;
          createdDateChild = result.standardFormat;
          break;
        case ForumCollectionSub.cmt:
          collectionNameChild = 'ct_cmt';
          documentIdChild = result.postCmtFormat;
          createdDateChild = result.standardFormat;
          break;
        default:
          collectionNameChild = 'ct_seen';
          documentIdChild = result.postSeenFormat;
          createdDateChild = result.standardFormat;
          break;
      }
      CollectionReference childCollection = documentFather.collection(collectionNameChild);
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
        return await postForumChild(type: type, dataChild: dataChild);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteForumChildDocument({
    required ForumCollectionSub type,
    required ForumPostChildModel dataChild,
    String? documentIdChild,
  }) async {
    // Lấy reference đến document cha
    DocumentReference documentFather = forumCollection.doc(dataChild.postId);
    try {
      late String collectionNameChild;
      switch (type) {
        case ForumCollectionSub.like:
          collectionNameChild = 'ct_like';
          break;
        case ForumCollectionSub.seen:
          collectionNameChild = 'ct_seen';
          break;
        case ForumCollectionSub.cmt:
          collectionNameChild = 'ct_cmt';
          break;
        default:
          collectionNameChild = 'ct_seen';
          break;
      }
      CollectionReference childCollection = documentFather.collection(collectionNameChild);
      DocumentReference childRef = childCollection.doc(documentIdChild);
      final docSnapshotChild = await childRef.delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTimeStrings> _addSubCollectionToDocument({
    required String fatherId,
    required ForumCollectionSub type,
    Map<String, dynamic>? dataChild,
  }) async {
    // Lấy reference đến document cha
    DocumentReference documentFather = forumCollection.doc(fatherId);
    try {
      DateTimeStrings result = generateBothDateTimeStrings();
      late String collectionNameChild;
      late String documentIdChild;
      late String createdDateChild;
      switch (type) {
        case ForumCollectionSub.cmt:
          collectionNameChild = 'ct_cmt';
          documentIdChild = result.postCmtFormat;
          createdDateChild = result.standardFormat;
          break;
        case ForumCollectionSub.like:
          collectionNameChild = 'ct_like';
          documentIdChild = result.postLikeFormat;
          createdDateChild = result.standardFormat;
          break;
        case ForumCollectionSub.seen:
          collectionNameChild = 'ct_seen';
          documentIdChild = result.postSeenFormat;
          createdDateChild = result.standardFormat;
          break;
        default:
          collectionNameChild = 'ct_cmt';
          documentIdChild = result.postCmtFormat;
          createdDateChild = result.standardFormat;
          break;
      }
      CollectionReference childCollection = documentFather.collection(collectionNameChild);
      DocumentReference childRef = childCollection.doc(documentIdChild);

      final docSnapshotChild = await childRef.get();
      if (!docSnapshotChild.exists) {
        // Sử dụng data được truyền vào hoặc empty map nếu null
        final dataToSave = {
          'documentId': documentIdChild,
          'createdDate': createdDateChild,
          ...?dataChild, // Spread operator với null check
        };
        await childRef.set(dataToSave);
        return result;
      } else {
        // Nếu document đã tồn tại, gọi lại hàm để tạo ID mới
        return await _addSubCollectionToDocument(fatherId: fatherId, type: type, dataChild: dataChild);
      }
    } catch (e) {
      rethrow;
    }
  }

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

  Future<int> fetchCountFireStoreDataBySubCollectionSync({
    required String documentId,
    required String subCollectionPath,
  }) async {
    try {
      final querySnapshot = await forumCollection.doc(documentId).collection(subCollectionPath).get();
      return querySnapshot.size;
    } catch (e) {
      rethrow;
    }
  }

  void resetPagination() {
    _lastDoc = null;
    _hasMore = true;
  }

  Future<List<ForumPostModel>> fetchForumPosts({String? tag}) async {
    if (!_hasMore) return [];

    Query query = forumCollection.orderBy("createdDate", descending: true);

    if (tag?.isNotEmpty == true) {
      query = query.where("tag", isEqualTo: tag);
    }

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

  Future<ForumPostModel> _mapDocToPost(DocumentSnapshot doc) async {
    final post = ForumPostModel.fromJson(doc.data() as Map<String, dynamic>);

    final subCounts = await Future.wait([
      doc.reference.collection('ct_cmt').count().get(),
      doc.reference.collection('ct_like').count().get(),
      doc.reference.collection('ct_seen').count().get(),
    ]);

    post.countCmt = subCounts[0].count ?? 0;
    post.countLike = subCounts[1].count ?? 0;
    post.countSeen = subCounts[2].count ?? 0;

    return post;
  }

  void fetchCmtSync({
    String? documentId,
    required Function(QuerySnapshot) onListen,
  }) {
    try {
      forumCollection.doc(documentId).collection('ct_cmt').orderBy('createdDate', descending: true).snapshots().listen(
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

  void fetchLikeSync({
    String? documentId,
    required Function(QuerySnapshot) onListen,
  }) {
    try {
      forumCollection.doc(documentId).collection('ct_like').where('usernameCreated', isEqualTo: CustomGlobals().userInfo.username).snapshots().listen(
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

enum ForumCollectionSub { cmt, like, seen }
