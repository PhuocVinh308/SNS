class ForumLikeSeenPostModel {
  String? postId;
  String? documentId;
  String? usernameCreated;
  String? createdDate;
  bool? isDelete;

  ForumLikeSeenPostModel({
    this.postId,
    this.documentId,
    this.usernameCreated,
    this.createdDate,
    this.isDelete,
  });

  ForumLikeSeenPostModel.fromJson(dynamic json) {
    postId = json['postId'];
    documentId = json['documentId'];
    usernameCreated = json['usernameCreated'];
    createdDate = json['createdDate'];
    isDelete = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['documentId'] = documentId;
    map['usernameCreated'] = usernameCreated;
    map['createdDate'] = createdDate;
    map['isDelete'] = isDelete;
    return map;
  }
}
