import 'package:intl/intl.dart';

class Transaction {
  final String id;
  final String title; // Tiêu đề tin đăng
  final String description; // Mô tả chi tiết
  final String category; // Danh mục (vd: Lúa gạo, Rau củ)
  final String location; // Địa điểm
  final double price; // Giá mong muốn
  final String status; // Trạng thái (đang bán, đã thương lượng, đã hoàn thành)
  final List<String> images; // Danh sách hình ảnh
  final double area; // Diện tích (hecta)
  final String riceType; // Giống lúa
  final DateTime sowingDate; // Ngày gieo sạ
  final DateTime harvestDate; // Ngày dự kiến thu hoạch
  final String farmerId; // ID người nông dân
  final String farmerName; // Tên người nông dân
  final String farmerPhone; // Số điện thoại nông dân
  final bool isVerified; // Đã xác thực
  final DateTime createdAt; // Ngày đăng tin
  final List<Negotiation>? negotiations; // Danh sách thương lượng
  final Contract? contract; // Hợp đồng (nếu có)

  Transaction({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.location,
    required this.price,
    required this.status,
    required this.images,
    required this.area,
    required this.riceType,
    required this.sowingDate,
    required this.harvestDate,
    required this.farmerId,
    required this.farmerName,
    required this.farmerPhone,
    required this.isVerified,
    required this.createdAt,
    this.negotiations,
    this.contract,
  });

  // Tạo bản sao với các thuộc tính có thể thay đổi
  Transaction copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? location,
    double? price,
    String? status,
    List<String>? images,
    double? area,
    String? riceType,
    DateTime? sowingDate,
    DateTime? harvestDate,
    String? farmerId,
    String? farmerName,
    String? farmerPhone,
    bool? isVerified,
    DateTime? createdAt,
    List<Negotiation>? negotiations,
    Contract? contract,
  }) {
    return Transaction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      location: location ?? this.location,
      price: price ?? this.price,
      status: status ?? this.status,
      images: images ?? this.images,
      area: area ?? this.area,
      riceType: riceType ?? this.riceType,
      sowingDate: sowingDate ?? this.sowingDate,
      harvestDate: harvestDate ?? this.harvestDate,
      farmerId: farmerId ?? this.farmerId,
      farmerName: farmerName ?? this.farmerName,
      farmerPhone: farmerPhone ?? this.farmerPhone,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      negotiations: negotiations ?? this.negotiations,
      contract: contract ?? this.contract,
    );
  }

  // Chuyển đổi từ JSON
  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      location: json['location'],
      price: json['price'].toDouble(),
      status: json['status'],
      images: List<String>.from(json['images']),
      area: json['area'].toDouble(),
      riceType: json['riceType'],
      sowingDate: DateTime.parse(json['sowingDate']),
      harvestDate: DateTime.parse(json['harvestDate']),
      farmerId: json['farmerId'],
      farmerName: json['farmerName'],
      farmerPhone: json['farmerPhone'],
      isVerified: json['isVerified'],
      createdAt: DateTime.parse(json['createdAt']),
      negotiations: json['negotiations'] != null ? List<Negotiation>.from(json['negotiations'].map((x) => Negotiation.fromJson(x))) : null,
      contract: json['contract'] != null ? Contract.fromJson(json['contract']) : null,
    );
  }

  // Chuyển đổi thành JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'location': location,
      'price': price,
      'status': status,
      'images': images,
      'area': area,
      'riceType': riceType,
      'sowingDate': sowingDate.toIso8601String(),
      'harvestDate': harvestDate.toIso8601String(),
      'farmerId': farmerId,
      'farmerName': farmerName,
      'farmerPhone': farmerPhone,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'negotiations': negotiations?.map((x) => x.toJson()).toList(),
      'contract': contract?.toJson(),
    };
  }

  // Helper methods
  String get formattedPrice => NumberFormat.currency(locale: 'vi_VN', symbol: 'đ').format(price);

  String get formattedArea => '$area ha';

  String get formattedSowingDate => DateFormat('dd/MM/yyyy').format(sowingDate);

  String get formattedHarvestDate => DateFormat('dd/MM/yyyy').format(harvestDate);

  String get timeAgo {
    final difference = DateTime.now().difference(createdAt);
    if (difference.inDays > 0) {
      return '${difference.inDays} ngày trước';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} phút trước';
    } else {
      return 'Vừa xong';
    }
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
