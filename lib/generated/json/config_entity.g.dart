import 'package:snoring_app/generated/json/base/json_convert_content.dart';
import 'package:snoring_app/model/config_entity.dart';
import 'package:snoring_app/widget/pop_wheel.dart';


ConfigEntity $ConfigEntityFromJson(Map<String, dynamic> json) {
  final ConfigEntity configEntity = ConfigEntity();
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    configEntity.name = name;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    configEntity.desc = desc;
  }
  final String? code = jsonConvert.convert<String>(json['code']);
  if (code != null) {
    configEntity.code = code;
  }
  final String? parentName = jsonConvert.convert<String>(json['parentName']);
  if (parentName != null) {
    configEntity.parentName = parentName;
  }
  final String? parentCode = jsonConvert.convert<String>(json['parentCode']);
  if (parentCode != null) {
    configEntity.parentCode = parentCode;
  }
  final String? img = jsonConvert.convert<String>(json['img']);
  if (img != null) {
    configEntity.img = img;
  }
  final String? unSelectedImg = jsonConvert.convert<String>(
      json['unSelectedImg']);
  if (unSelectedImg != null) {
    configEntity.unSelectedImg = unSelectedImg;
  }
  final int? num = jsonConvert.convert<int>(json['num']);
  if (num != null) {
    configEntity.num = num;
  }
  final int? tag = jsonConvert.convert<int>(json['tag']);
  if (tag != null) {
    configEntity.tag = tag;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    configEntity.type = type;
  }
  final dynamic object = json['object'];
  if (object != null) {
    configEntity.object = object;
  }
  final double? width = jsonConvert.convert<double>(json['width']);
  if (width != null) {
    configEntity.width = width;
  }
  final double? height = jsonConvert.convert<double>(json['height']);
  if (height != null) {
    configEntity.height = height;
  }
  final bool? select = jsonConvert.convert<bool>(json['select']);
  if (select != null) {
    configEntity.select = select;
  }
  final int? min = jsonConvert.convert<int>(json['min']);
  if (min != null) {
    configEntity.min = min;
  }
  final int? max = jsonConvert.convert<int>(json['max']);
  if (max != null) {
    configEntity.max = max;
  }
  final String? unit = jsonConvert.convert<String>(json['unit']);
  if (unit != null) {
    configEntity.unit = unit;
  }
  return configEntity;
}

Map<String, dynamic> $ConfigEntityToJson(ConfigEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['name'] = entity.name;
  data['desc'] = entity.desc;
  data['code'] = entity.code;
  data['parentName'] = entity.parentName;
  data['parentCode'] = entity.parentCode;
  data['img'] = entity.img;
  data['unSelectedImg'] = entity.unSelectedImg;
  data['num'] = entity.num;
  data['tag'] = entity.tag;
  data['type'] = entity.type;
  data['object'] = entity.object;
  data['width'] = entity.width;
  data['height'] = entity.height;
  data['select'] = entity.select;
  data['min'] = entity.min;
  data['max'] = entity.max;
  data['unit'] = entity.unit;
  return data;
}

extension ConfigEntityExtension on ConfigEntity {
  ConfigEntity copyWith({
    String? name,
    String? desc,
    String? code,
    String? parentName,
    String? parentCode,
    String? img,
    String? unSelectedImg,
    int? num,
    int? tag,
    int? type,
    dynamic object,
    double? width,
    double? height,
    bool? select,
    int? min,
    int? max,
    String? unit,
  }) {
    return ConfigEntity()
      ..name = name ?? this.name
      ..desc = desc ?? this.desc
      ..code = code ?? this.code
      ..parentName = parentName ?? this.parentName
      ..parentCode = parentCode ?? this.parentCode
      ..img = img ?? this.img
      ..unSelectedImg = unSelectedImg ?? this.unSelectedImg
      ..num = num ?? this.num
      ..tag = tag ?? this.tag
      ..type = type ?? this.type
      ..object = object ?? this.object
      ..width = width ?? this.width
      ..height = height ?? this.height
      ..select = select ?? this.select
      ..min = min ?? this.min
      ..max = max ?? this.max
      ..unit = unit ?? this.unit;
  }
}