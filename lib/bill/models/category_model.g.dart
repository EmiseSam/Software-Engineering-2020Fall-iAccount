// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryItem _$CategoryItemFromJson(Map<String, dynamic> json) {
  return CategoryItem(
    json['classification1'] as String,
    json['classification2'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$CategoryItemToJson(CategoryItem instance) =>
    <String, dynamic>{
      columnClassification1: instance.classification1,
      columnClassification2: instance.classification2,
      columnId: instance.id
    };
