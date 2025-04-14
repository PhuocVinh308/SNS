class FcmHgiRequestModel {
  FcmHgiRequestContent? content;

  FcmHgiRequestModel({
    this.content,
  });

  factory FcmHgiRequestModel.fromJson(Map<String, dynamic> json) => FcmHgiRequestModel(
        content: FcmHgiRequestContent.fromJson(json["message"]),
      );

  Map<String, dynamic> toJson() => {
        "message": content?.toJson(),
      };
}

class FcmHgiRequestContent {
  String? topic;
  FcmHgiRequestTitle? title;
  FcmHgiRequestBody? body;

  FcmHgiRequestContent({
    this.topic,
    this.title,
    this.body,
  });

  factory FcmHgiRequestContent.fromJson(Map<String, dynamic> json) => FcmHgiRequestContent(
        topic: json["topic"],
        title: FcmHgiRequestTitle.fromJson(json["notification"]),
        body: FcmHgiRequestBody.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "topic": topic,
        "notification": title?.toJson(),
        "data": body?.toJson(),
      };
}

class FcmHgiRequestTitle {
  String? tieuDe;
  String? noiDung;

  FcmHgiRequestTitle({
    this.tieuDe,
    this.noiDung,
  });

  factory FcmHgiRequestTitle.fromJson(Map<String, dynamic> json) => FcmHgiRequestTitle(
        tieuDe: json["title"],
        noiDung: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "title": tieuDe,
        "body": noiDung,
      };
}

class FcmHgiRequestBody {
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
  String? listUuidNguoiDan;

  FcmHgiRequestBody({
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
  });

  FcmHgiRequestBody.fromJson(dynamic json) {
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
    map['listUuidNguoiDan'] = listUuidNguoiDan;
    return map;
  }
}
