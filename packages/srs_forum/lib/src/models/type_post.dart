import 'package:flutter/material.dart';

class TypePost {
  String? id;
  String? name;

  TypePost({
    this.id,
    this.name,
  });

  TypePost.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    return map;
  }
}
