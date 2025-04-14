// To parse this JSON data, do
//
//     final FcmServiceModel = FcmServiceModelFromJson(jsonString);

import 'dart:convert';

FcmServiceModel fcmServiceModelFromJson(String str) => FcmServiceModel.fromJson(json.decode(str));

String fcmServiceModelToJson(FcmServiceModel data) => json.encode(data.toJson());

class FcmServiceModel {
  String? key;

  FcmServiceModel({
    this.key,
  });

  factory FcmServiceModel.fromJson(Map<String, dynamic> json) => FcmServiceModel(
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
      };
}
