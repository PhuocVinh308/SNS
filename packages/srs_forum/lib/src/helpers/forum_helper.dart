import 'package:srs_common/srs_common_lib.dart';
import 'package:srs_forum/srs_forum.dart';

class ForumHelper {
  static final service = ForumService();
  static RxList<ForumPostModel> listNewPost = <ForumPostModel>[].obs;

  static Future<void> initNewForumPost() async {
    try {
      service.fetchForumPostNewSync(
        onListen: (snapshot) async {
          final res = await Future.wait(snapshot.docs.map(_mapDocToPost));
          listNewPost.value = res.toList();
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<ForumPostModel> _mapDocToPost(DocumentSnapshot doc) async {
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
}
