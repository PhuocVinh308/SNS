class LoginResponseModel {
  String? status;
  String? message;
  UserResponseModel? data;

  LoginResponseModel({
    this.status,
    this.message,
    this.data,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) => LoginResponseModel(
        status: json["status"],
        message: json["message"],
        data: UserResponseModel.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(),
      };
}

class UserResponseModel {
  String? token;
  UserInfoModel? user;

  UserResponseModel({
    this.token,
    this.user,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) => UserResponseModel(
        token: json["token"],
        user: UserInfoModel.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user?.toJson(),
      };
}

class UserInfoModel {
  int? id;
  String? uuid;
  String? username;
  String? address;
  String? phone;
  String? email;
  String? fullName;
  String? userRole;
  String? status;
  String? createdAt;
  String? updatedAt;

  UserInfoModel({
    this.id,
    this.uuid,
    this.username,
    this.address,
    this.phone,
    this.email,
    this.fullName,
    this.userRole,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) => UserInfoModel(
        id: json["id"],
        uuid: json["uuid"],
        username: json["username"],
        address: json["address"],
        phone: json["phone"],
        email: json["email"],
        fullName: json["fullName"],
        userRole: json["userRole"],
        status: json["status"],
        createdAt: json["createdAt"],
        updatedAt: json["updatedAt"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "uuid": uuid,
        "username": username,
        "address": address,
        "phone": phone,
        "email": email,
        "fullName": fullName,
        "userRole": userRole,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
      };
}
