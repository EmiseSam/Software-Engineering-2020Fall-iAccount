// GENERATED CODE - DO NOT MODIFY BY HAND\
part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************
Member _$MemberFromJson(Map<String, dynamic> json) {
  return Member(
    json['member'] as String,
    json['id'] as int,
  );
}

Map<String, dynamic> _$MemberToJson(Member instance) =>
    <String, dynamic>{columnId: instance.id, columnMember: instance.member};
