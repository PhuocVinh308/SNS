// To parse this JSON data, do
//
//     final driveServiceModel = driveServiceModelFromJson(jsonString);

import 'dart:convert';

DriveServiceModel driveServiceModelFromJson(String str) => DriveServiceModel.fromJson(json.decode(str));

String driveServiceModelToJson(DriveServiceModel data) => json.encode(data.toJson());

class DriveServiceModel {
  String? key;

  DriveServiceModel({
    this.key,
  });

  factory DriveServiceModel.fromJson(Map<String, dynamic> json) => DriveServiceModel(
        key: json["key"],
      );

  Map<String, dynamic> toJson() => {
        "key": key,
      };
}
