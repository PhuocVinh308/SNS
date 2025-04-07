class ForumPostModel {
  String? tag;
  String? title;
  String? content;
  String? documentId;
  String? usernameCreated;
  String? fullNameCreated;
  String? fileId;
  String? fileUrl;
  String? createdDate;
  bool? isDelete;
  //
  dynamic countCmt;
  dynamic countLike;
  dynamic countSeen;

  ForumPostModel({
    this.tag,
    this.title,
    this.content,
    this.documentId,
    this.usernameCreated,
    this.fullNameCreated,
    this.fileId,
    this.fileUrl,
    this.createdDate,
    this.isDelete,
  });

  ForumPostModel.fromJson(dynamic json) {
    tag = json['tag'];
    title = json['title'];
    content = json['content'];
    documentId = json['documentId'];
    usernameCreated = json['usernameCreated'];
    fullNameCreated = json['fullNameCreated'];
    fileId = json['fileId'];
    fileUrl = json['fileUrl'];
    createdDate = json['createdDate'];
    isDelete = json['isDelete'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['tag'] = tag;
    map['title'] = title;
    map['content'] = content;
    map['documentId'] = documentId;
    map['usernameCreated'] = usernameCreated;
    map['fullNameCreated'] = fullNameCreated;
    map['fileId'] = fileId;
    map['fileUrl'] = fileUrl;
    map['createdDate'] = createdDate;
    map['isDelete'] = isDelete;
    return map;
  }
}
