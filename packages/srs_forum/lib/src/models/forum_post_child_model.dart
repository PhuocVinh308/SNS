class ForumPostChildModel {
  String? postId;
  String? documentId;
  String? usernameCreated;
  String? fullNameCreated;
  String? createdDate;
  bool? isDelete;
  String? content;
  String? fileUrl;
  String? fileId;
  int? countLike;

  ForumPostChildModel({
    this.postId,
    this.documentId,
    this.usernameCreated,
    this.fullNameCreated,
    this.createdDate,
    this.isDelete,
    this.content,
    this.fileUrl,
    this.fileId,
  });
  ForumPostChildModel.fromJson(dynamic json) {
    postId = json['postId'];
    documentId = json['documentId'];
    usernameCreated = json['usernameCreated'];
    fullNameCreated = json['fullNameCreated'];
    createdDate = json['createdDate'];
    isDelete = json['isDelete'];
    content = json['content'];
    fileUrl = json['fileUrl'];
    fileId = json['fileId'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['postId'] = postId;
    map['documentId'] = documentId;
    map['usernameCreated'] = usernameCreated;
    map['fullNameCreated'] = fullNameCreated;
    map['createdDate'] = createdDate;
    map['isDelete'] = isDelete;
    map['content'] = content;
    map['fileUrl'] = fileUrl;
    map['fileId'] = fileId;
    return map;
  }
}
