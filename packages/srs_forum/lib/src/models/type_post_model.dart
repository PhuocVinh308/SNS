class TypePostModel {
  String? id;
  String? name;

  TypePostModel({
    this.id,
    this.name,
  });

  TypePostModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
