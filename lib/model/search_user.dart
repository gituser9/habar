// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

class SearchUserResponse {
  SearchUserResponse({
    required this.userIds,
    required this.userRefs,
    required this.pagesCount,
    required this.searchStatistics,
  });

  List<String> userIds;
  Map<String, UserRef> userRefs;
  int pagesCount;
  SearchStatistics searchStatistics;

  factory SearchUserResponse.empty() => SearchUserResponse(
        userIds: [],
        userRefs: {},
        pagesCount: 0,
        searchStatistics: SearchStatistics.empty(),
      );

  factory SearchUserResponse.fromJson(String str) => SearchUserResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchUserResponse.fromMap(Map<String, dynamic> json) => SearchUserResponse(
        userIds: json["userIds"] == null ? [] : List<String>.from(json["userIds"].map((x) => x)),
        userRefs: json["userRefs"] == null ? {} : Map.from(json["userRefs"]).map((k, v) => MapEntry<String, UserRef>(k, UserRef.fromMap(v))),
        pagesCount: json["pagesCount"] ?? 0,
        searchStatistics: SearchStatistics.fromMap(json["searchStatistics"]),
      );

  Map<String, dynamic> toMap() => {
        "userIds": List<dynamic>.from(userIds.map((x) => x)),
        "userRefs": Map.from(userRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
        "pagesCount": pagesCount,
        "searchStatistics": searchStatistics.toMap(),
      };
}

class SearchStatistics {
  SearchStatistics({
    required this.articlesCount,
    required this.commentsCount,
    required this.hubsCount,
    required this.usersCount,
    required this.companiesCount,
  });

  int articlesCount;
  int commentsCount;
  int hubsCount;
  int usersCount;
  int companiesCount;

  factory SearchStatistics.empty() => SearchStatistics(
        articlesCount: 0,
        commentsCount: 0,
        hubsCount: 0,
        usersCount: 0,
        companiesCount: 0,
      );

  factory SearchStatistics.fromJson(String str) => SearchStatistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchStatistics.fromMap(Map<String, dynamic> json) => SearchStatistics(
        articlesCount: json["articlesCount"] ?? 0,
        commentsCount: json["commentsCount"] ?? 0,
        hubsCount: json["hubsCount"] ?? 0,
        usersCount: json["usersCount"] ?? 0,
        companiesCount: json["companiesCount"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "articlesCount": articlesCount,
        "commentsCount": commentsCount,
        "hubsCount": hubsCount,
        "usersCount": usersCount,
        "companiesCount": companiesCount,
      };
}

class UserRef {
  UserRef({
    required this.scoreStats,
    required this.rating,
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  ScoreStats scoreStats;
  double rating;
  String id;
  String login;
  String alias;
  String fullname;
  String avatarUrl;
  String speciality;

  factory UserRef.fromJson(String str) => UserRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory UserRef.fromMap(Map<String, dynamic> json) => UserRef(
        scoreStats: ScoreStats.fromMap(json["scoreStats"]),
        rating: json["rating"] == null ? 0.0 : json["rating"].toDouble(),
        id: json["id"] ?? '',
        login: json["login"] ?? '',
        alias: json["alias"] ?? '',
        fullname: json["fullname"] ?? '',
        avatarUrl: json["avatarUrl"] ?? '',
        speciality: json["speciality"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "scoreStats": scoreStats.toMap(),
        "rating": rating,
        "id": id,
        "login": login,
        "alias": alias,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "speciality": speciality,
      };
}

class Hub {
  Hub({
    required this.id,
    required this.alias,
    required this.title,
    required this.titleHtml,
  });

  String id;
  String alias;
  String title;
  String titleHtml;

  factory Hub.fromJson(String str) => Hub.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Hub.fromMap(Map<String, dynamic> json) => Hub(
        id: json["id"] ?? '',
        alias: json["alias"] ?? '',
        title: json["title"] ?? '',
        titleHtml: json["titleHtml"] ?? '',
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

  double score;
  int votesCount;

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
