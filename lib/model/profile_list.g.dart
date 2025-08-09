// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileList _$ProfileListFromJson(Map<String, dynamic> json) => ProfileList(
      userIds:
          (json['userIds'] as List<dynamic>).map((e) => e as String).toList(),
      userRefs: (json['userRefs'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, Invited.fromJson(e as Map<String, dynamic>)),
      ),
      pagesCount: (json['pagesCount'] as num).toInt(),
    );

Map<String, dynamic> _$ProfileListToJson(ProfileList instance) =>
    <String, dynamic>{
      'pagesCount': instance.pagesCount,
      'userIds': instance.userIds,
      'userRefs': instance.userRefs,
    };

Invited _$InvitedFromJson(Map<String, dynamic> json) => Invited(
      id: json['id'] as String,
      alias: json['alias'] as String,
      flullname: json['flullname'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      speciality: json['speciality'] as String?,
    );

Map<String, dynamic> _$InvitedToJson(Invited instance) => <String, dynamic>{
      'id': instance.id,
      'alias': instance.alias,
      'flullname': instance.flullname,
      'avatarUrl': instance.avatarUrl,
      'speciality': instance.speciality,
    };
