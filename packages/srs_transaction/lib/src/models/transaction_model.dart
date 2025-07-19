import 'package:intl/intl.dart';

class TransactionModel {
  String? documentId;
  String? title; // Tiêu đề tin đăng
  String? description; // Mô tả chi tiết
  String? danhMuc; // Danh mục (vd: Lúa gạo, Rau củ)
  String? diaDiem; // Địa điểm
  double? gia; // Giá mong muốn
  String? trangThai; // Trạng thái (đang bán, đã thương lượng, đã hoàn thành)
  double? dienTich; // Diện tích (hecta)
  String? giongLua; // Giống lúa
  String? ngayGieoSa; // Ngày gieo sạ
  String? ngayThuHoach; // Ngày dự kiến thu hoạch
  String? email; // ID người nông dân
  bool? isVerified; // Đã xác thực
  String? createdDate; // Ngày đăng tin

  TransactionModel({
    this.documentId,
    this.title,
    this.description,
    this.danhMuc,
    this.diaDiem,
    this.gia,
    this.trangThai,
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
    dienTich = json['dienTich'];
    giongLua = json['giongLua'];
    ngayGieoSa = json['ngayGieoSa'];
    ngayThuHoach = json['ngayThuHoach'];
    email = json['email'];
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
    map['dienTich'] = dienTich;
    map['giongLua'] = giongLua;
    map['ngayGieoSa'] = ngayGieoSa;
    map['ngayThuHoach'] = ngayThuHoach;
    map['email'] = email;
    map['createdDate'] = createdDate;
    return map;
  }
}

// Model cho thương lượng
class Negotiation {
  final String id;
  final String traderId; // ID thương lái
  final String traderName; // Tên thương lái
  final double price; // Giá đề xuất
  final String? note; // Ghi chú
  final String status; // Trạng thái (đang chờ, đã chấp nhận, từ chối)
  final DateTime createdAt; // Thời gian tạo

  Negotiation({
    required this.id,
    required this.traderId,
    required this.traderName,
    required this.price,
    this.note,
    required this.status,
    required this.createdAt,
  });

  factory Negotiation.fromJson(Map<String, dynamic> json) {
    return Negotiation(
      id: json['id'],
      traderId: json['traderId'],
      traderName: json['traderName'],
      price: json['price'].toDouble(),
      note: json['note'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'traderId': traderId,
      'traderName': traderName,
      'price': price,
      'note': note,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  String get formattedPrice => NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(price);
}

// Model cho hợp đồng
class Contract {
  final String id;
  final String transactionId; // ID giao dịch
  final double agreedPrice; // Giá đã thỏa thuận
  final DateTime signDate; // Ngày ký
  final DateTime deliveryDate; // Ngày giao hàng
  final String status; // Trạng thái hợp đồng
  final String? farmerSignature; // Chữ ký nông dân
  final String? traderSignature; // Chữ ký thương lái
  final List<String> terms; // Các điều khoản

  Contract({
    required this.id,
    required this.transactionId,
    required this.agreedPrice,
    required this.signDate,
    required this.deliveryDate,
    required this.status,
    this.farmerSignature,
    this.traderSignature,
    required this.terms,
  });

  factory Contract.fromJson(Map<String, dynamic> json) {
    return Contract(
      id: json['id'],
      transactionId: json['transactionId'],
      agreedPrice: json['agreedPrice'].toDouble(),
      signDate: DateTime.parse(json['signDate']),
      deliveryDate: DateTime.parse(json['deliveryDate']),
      status: json['status'],
      farmerSignature: json['farmerSignature'],
      traderSignature: json['traderSignature'],
      terms: List<String>.from(json['terms']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'transactionId': transactionId,
      'agreedPrice': agreedPrice,
      'signDate': signDate.toIso8601String(),
      'deliveryDate': deliveryDate.toIso8601String(),
      'status': status,
      'farmerSignature': farmerSignature,
      'traderSignature': traderSignature,
      'terms': terms,
    };
  }

  String get formattedAgreedPrice => NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(agreedPrice);

  String get formattedSignDate => DateFormat('dd/MM/yyyy').format(signDate);

  String get formattedDeliveryDate => DateFormat('dd/MM/yyyy').format(deliveryDate);
}
