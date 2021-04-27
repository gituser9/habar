import 'dart:convert';

import 'package:habar/model/profile.dart';

class ProfileList {
  ProfileList({
    required this.data,
  });

  final List<ProfileData> data;

  factory ProfileList.fromJson(String str) => ProfileList.fromMap(json.decode(str));

  factory ProfileList.fromMap(Map<String, dynamic> json) => ProfileList(
        data: json["data"] == null ? [] : List<ProfileData>.from(json["data"].map((x) => ProfileData.fromMap(x))),
      );
}
