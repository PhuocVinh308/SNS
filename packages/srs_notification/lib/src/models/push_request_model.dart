class PushRequestModel {
  PushRequestContent? content;

  PushRequestModel({
    this.content,
  });

  factory PushRequestModel.fromJson(Map<String, dynamic> json) => PushRequestModel(
        content: PushRequestContent.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": content?.toJson(),
      };
}

class PushRequestContent {
  String? topic;
  PushRequestTitle? title;
  PushRequestBody? body;

  PushRequestContent({
    this.topic,
    this.title,
    this.body,
  });

  factory PushRequestContent.fromJson(Map<String, dynamic> json) => PushRequestContent(
        topic: json["topic"],
        title: PushRequestTitle.fromJson(json["notification"]),
        body: PushRequestBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "notification": title?.toJson(),
        "data": body?.toJson(),
      };
}

class PushRequestTitle {
  String? title;
  String? content;

  PushRequestTitle({
    this.title,
    this.content,
  });

  factory PushRequestTitle.fromJson(Map<String, dynamic> json) => PushRequestTitle(
        title: json["title"],
        content: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "body": content,
      };
}

class PushRequestBody {
  String? documentId;
  String? createdName;
  String? createdDate;

  PushRequestBody({
    this.documentId,
    this.createdName,
    this.createdDate,
  });

  PushRequestBody.fromJson(dynamic json) {
    documentId = json['documentId'];
    createdName = json['createdName'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = documentId;
    map['createdName'] = createdName;
    map['createdDate'] = createdDate;
    return map;
  }
}
