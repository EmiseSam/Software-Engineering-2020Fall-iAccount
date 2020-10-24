import 'package:i_account/db/column.dart';

class BillClasssification extends Object {
  int id;
  String classification1;
  String classification2;

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

  BillClasssification(String bc1, [String bc2]) {
    this.classification1 = bc1;
    this.classification2 = bc2;
  }

  BillClasssification.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    classification1 = map[columnClassification1];
    classification2 = map[columnClassification2];
  }
}
