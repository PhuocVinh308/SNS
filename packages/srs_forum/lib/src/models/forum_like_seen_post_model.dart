class ForumLikeSeenPostModel {
  String? postId;
  String? documentId;
  String? usernameCreated;
  String? fullNameCreated;
  String? createdDate;
  bool? isDelete;

  ForumLikeSeenPostModel({
    this.postId,
    this.documentId,
    this.usernameCreated,
    this.fullNameCreated,
    this.createdDate,
    this.isDelete,
  });

  ForumLikeSeenPostModel.fromJson(dynamic json) {
    postId = json['postId'];
    documentId = json['documentId'];
    usernameCreated = json['usernameCreated'];
    fullNameCreated = json['fullNameCreated'];
    createdDate = json['createdDate'];
    isDelete = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['documentId'] = documentId;
    map['usernameCreated'] = usernameCreated;
    map['fullNameCreated'] = fullNameCreated;
    map['createdDate'] = createdDate;
    map['isDelete'] = isDelete;
    return map;
  }
}
