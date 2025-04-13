class ReceivedModel {
  ReceivedModel({
    this.id,
    this.title,
    this.body,
    this.payload,
  });

  int? id;
  String? title;
  String? body;
  String? payload;

  ReceivedModel.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    body = json['body'];
    payload = json['payload'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['body'] = body;
    map['payload'] = payload;
    return map;
  }
}
