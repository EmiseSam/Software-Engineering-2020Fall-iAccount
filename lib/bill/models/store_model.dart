import 'package:i_account/db/column.dart';
import 'package:json_annotation/json_annotation.dart';
part 'store_model.g.dart';

@JsonSerializable()
class Store extends Object {
  @JsonKey(name: 'id')
  int id;

  @JsonKey(name: 'store')
  String store;

  Store(String store, {int id}) {
    this.id = id;
    this.store = store;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{columnStore: store};
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }

  Store.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    store = map[columnStore];
  }
  factory Store.fromJson(Map<String, dynamic> srcJson) =>
      _$StoreFromJson(srcJson);

  Map<String, dynamic> toJson() => _$StoreToJson(this);
}
