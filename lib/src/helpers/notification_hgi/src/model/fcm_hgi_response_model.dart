class FcmHgiResponseModel {
  String? uuid;
  String? maChucDanh;
  String? ngayTao;
  String? nguoiTao;
  String? tinhTao;
  String? huyenTao;
  String? xaTao;
  String? apTao;
  String? tinhThuongTru;
  String? huyenThuongTru;
  String? xaThuongTru;
  String? apThuongTru;
  String? tieuDe;
  String? noiDung;
  String? listUuidNguoiDan;

  FcmHgiResponseModel({
    this.uuid,
    this.maChucDanh,
    this.ngayTao,
    this.nguoiTao,
    this.tinhTao,
    this.huyenTao,
    this.xaTao,
    this.apTao,
    this.tinhThuongTru,
    this.huyenThuongTru,
    this.xaThuongTru,
    this.apThuongTru,
    this.listUuidNguoiDan,
    this.tieuDe,
    this.noiDung,
  });

  FcmHgiResponseModel.fromJson(dynamic json) {
    uuid = json['uuid'];
    maChucDanh = json['maChucDanh'];
    ngayTao = json['ngayTao'];
    nguoiTao = json['nguoiTao'];
    tinhTao = json['tinhTao'];
    huyenTao = json['huyenTao'];
    xaTao = json['xaTao'];
    apTao = json['apTao'];
    tinhThuongTru = json['tinhThuongTru'];
    xaThuongTru = json['xaThuongTru'];
    huyenThuongTru = json['huyenThuongTru'];
    apThuongTru = json['apThuongTru'];
    tieuDe = json['tieuDe'];
    noiDung = json['noiDung'];
    listUuidNguoiDan = json["listUuidNguoiDan"];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['uuid'] = uuid;
    map['maChucDanh'] = maChucDanh;
    map['ngayTao'] = ngayTao;
    map['nguoiTao'] = nguoiTao;
    map['tinhTao'] = tinhTao;
    map['huyenTao'] = huyenTao;
    map['xaTao'] = xaTao;
    map['apTao'] = apTao;
    map['tinhThuongTru'] = tinhThuongTru;
    map['huyenThuongTru'] = huyenThuongTru;
    map['xaThuongTru'] = xaThuongTru;
    map['apThuongTru'] = apThuongTru;
    map['tieuDe'] = tieuDe;
    map['noiDung'] = noiDung;
    map['listUuidNguoiDan'] = listUuidNguoiDan;
    return map;
  }
}
