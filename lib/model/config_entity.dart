import 'package:snoring_app/generated/json/base/json_field.dart';
import 'package:snoring_app/generated/json/config_entity.g.dart';
import 'dart:convert';

import 'package:snoring_app/widget/pop_wheel.dart';

@JsonSerializable()
class ConfigEntity extends BaseWheelData {
  String? name;
  String? desc;
  String? code;
  String? parentName;
  String? parentCode;
  String? img;
  String? unSelectedImg;
  int? num;
  int? tag;
  int? type;
  dynamic object;
  double? width;
  double? height;
  bool? select;
  int? min;
  int? max;
  String? unit;

  ConfigEntity({
    this.name,
    this.desc,
    this.code,
    this.parentName,
    this.parentCode,
    this.img,
    this.unSelectedImg,
    this.num,
    this.tag,
    this.type,
    this.object,
    this.width,
    this.height,
    this.select,
    this.min,
    this.max,
    this.unit,
  });

  factory ConfigEntity.fromJson(Map<String, dynamic> json) =>
      $ConfigEntityFromJson(json);

  Map<String, dynamic> toJson() => $ConfigEntityToJson(this);

  @override
  String toString() {
    return jsonEncode(this);
  }

  @override
  getTitle() {
    return name;
  }
}
