class TransactionModel {
  String? documentId;
  String? title;
  String? description;
  String? danhMuc; // Danh mục (vd: Lúa gạo, Rau củ)
  String? diaDiem;
  double? gia;
  String? trangThai; // Trạng thái (đang bán, đã thương lượng, đã hoàn thành)
  String? fileId;
  String? fileUrl;
  double? dienTich;
  String? giongLua;
  String? ngayGieoSa;
  String? ngayThuHoach;
  String? email;
  bool? isVerified;
  String? createdDate;

  TransactionModel({
    this.documentId,
    this.title,
    this.description,
    this.danhMuc,
    this.diaDiem,
    this.gia,
    this.trangThai,
    this.fileId,
    this.fileUrl,
    this.dienTich,
    this.giongLua,
    this.ngayGieoSa,
    this.ngayThuHoach,
    this.email,
    this.isVerified,
    this.createdDate,
  });

  TransactionModel.fromJson(dynamic json) {
    documentId = json['documentId'];
    title = json['title'];
    description = json['description'];
    danhMuc = json['danhMuc'];
    diaDiem = json['diaDiem'];
    gia = json['gia'];
    trangThai = json['trangThai'];
    fileId = json['fileId'];
    fileUrl = json['fileUrl'];
    dienTich = json['dienTich'];
    giongLua = json['giongLua'];
    ngayGieoSa = json['ngayGieoSa'];
    ngayThuHoach = json['ngayThuHoach'];
    email = json['email'];
    isVerified = json['isVerified'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = documentId;
    map['title'] = title;
    map['description'] = description;
    map['danhMuc'] = danhMuc;
    map['diaDiem'] = diaDiem;
    map['gia'] = gia;
    map['trangThai'] = trangThai;
    map['fileId'] = fileId;
    map['fileUrl'] = fileUrl;
    map['dienTich'] = dienTich;
    map['giongLua'] = giongLua;
    map['ngayGieoSa'] = ngayGieoSa;
    map['ngayThuHoach'] = ngayThuHoach;
    map['email'] = email;
    map['isVerified'] = isVerified;
    map['createdDate'] = createdDate;
    return map;
  }
}
