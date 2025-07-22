class DiaryModel {
  String? documentId;
  String? documentIdParent;
  bool? loaiNhatKy;
  String? danhMuc;
  String? soTien;
  String? moTa;
  double? ngayGiaoDich;
  String? createdDate;

  DiaryModel({
    this.documentId,
    this.documentIdParent,
    this.loaiNhatKy,
    this.danhMuc,
    this.soTien,
    this.moTa,
    this.ngayGiaoDich,
    this.createdDate,
  });

  DiaryModel.fromJson(dynamic json) {
    documentId = json['documentId'];
    documentIdParent = json['documentIdParent'];
    loaiNhatKy = json['loaiNhatKy'];
    danhMuc = json['danhMuc'];
    soTien = json['soTien'];
    moTa = json['moTa'];
    ngayGiaoDich = json['ngayGiaoDich'];
    createdDate = json['createdDate'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['documentId'] = documentId;
    map['documentIdParent'] = documentIdParent;
    map['loaiNhatKy'] = loaiNhatKy;
    map['danhMuc'] = danhMuc;
    map['soTien'] = soTien;
    map['moTa'] = moTa;
    map['ngayGiaoDich'] = ngayGiaoDich;
    map['createdDate'] = createdDate;
    return map;
  }
}
