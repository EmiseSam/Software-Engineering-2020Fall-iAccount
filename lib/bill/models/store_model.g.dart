// GENERATED CODE - DO NOT MODIFY BY HAND\
part of 'store_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Store _$StoreFromJson(Map<String, dynamic> json) {
  return Store(json['store'] as String, id: json['id'] as int);
}

Map<String, dynamic> _$StoreToJson(Store instance) =>
    <String, dynamic>{columnId: instance.id, columnStore: instance.store};
