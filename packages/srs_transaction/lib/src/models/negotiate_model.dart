class NegotiateModel {
  String? documentId;
  String? documentIdParent;
  String? email;
  double? gia;
  String? note;
  bool? isChot;
  String? createdDate;

  NegotiateModel({
    this.documentId,
    this.documentIdParent,
    this.email,
    this.gia,
    this.note,
    this.isChot,
    this.createdDate,
  });

  NegotiateModel.fromJson(dynamic json) {
    documentId = json['documentId'];
    documentIdParent = json['documentIdParent'];
    email = json['email'];
    gia = json['gia'];
    note = json['note'];
    isChot = json['isChot'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = documentId;
    map['documentIdParent'] = documentIdParent;
    map['email'] = email;
    map['gia'] = gia;
    map['note'] = note;
    map['isChot'] = isChot;
    map['createdDate'] = createdDate;

    return map;
  }
}
