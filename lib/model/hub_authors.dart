import 'dart:convert';

import 'package:habar/model/author.dart';

class HubAuthorList {
  HubAuthorList({
    required this.pagesCount,
    required this.authorIds,
    required this.authorRefs,
  });

  final int pagesCount;
  final List<String> authorIds;
  final Map<String, HubAuthorRef> authorRefs;

  factory HubAuthorList.fromJson(String str) => HubAuthorList.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubAuthorList.fromMap(Map<String, dynamic> json) => HubAuthorList(
        pagesCount: json["pagesCount"] ?? [],
        authorIds: json["authorIds"] == null ? [] : List<String>.from(json["authorIds"].map((x) => x)),
        authorRefs:
            json["authorRefs"] == null ? {} : Map.from(json["authorRefs"]).map((k, v) => MapEntry<String, HubAuthorRef>(k, HubAuthorRef.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "pagesCount": pagesCount,
        "authorIds": List<dynamic>.from(authorIds.map((x) => x)),
        "authorRefs": Map.from(authorRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

class HubAuthorRef extends BaseAuthor {
  HubAuthorRef({
    required this.scoreStats,
    required this.rating,
    required this.id,
    // required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  final ScoreStats scoreStats;
  final double rating;

  // final String login;
  @override
  final String id;
  @override
  final String alias;
  @override
  final String fullname;
  @override
  final String avatarUrl;
  @override
  final String speciality;

  factory HubAuthorRef.fromJson(String str) => HubAuthorRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubAuthorRef.fromMap(Map<String, dynamic> json) => HubAuthorRef(
        scoreStats: ScoreStats.fromMap(json["scoreStats"]),
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
        id: json["id"] ?? '',
        // login: json["login"] == null ? '' : json["login"],
        alias: json["alias"] ?? '',
        fullname: json["fullname"] ?? '',
        avatarUrl: json["avatarUrl"] ?? '',
        speciality: json["speciality"] ?? '',
      );

  @override
  Map<String, dynamic> toMap() => {
        "scoreStats": scoreStats.toMap(),
        "rating": rating,
        "id": id,
        // "login": login,
        "alias": alias,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "speciality": speciality,
      };
}

class HubShort {
  HubShort({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  final String id;
  final String alias;
  final String title;
  final String titleHtml;

  factory HubShort.fromJson(String str) => HubShort.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory HubShort.fromMap(Map<String, dynamic> json) => HubShort(
        id: json["id"],
        alias: json["alias"],
        title: json["title"],
        titleHtml: json["titleHtml"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "alias": alias,
        "title": title,
        "titleHtml": titleHtml,
      };
}

class ScoreStats {
  ScoreStats({
    required this.score,
    required this.votesCount,
  });

  final double score;
  final int votesCount;

  factory ScoreStats.fromJson(String str) => ScoreStats.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ScoreStats.fromMap(Map<String, dynamic> json) => ScoreStats(
        score: json["score"] == null ? 0.0 : json["score"].toDouble(),
        votesCount: json["votesCount"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "score": score,
        "votesCount": votesCount,
      };
}
