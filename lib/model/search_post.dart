// To parse this JSON data, do
//
//     final welcome = welcomeFromMap(jsonString);

import 'dart:convert';

import 'package:habar/model/author.dart';
import 'package:habar/model/post.dart';

class SearchPostResponse {
  SearchPostResponse({
    required this.searchStatistics,
    required this.pagesCount,
    required this.publicationIds,
    required this.publicationRefs,
  });

  SearchStatistics searchStatistics;
  int pagesCount;
  List<String> publicationIds;
  Map<String, Post> publicationRefs;

  factory SearchPostResponse.empty() => SearchPostResponse(
        searchStatistics: SearchStatistics.empty(),
        pagesCount: 0,
        publicationIds: [],
        publicationRefs: {},
      );

  factory SearchPostResponse.fromJson(String str) => SearchPostResponse.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SearchPostResponse.fromMap(Map<String, dynamic> json) => SearchPostResponse(
        searchStatistics: SearchStatistics.fromMap(json["searchStatistics"]),
        pagesCount: json["pagesCount"] ?? 0,
        publicationIds: json["publicationIds"] == null ? [] : List<String>.from(json["publicationIds"].map((x) => x)),
        publicationRefs: json["publicationRefs"] == null ? {} : Map.from(json["publicationRefs"]).map((k, v) => MapEntry<String, Post>(k, Post.fromMap(v))),
      );

  Map<String, dynamic> toMap() => {
        "searchStatistics": searchStatistics.toMap(),
        "pagesCount": pagesCount,
        "publicationIds": List<dynamic>.from(publicationIds.map((x) => x)),
        "publicationRefs": Map.from(publicationRefs).map((k, v) => MapEntry<String, dynamic>(k, v.toMap())),
      };
}

// todo: delete?
class ArticleRef extends BasePost {
  ArticleRef({
    required this.id,
    required this.timePublished,
    required this.isCorporative,
    required this.titleHtml,
    required this.author,
    required this.statistics,
    required this.hubs,
    required this.leadData,
  });

  @override
  String id;
  @override
  DateTime timePublished;
  bool isCorporative;
  @override
  String titleHtml;
  @override
  BaseAuthor author;
  @override
  BaseStatistic statistics;
  List<Hub> hubs;
  @override
  final String textHtml = '';
  final LeadData leadData;

  factory ArticleRef.fromJson(String str) => ArticleRef.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ArticleRef.fromMap(Map<String, dynamic> json) => ArticleRef(
        id: json["id"] ?? 0,
        timePublished: DateTime.parse(json["timePublished"]),
        isCorporative: json["isCorporative"] ?? false,
        titleHtml: json["titleHtml"] ?? '',
        author: Author.fromMap(json["author"]),
        statistics: Statistics.fromMap(json["statistics"]),
        leadData: LeadData.fromMap(json["leadData"]),
        hubs: json["hubs"] == null ? [] : List<Hub>.from(json["hubs"].map((x) => Hub.fromMap(x))),
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "timePublished": timePublished.toIso8601String(),
        "isCorporative": isCorporative,
        "titleHtml": titleHtml,
        "author": author.toMap(),
        "statistics": statistics.toMap(),
        "hubs": List<dynamic>.from(hubs.map((x) => x.toMap())),
      };
}

class LeadData {
  LeadData({
    required this.textHtml,
    required this.imageUrl,
  });

  final String textHtml;
  final String imageUrl;

  factory LeadData.fromJson(String str) => LeadData.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory LeadData.fromMap(Map<String, dynamic> json) => LeadData(
        textHtml: json["textHtml"] ?? '',
        imageUrl: json["imageUrl"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "textHtml": textHtml,
        "imageUrl": imageUrl,
      };
}

class Author extends BaseAuthor {
  Author({
    required this.id,
    required this.login,
    required this.alias,
    required this.fullname,
    required this.avatarUrl,
    required this.speciality,
  });

  @override
  String id;
  String login;
  @override
  String alias;
  @override
  String fullname;
  @override
  String avatarUrl;
  @override
  String speciality;

  factory Author.fromJson(String str) => Author.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Author.fromMap(Map<String, dynamic> json) => Author(
        id: json["id"] ?? '',
        login: json["login"] ?? '',
        alias: json["alias"] ?? '',
        fullname: json["fullname"] ?? '',
        avatarUrl: json["avatarUrl"] ?? '',
        speciality: json["speciality"] ?? '',
      );

  @override
  Map<String, dynamic> toMap() => {
        "id": id,
        "login": login,
        "alias": alias,
        "fullname": fullname,
        "avatarUrl": avatarUrl,
        "speciality": speciality,
      };
}

enum Alias {
  POPSCI,
  DEVELOP,
  MANAGEMENT,
  MARKETING,
  ADMIN,
}

final aliasValues = EnumValues({
  "admin": Alias.ADMIN,
  "develop": Alias.DEVELOP,
  "management": Alias.MANAGEMENT,
  "marketing": Alias.MARKETING,
  "popsci": Alias.POPSCI,
});

enum Title {
  EMPTY,
  TITLE,
  PURPLE,
  FLUFFY,
  TENTACLED,
}

final titleValues = EnumValues({
  "Научпоп": Title.EMPTY,
  "Маркетинг": Title.FLUFFY,
  "Менеджмент": Title.PURPLE,
  "Администрирование": Title.TENTACLED,
  "Разработка": Title.TITLE,
});

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

enum Type {
  COLLECTIVE,
  CORPORATIVE,
}

final typeValues = EnumValues({
  "collective": Type.COLLECTIVE,
  "corporative": Type.CORPORATIVE,
});

enum Lang { RU }

final langValues = EnumValues({"ru": Lang.RU});

class PostImage {
  PostImage({
    required this.url,
  });

  String url;

  factory PostImage.fromJson(String str) => PostImage.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory PostImage.fromMap(Map<String, dynamic> json) => PostImage(
        url: json["url"] ?? '',
      );

  Map<String, dynamic> toMap() => {
        "url": url,
      };
}

class Statistics extends BaseStatistic {
  Statistics({
    required this.commentsCount,
    required this.favoritesCount,
    required this.readingCount,
    required this.score,
    required this.votesCount,
  });

  @override
  int commentsCount;
  @override
  int favoritesCount;
  @override
  int readingCount;
  @override
  int score;
  @override
  int votesCount;

  factory Statistics.fromJson(String str) => Statistics.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Statistics.fromMap(Map<String, dynamic> json) => Statistics(
        commentsCount: json["commentsCount"] ?? 0,
        favoritesCount: json["favoritesCount"] ?? 0,
        readingCount: json["readingCount"] ?? 0,
        score: json["score"] ?? 0,
        votesCount: json["votesCount"] ?? 0,
      );

  @override
  Map<String, dynamic> toMap() => {
        "commentsCount": commentsCount,
        "favoritesCount": favoritesCount,
        "readingCount": readingCount,
        "score": score,
        "votesCount": votesCount,
      };
}

enum Status { PUBLISHED }

final statusValues = EnumValues({"published": Status.PUBLISHED});

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

class EnumValues<T> {
  Map<String, T> map;

  EnumValues(this.map);

  Map<T, String> reverse() {
    return map.map((k, v) => MapEntry(v, k));
  }
}
