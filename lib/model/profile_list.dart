import 'package:json_annotation/json_annotation.dart';

part 'profile_list.g.dart';

@JsonSerializable()
class ProfileList {
  ProfileList({
    required this.userIds,
    required this.userRefs,
    required this.pagesCount,
  });

  final int pagesCount;
  final List<String> userIds;
  final Map<String, Invited> userRefs;

  factory ProfileList.fromJson(Map<String, dynamic> json) => _$ProfileListFromJson(json);
}

@JsonSerializable()
class Invited {
  final String id;
  final String alias;
  final String? flullname;
  final String? avatarUrl;
  final String? speciality;

  Invited({
    required this.id,
    required this.alias,
    required this.flullname,
    required this.avatarUrl,
    required this.speciality,
  });

  factory Invited.fromJson(Map<String, dynamic> json) => _$InvitedFromJson(json);
}
