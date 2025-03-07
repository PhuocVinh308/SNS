import 'package:flutter/material.dart';

class MenuModel {
  int? id;
  String? name;
  String? image;
  String? route;

  MenuModel({
    this.id,
    this.name,
    this.image,
    this.route,
  });

  MenuModel.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    route = json['route'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['image'] = image;
    map['route'] = route;

    return map;
  }
}
