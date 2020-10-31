import 'package:i_account/db/column.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryItem extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'classification1')
  String classification1;

  @JsonKey(name: 'classification2')
  String classification2;

  CategoryItem(this.classification1, [this.classification2, this.id]);

  CategoryItem.fromMap(Map<String, dynamic> map) {
    classification1 = map[columnClassification1];
    classification2 = map[columnClassification2];
    id = map[columnId];
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnClassification1: classification1,
      columnClassification2: classification2
    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  factory CategoryItem.fromJson(Map<String, dynamic> srcJson) =>
      _$CategoryItemFromJson(srcJson);

  Map<String, dynamic> toJson() => _$CategoryItemToJson(this);
}
