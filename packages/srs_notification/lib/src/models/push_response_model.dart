class PushResponseModel {
  String? documentId;
  String? title;
  String? content;
  String? createdName;
  String? createdDate;

  PushResponseModel({
    this.documentId,
    this.title,
    this.content,
    this.createdName,
    this.createdDate,
  });

  PushResponseModel.fromJson(dynamic json) {
    documentId = json['documentId'];
    title = json['title'];
    content = json['content'];
    createdName = json['createdName'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = documentId;
    map['title'] = title;
    map['content'] = content;
    map['createdName'] = createdName;
    map['createdDate'] = createdDate;
    return map;
  }
}
