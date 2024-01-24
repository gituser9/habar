import 'dart:convert';

import 'package:habar/model/profile.dart';

class ProfileList {
  ProfileList({
    required this.userIds,
    required this.userRefs,
  });

  final List<String> userIds;
  final List<Invited> userRefs;

  factory ProfileList.fromJson(String str) => ProfileList.fromMap(json.decode(str));

  factory ProfileList.fromMap(Map<String, dynamic> json) => ProfileList(
      userIds: json["userIds"] == null ? [] : List<String>.from(json["userIds"].map((x) => ProfileData.fromMap(x))),
      userRefs: json["userRefs"] == null ? [] : Invited.buildListFromJson(json["userRefs"]));
}

class Invited {
  final String id;
  final String alias;
  final String flullname;
  final String avatarUrl;
  final String speciality;

  Invited({
    required this.id,
    required this.alias,
    required this.flullname,
    required this.avatarUrl,
    required this.speciality,
  });

  factory Invited.fromMap(Map<String, dynamic> json) => Invited(
        id: json["id"] ?? '',
        alias: json["alias"] ?? '',
        flullname: json["flullname"] ?? '',
        avatarUrl: json["avatarUrl"] ?? '',
        speciality: json["speciality"] ?? '',
      );

  static List<Invited> buildListFromJson(Map<String, dynamic> json) {
    var names = json.keys;
    List<Invited> inviteds = [];

    for (final name in names) {
      var js = json[name];

      inviteds.add(Invited.fromMap(js));
    }

    return inviteds;
  }
}
